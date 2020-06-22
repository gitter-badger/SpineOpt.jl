#############################################################################
# Copyright (C) 2017 - 2018  Spine Project
#
# This file is part of SpineOpt.
#
# SpineOpt is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SpineOpt is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#############################################################################

"""
    constraint_ratio_out_in_connection_flow_indices(ratio_out_in)

Forms the stochastic index set for the `:ratio_out_in_connection_flow` constraint
for the desired `ratio_out_in`. Uses stochastic path indices due to potentially
different stochastic structures between `connection_flow` variables.
"""
function constraint_ratio_out_in_connection_flow_indices(ratio_out_in)
    unique(
        (connection=conn, node1=n_out, node2=n_in, stochastic_path=path, t=t)
        for (conn, n_out, n_in) in indices(ratio_out_in)
        for t in t_lowest_resolution(x.t for x in connection_flow_indices(connection=conn, node=[n_out, n_in]))
        for path in active_stochastic_paths(
            unique(
                ind.stochastic_scenario 
                for ind in _constraint_ratio_out_in_connection_flow_indices(conn, n_out, n_in, t)
            )
        )
    )
end

"""
    _constraint_ratio_out_in_connection_flow_indices(connection, node_out, node_in, t)

Gather the `connection_flow` variiable indices for `add_constraint_ratio_out_in_connection_flow!`.
"""
function _constraint_ratio_out_in_connection_flow_indices(connection, node_out, node_in, t)
    Iterators.flatten(
        (
            connection_flow_indices(
                connection=connection, node=node_out, direction=direction(:to_node), t=t_in_t(t_long=t)
            ),  # `to_node` `connection_flow`s
            connection_flow_indices(
                connection=connection,
                node=node_in,
                direction=direction(:from_node),
                t=to_time_slice(t - connection_flow_delay(connection=connection, node1=node_out, node2=node_in, t=t))
            )  # `from_node` `connection_flow`s with potential `connection_flow_delay`
        )
    )    
end

"""
    add_constraint_ratio_out_in_connection_flow!(m, ratio_out_in, sense)

Ratio of `connection_flow` variables.
"""
function add_constraint_ratio_out_in_connection_flow!(m::Model, ratio_out_in, sense)
    @fetch connection_flow = m.ext[:variables]
    cons = m.ext[:constraints][ratio_out_in.name] = Dict()
    for (conn, ng_out, ng_in, stochastic_path, t) in constraint_ratio_out_in_connection_flow_indices(ratio_out_in)
        con = cons[conn, ng_out, ng_in, stochastic_path, t] = sense_constraint(
            m,
            + expr_sum(
                + connection_flow[conn, n_out, d, s, t_short] * duration(t_short)
                for (conn, n_out, d, s, t_short) in connection_flow_indices(
                    connection=conn, 
                    node=ng_out, 
                    direction=direction(:to_node), 
                    stochastic_scenario=stochastic_path, 
                    t=t_in_t(t_long=t)
                );
                init=0
            ),
            sense,
            + ratio_out_in[(connection=conn, node1=ng_out, node2=ng_in, t=t)]
            * expr_sum(
                + connection_flow[conn, n_in, d, s, t_short]
                * overlap_duration(t_short, t - connection_flow_delay(connection=conn, node1=ng_out, node2=ng_in))
                for (conn, n_in, d, s, t_short) in connection_flow_indices(
                    connection=conn,
                    node=ng_in,
                    direction=direction(:from_node),
                    stochastic_scenario=stochastic_path,
                    t=to_time_slice(t - connection_flow_delay(connection=conn, node1=ng_out, node2=ng_in, t=t))
                );
                init=0
            )
        )
    end
end

"""
    add_constraint_fix_ratio_out_in_connection_flow!(m::Model)

Calls `add_constraint_ratio_out_in_connection_flow!` using the `fix_ratio_out_in_connection_flow` parameter.
"""
function add_constraint_fix_ratio_out_in_connection_flow!(m::Model)
    add_constraint_ratio_out_in_connection_flow!(m, fix_ratio_out_in_connection_flow, ==)
end

"""
    add_constraint_max_ratio_out_in_connection_flow!(m::Model)

Calls `add_constraint_ratio_out_in_connection_flow!` using the `max_ratio_out_in_connection_flow` parameter.
"""
function add_constraint_max_ratio_out_in_connection_flow!(m::Model)
    add_constraint_ratio_out_in_connection_flow!(m, max_ratio_out_in_connection_flow, <=)
end

"""
    add_constraint_min_ratio_out_in_connection_flow!(m::Model)

Calls `add_constraint_ratio_out_in_connection_flow!` using the `min_ratio_out_in_connection_flow` parameter.
"""
function add_constraint_min_ratio_out_in_connection_flow!(m::Model)
    add_constraint_ratio_out_in_connection_flow!(m, min_ratio_out_in_connection_flow, >=)
end

#############################################################################
# Copyright (C) 2017 - 2018  Spine Project
#
# This file is part of Spine Model.
#
# Spine Model is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Spine Model is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#############################################################################
#COPY from unit_state_transition"
"""
    constraint_ramp_up_indices()

Forms the stochastic index set for the `:ramp_up` constraint.
Uses stochastic path indices due to potentially different stochastic scenarios
between `t_after` and `t_before`.
"""
function constraint_ramp_up_indices()
    constraint_indices = []
    for (u, ng, d) in indices(ramp_up_limit)
        for t in t_lowest_resolution(x.t for x in ramp_up_unit_flow_indices(unit=u,node=ng,direction=d))
            #NOTE: we're assuming that the ramp constraint follows the resolution of flows
            # Ensure type stability
            active_scenarios = Array{Object,1}()
            # `ramp_up_unit_flow` for `direction` `d`
            append!(
                active_scenarios,
                map(
                    inds -> inds.stochastic_scenario,
                    ramp_up_unit_flow_indices(unit=u, node=ng, direction=d, t=t_in_t(t_long=t))
                )
            )
            # `units_on`
            append!(
                active_scenarios,
                map(
                    inds -> inds.stochastic_scenario,
                    units_on_indices(unit=u, t=t_in_t(t_long=t))
                )
            )
            # Find stochastic paths for `active_scenarios`
            unique!(active_scenarios)
            for path in active_stochastic_paths(full_stochastic_paths, active_scenarios)
                push!(
                    constraint_indices,
                    (unit=u, node=ng, direction=d, stochastic_path=path, t=t)
                )
            end
        end
    end
    return unique!(constraint_indices)
end

"""
    add_constraint_ramp_up!(m::Model)

Limit the maximum ramp of `ramp_up_unit_flow` of a `unit` or `unit_group` if the parameters
`ramp_up_limit`,`unit_capacity`,`unit_conv_cap_to_unit_flow` exist.
"""

function add_constraint_ramp_up!(m::Model)
    @fetch units_on,  units_started_up, ramp_up_unit_flow = m.ext[:variables]
    constr_dict = m.ext[:constraints][:ramp_up] = Dict()
    for (u, ng, d, s, t) in constraint_ramp_up_indices()
        constr_dict[u, ng, d, s, t] = @constraint(
            m,
            + sum(
                ramp_up_unit_flow[u, n, d, s, t]
                        for (u, n, d, s, t) in ramp_up_unit_flow_indices(
                            unit=u, node=ng, direction = d, t=t, stochastic_scenario=s)
            )
            <=
            + sum(
                units_on[u, s, t] - units_started_up[u, s, t]
                    for (u,s,t) in units_on_indices(
                        unit=u, stochastic_scenario=s, t=t_overlaps_t(t)
                            )
                )
                 * ramp_up_limit[(unit=u, node=ng, direction=d, t=t, stochastic_scenario=s)]
                    *unit_conv_cap_to_flow[(unit=u, node=ng, direction=d, t=t, stochastic_scenario=s)]
                        *unit_capacity[(unit=u, node=ng, direction=d, t=t, stochastic_scenario=s)]
        )
    end
end

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
    postprocess_results!(m::Model)

Perform calculations on the model outputs and save them to the ext.values dict.
bases on contents of report__output
"""
function postprocess_results!(m::Model)
    outputs = [Symbol(x[2]) for x in report__output()]
    fns! = Dict(
        :connection_avg_throughflow => save_connection_avg_throughflow!,
        :connection_avg_intact_throughflow => save_connection_avg_intact_throughflow!,
    )
    for (_report, output) in report__output()
        fn! = get(fns!, output.name, nothing)
        fn! === nothing || fn!(m)
    end
end

function save_connection_avg_throughflow!(m::Model)
    @fetch connection_flow = m.ext[:spineopt].values
    _save_connection_avg_throughflow!(m, :connection_avg_throughflow, connection_flow)
end

function save_connection_avg_intact_throughflow!(m::Model)
    @fetch connection_intact_flow = m.ext[:spineopt].values
    _save_connection_avg_throughflow!(m, :connection_avg_intact_throughflow, connection_intact_flow)
end

function _save_connection_avg_throughflow!(m::Model, key, connection_flow)
    m_start = model_start(model=m.ext[:spineopt].instance)
    connections = connection(connection_monitored=true, has_ptdf=true)
    avg_throughflow = m.ext[:spineopt].values[key] = Dict()
    sizehint!(avg_throughflow, length(connections) * length(stochastic_scenario()) * length(time_slice(m)))
    for ((conn, n, d, s, t), value) in connection_flow
        conn in connections && start(t) >= m_start || continue
        n_from, n_to, _other_nodes... = connection__from_node(connection=conn, direction=anything)
        if (n == n_to && d == direction(:to_node)) || (n == n_from && d == direction(:from_node))
            new_value = 0.5 * value
        elseif (n == n_from && d == direction(:to_node)) || (n == n_to && d == direction(:from_node))
            new_value = 0.5 * value
        else
            continue
        end
        current_value = get(avg_throughflow, (connection=conn, stochastic_scenario=s, t=t), 0)
        avg_throughflow[(connection=conn, stochastic_scenario=s, t=t)] = current_value + new_value
    end
    avg_throughflow
end
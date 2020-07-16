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
    operating_costs(m::Model)

Create an expression for variable unit operating costs.
"""
function operating_costs(m::Model, t1)
    @fetch unit_flow = m.ext[:variables]
    @expression(
        m,
        expr_sum(
            unit_flow[u, n, d, s, t] * duration(t)
            * operating_cost[(unit=u, node=ng, direction=d, t=t)]  # op_cost(ng) = sum(op_cost(n))
            * node_stochastic_scenario_weight(node=ng, stochastic_scenario=s)
            for (u, ng, d) in indices(operating_cost)
            for (u, n, d, s, t) in unit_flow_indices(unit=u, node=ng, direction=d)
            if end_(t) <= t1;
            init=0
        )
    )
end
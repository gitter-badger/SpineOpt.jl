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
    renewable_curtailment_costs(m::Model)

Create an expression for curtailment costs of renewables.
"""
function renewable_curtailment_costs(m::Model,t1)
    @fetch unit_flow = m.ext[:variables]
    @expression(
        m,
        expr_sum(
            (unit_capacity[(unit=u, node=n, direction=d,t=t)] * unit_availability_factor[(unit=u,t=t)] - unit_flow[u, n, d, s, t])
            * duration(t)
            * renewable_curtailment_cost[(unit=u, t=t)]
            for u in indices(curtailment_cost)
            for (u, n, d) in indices(unit_capacity; unit=u)
            for (u, n, d, s, t) in unit_flow_indices(unit=u, node=n, direction=d)
            if end_(t) <= t1;
            init=0
        )
    )
end
# TODO: add weight scenario tree
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

function _constraint_unit_flow_capacity_scenarios(m::Model, unit, node, direction, t)
    (
        s
        for s in stochastic_scenario()
        if !isempty(
            unit_flow_indices(m; unit=unit, node=node, direction=direction, t=t, stochastic_scenario=s)
        )
        || !isempty(
            units_on_indices(m; unit=unit, t=t_in_t(m; t_long=t), stochastic_scenario=s)
        )
    )
end

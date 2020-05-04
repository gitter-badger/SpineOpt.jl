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
"""
    unit_flow_op_indices(
        unit=anything,
        node=anything,
        direction=anything,
        operating_point=anything,
        t=anything
    )

A list of `NamedTuple`s corresponding to indices of the `unit_flow` variable.
The keyword arguments act as filters for each dimension.
"""
function unit_flow_op_indices(;unit=anything, node=anything, direction=anything, operating_point=anything, t=anything)
    unit = expand_unit_group(unit)
    node = expand_node_group(node)
    (
        (unit=u, node=n, direction=d, i=i, t=t1)
        for (u, n) in indices(operating_points, unit=unit, node=node)
        for (u, n, d, tb) in unit_flow_indices_rc(unit=u, node=n, direction=direction, _compact=false)
        for i in intersect(operating_point, 1:length(operating_points(unit=u, node=n, direction=d)))
        for t1 in time_slice(temporal_block=tb, t=t)
    )
end

function add_variable_unit_flow_op!(m::Model)
    add_variable!(
        m,
        :unit_flow_op,
        unit_flow_op_indices;
        lb=x -> 0,
        fix_value=x -> fix_unit_flow_op(unit=x.unit, node=x.node, direction=x.direction, i=x.i, t=x.t, _strict=false)
    )
end

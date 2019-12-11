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
    create_variable_flow!(m::Model)

Add new `flow` variable to the model `m`.

This variable represents the (average) instantaneous flow of a *commodity*
between a *node* and a *unit* in a certain *direction*
and within a certain *time slice*.

"""
function create_variable_flow!(m::Model)
    KeyType = NamedTuple{(:unit, :node, :commodity, :direction, :t),Tuple{Object,Object,Object,Object,TimeSlice}}
    var = Dict{KeyType,Any}(
        (unit=u, node=n, commodity=c, direction=d, t=t) => @variable(
            m, base_name="flow[$u, $n, $c, $d, $(t.JuMP_name)]", lower_bound=0
        )
        for (u, n, c, d, t) in var_flow_indices()
    )
    fix = Dict{KeyType,Any}(
        (unit=u, node=n, commodity=c, direction=d, t=t) => fix_flow(unit=u, node=n, direction=d, t=t)
        for (u, n, c, d, t) in fix_flow_indices()
    )
    merge!(get!(m.ext[:variables], :flow, Dict{KeyType,Any}()), var, fix)
end

function variable_flow_value(m::Model)
    Dict{NamedTuple{(:unit, :node, :commodity, :direction, :t),Tuple{Object,Object,Object,Object,TimeSlice}},Any}(
        (unit=u, node=n, commodity=c, direction=d, t=t) => value(m.ext[:variables][:flow][u, n, c, d, t]) 
        for (u, n, c, d, t) in var_flow_indices()
    )
end

"""
    flow_indices(
        commodity=anything,
        node=anything,
        unit=anything,
        direction=anything,
        t=anything
    )

A list of `NamedTuple`s corresponding to indices of the `flow` variable.
The keyword arguments act as filters for each dimension.
"""
function flow_indices(;commodity=anything, node=anything, unit=anything, direction=anything, t=anything)
    [
        var_flow_indices(commodity=commodity, node=node, unit=unit, direction=direction, t=t);
        fix_flow_indices(commodity=commodity, node=node, unit=unit, direction=direction, t=t)
    ]
end

"""
    var_flow_indices(
        commodity=anything,
        node=anything,
        unit=anything,
        direction=anything,
        t=anything
    )

A list of `NamedTuple`s corresponding to *non-fixed* indices of the `flow` variable.
The keyword arguments act as filters for each dimension.
"""
function var_flow_indices(;commodity=anything, node=anything, unit=anything, direction=anything, t=anything)
    unit = expand_unit_group(unit)
    node = expand_node_group(node)
    commodity = expand_commodity_group(commodity)
    [
        (unit=u, node=n, commodity=c, direction=d, t=t1)
        for (u, n, d) in unit__node__direction(unit=unit, node=node, direction=direction, _compact=false)
        for t_blk in node__temporal_block(node=n)
        for t1 in current_time_slice(temporal_block=t_blk, t=t)
        if fix_flow(unit=u, node=n, direction=d, t=t1, _strict=false) === nothing
        for (n_, c) in node__commodity(node=n, commodity=commodity, _compact=false)
    ]
end

"""
    fix_flow_indices(
        commodity=anything,
        node=anything,
        unit=anything,
        direction=anything,
        t=anything
    )

A list of `NamedTuple`s corresponding to *fixed* indices of the `flow` variable.
The keyword arguments act as filters for each dimension.
"""
function fix_flow_indices(;commodity=anything, node=anything, unit=anything, direction=anything, t=anything)
    unit = expand_unit_group(unit)
    node = expand_node_group(node)
    commodity = expand_commodity_group(commodity)
    # We go through all indices of the `fix_flow` parameter and then through all time slices in the model.
    # If `fix_flow` has a value for any of these combinations, then we have a fix flow index.
    # NOTE that the user could specify `fix_flow` for some periods and then don't define
    # any time slice in those periods -- that will obviously be insufficient. They need to specify the
    # parameter value *and* the time slices that go along.
    [
        (unit=u, node=n, commodity=c, direction=d, t=t_)
        for (u, n, d) in indices(fix_flow; unit=unit, node=node, direction=direction)
        for t_ in current_time_slice(t=t)
        if fix_flow(unit=u, node=n, direction=d, t=t_) != nothing
        for (n_, c) in node__commodity(node=n, commodity=commodity, _compact=false)
    ]
end

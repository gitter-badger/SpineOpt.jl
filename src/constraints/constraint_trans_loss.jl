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
    constraint_trans_loss(m::Model, trans)

Enforce losses on transmissions depending on the observed direction if the parameter
`trans_loss(connection=conn, node1=i, node2=j)` is specified.

#Examples
```julia
trans_loss(connection=con, node1=i, node2=j) != trans_loss(connection=con, node2=i, node1=j)
```
"""
function constraint_trans_loss(m::Model, trans)
    for (conn, i, j) in connection__node__node(), t=1:number_of_timesteps(time=:timer)
        (trans_loss(connection=conn, node=i) != nothing) || continue
        @constraint(
            m,
            + (trans[conn, i, t])
                * trans_loss(connection=conn, node=j)
            >=
            - (trans[conn, j, t]))
        (trans_loss(connection=conn, node=j) != nothing) || continue
        @constraint(
            m,
            + (trans[conn, j, t])
                * trans_loss(connection=conn, node=i)
            >=
            - (trans[conn, i, t]))
    end
end
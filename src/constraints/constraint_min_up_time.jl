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
    function constraint_min_up_time(m::Model)

Constraint running by minimum up time.
"""

function constraint_min_up_time(m::Model)
    @fetch units_on, units_started_up = m.ext[:variables]
    constr_dict = m.ext[:constraints][:min_up_time] = Dict()
    for (u, t) in var_units_on_indices()
        if min_up_time(unit=u) != nothing
            constr_dict[u, t] = @constraint(
                m,
                + units_on[u, t]
                >=
                + sum(
                    units_started_up[u1, t1]
                    for (u1, t1) in units_on_indices(
                        unit=u, t=to_time_slice(TimeSlice(end_(t) - min_up_time(unit=u), end_(t)))
                    )
                )
            )
        end
    end
end

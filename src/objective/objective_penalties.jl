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
    objective_penalties(m::Model)
"""
function objective_penalties(m::Model)
    @fetch node_slack_pos, node_slack_neg = m.ext[:variables]
    @expression(
        m,
        reduce(
            +,
            (
                + node_slack_neg[n, t]
                + node_slack_pos[n, t]
            ) * duration(t) * node_slack_penalty[(node=n, t=t)]
            for n in indices(node_slack_penalty)
            for (n, t) in node_slack_pos_indices(node=n);
            init=0
        )
    )
end

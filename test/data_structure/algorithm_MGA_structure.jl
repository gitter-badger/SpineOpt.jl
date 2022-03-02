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

# TODO: fix_units_on, fix_unit_flow

@testset "algorithm strucutre" begin
    url_in = "sqlite://"
    test_data = Dict(
        :objects => [
            ["model", "instance"],
            ["temporal_block", "hourly"],
            ["temporal_block", "investments_hourly"],
            ["temporal_block", "two_hourly"],
            ["stochastic_structure", "deterministic"],
            ["stochastic_structure", "investments_deterministic"],
            ["stochastic_structure", "stochastic"],
            ["unit", "unit_ab"],
            ["unit", "unit_bc"],
            ["unit", "unit_group_abbc"],
            ["node", "node_a"],
            ["node", "node_b"],
            ["node", "node_c"],
            ["node", "node_group_bc"],
            ["connection", "connection_ab"],
            ["connection", "connection_bc"],
            ["connection", "connection_group_abbc"],
            ["stochastic_scenario", "parent"],
            ["stochastic_scenario", "child"],
            #FIXME: maybe nicer way rahter than outputs?
            ["output","units_invested_available"],
            ["output","connections_invested_available"],
            ["output","storages_invested_available"],
            ["output","total_costs"],
            ["report", "report_a"]
        ],
        :object_groups => [
                ["node", "node_group_bc", "node_b"],
                ["node", "node_group_bc", "node_c"],
                ["connection", "connection_group_abbc", "connection_ab"],
                ["connection", "connection_group_abbc", "connection_bc"],
                ["unit", "unit_group_abbc", "unit_ab"],
                ["unit", "unit_group_abbc", "unit_bc"],
                ],
        :relationships => [
            ["model__temporal_block", ["instance", "hourly"]],
            ["model__temporal_block", ["instance", "two_hourly"]],
            ["model__default_investment_temporal_block", ["instance", "two_hourly"]],
            ["model__stochastic_structure", ["instance", "deterministic"]],
            ["model__stochastic_structure", ["instance", "stochastic"]],
            ["model__default_investment_stochastic_structure", ["instance", "deterministic"]],
            ["connection__from_node", ["connection_ab", "node_a"]],
            ["connection__to_node", ["connection_ab", "node_b"]],
            ["connection__from_node", ["connection_bc", "node_b"]],
            ["connection__to_node", ["connection_bc", "node_c"]],
            ["node__temporal_block", ["node_a", "hourly"]],
            ["node__temporal_block", ["node_b", "two_hourly"]],
            ["node__temporal_block", ["node_c", "hourly"]],
            ["node__stochastic_structure", ["node_a", "stochastic"]],
            ["node__stochastic_structure", ["node_b", "deterministic"]],
            ["node__stochastic_structure", ["node_c", "stochastic"]],
            ["stochastic_structure__stochastic_scenario", ["deterministic", "parent"]],
            ["stochastic_structure__stochastic_scenario", ["stochastic", "parent"]],
            ["stochastic_structure__stochastic_scenario", ["stochastic", "child"]],
            ["stochastic_structure__stochastic_scenario", ["investments_deterministic", "parent"]],
            ["parent_stochastic_scenario__child_stochastic_scenario", ["parent", "child"]],
            ["units_on__temporal_block", ["unit_ab", "hourly"]],
            ["units_on__temporal_block", ["unit_bc", "hourly"]],
            ["units_on__stochastic_structure", ["unit_ab", "stochastic"]],
            ["units_on__stochastic_structure", ["unit_bc", "stochastic"]],
            ["unit__from_node", ["unit_ab", "node_a"]],
            ["unit__from_node", ["unit_bc", "node_b"]],
            ["unit__to_node", ["unit_ab", "node_b"]],
            ["unit__to_node", ["unit_bc", "node_c"]],
            ["report__output",["report_a", "units_invested_available"]],
            ["report__output",["report_a","connections_invested_available"]],
            ["report__output",["report_a","storages_invested_available"]],
            ["report__output",["report_a","total_costs"]],
            ["model__report",["instance","report_a"]],
            ["unit__node__node", ["unit_ab", "node_a", "node_b"]],
            ["connection__node__node", ["connection_ab", "node_a", "node_b"]],
            ["unit__node__node", ["unit_ab", "node_b", "node_a"]],
            ["connection__node__node", ["connection_ab", "node_b", "node_a"]],
            ["unit__node__node", ["unit_bc", "node_b", "node_c"]],
            ["connection__node__node", ["connection_bc", "node_b", "node_c"]],
            ["unit__node__node", ["unit_bc", "node_c", "node_b"]],
            ["connection__node__node", ["connection_bc", "node_c", "node_b"]],
        ],
        :object_parameter_values => [
            ["model", "instance", "model_start", Dict("type" => "date_time", "data" => "2000-01-01T00:00:00")],
            ["model", "instance", "model_end", Dict("type" => "date_time", "data" => "2000-01-01T02:00:00")],
            ["model", "instance", "duration_unit", "hour"],
            ["model", "instance", "model_type", "spineopt_MGA"],
            ["temporal_block", "hourly", "resolution", Dict("type" => "duration", "data" => "1h")],
            ["temporal_block", "two_hourly", "resolution", Dict("type" => "duration", "data" => "2h")],
        ],
        :relationship_parameter_values => [
            [
                "stochastic_structure__stochastic_scenario",
                ["stochastic", "parent"],
                "stochastic_scenario_end",
                Dict("type" => "duration", "data" => "1h")
            ],
            ["connection__node__node", ["connection_ab", "node_b", "node_a"], "fix_ratio_out_in_connection_flow", 1.0],
            ["connection__node__node", ["connection_ab", "node_a", "node_b"], "fix_ratio_out_in_connection_flow", 1.0],
            ["connection__node__node", ["connection_bc", "node_c", "node_b"], "fix_ratio_out_in_connection_flow", 1.0],
            ["connection__node__node", ["connection_bc", "node_b", "node_c"], "fix_ratio_out_in_connection_flow", 1.0],
            ["unit__node__node", ["unit_ab", "node_b", "node_a"], "fix_ratio_out_in_unit_flow", 1.0],
            ["unit__node__node", ["unit_ab", "node_a", "node_b"], "fix_ratio_out_in_unit_flow", 1.0],
            ["unit__node__node", ["unit_bc", "node_c", "node_b"], "fix_ratio_out_in_unit_flow", 1.0],
            ["unit__node__node", ["unit_bc", "node_b", "node_c"], "fix_ratio_out_in_unit_flow", 1.0],

        ],
    )
    @testset "test MGA algorithm" begin
        _load_test_data(url_in, test_data)
        candidate_units = 1
        candidate_connections = 1
        candidate_storages = 1
        units_invested_big_m_MGA = 5
        fuel_cost = 5
        mga_slack = 0.05
        object_parameter_values = [
            ["unit", "unit_ab", "candidate_units", candidate_units],
            ["unit", "unit_bc", "candidate_units", candidate_units],
            ["unit", "unit_ab", "number_of_units", 0],
            ["unit", "unit_bc", "number_of_units", 0],
            ["unit", "unit_group_abbc", "units_invested_MGA", true],
            ["unit", "unit_group_abbc", "units_invested_big_m_MGA",units_invested_big_m_MGA],
            ["unit", "unit_group_abbc", "units_invested__MGA_weight",1],
            ["unit", "unit_ab", "unit_investment_cost",1],
            ["connection", "connection_ab", "candidate_connections", candidate_connections],
            ["connection", "connection_bc", "candidate_connections", candidate_connections],
            ["connection", "connection_group_abbc", "connections_invested_MGA", true],
            ["connection", "connection_group_abbc", "connections_invested_big_m_MGA",5],
            ["connection", "connection_group_abbc", "connections_invested_MGA_weight",1],
            ["node", "node_b", "candidate_storages", candidate_storages],
            ["node", "node_c", "candidate_storages", candidate_storages],
            ["node", "node_a", "balance_type", :balance_type_none],
            ["node", "node_b", "has_state", true],
            ["node", "node_c", "has_state", true],
            ["node", "node_b", "fix_node_state",0],
            ["node", "node_c", "fix_node_state",0],
            ["node", "node_b", "node_state_cap", 0],
            ["node", "node_c", "node_state_cap", 0],
            ["node", "node_group_bc", "storages_invested_MGA", true],
            ["node", "node_group_bc","storages_invested_big_m_MGA",5],
            ["node", "node_group_bc","storages_invested_MGA_weight",1],
            ["model", "instance", "model_type", "spineopt_MGA"],
            ["model", "instance", "MGA_diff_relative", true],
            ["model", "instance", "max_MGA_slack", mga_slack],
            ["model", "instance", "max_MGA_iterations", 2],
            # ["node", "node_a", "demand",1],
            ["node", "node_b", "demand",1],
            ["node", "node_c", "demand",1],
        ]
        relationship_parameter_values = [
            ["unit__to_node", ["unit_ab", "node_b"], "unit_capacity", 5],
            ["unit__to_node", ["unit_ab", "node_b"], "fuel_cost", fuel_cost],
            ["unit__to_node", ["unit_bc", "node_c"], "unit_capacity", 5],
            ["connection__to_node", ["connection_ab","node_b"], "connection_capacity",5],
            ["connection__to_node", ["connection_bc","node_c"], "connection_capacity",5]
            ]
        SpineInterface.import_data(url_in; object_parameter_values=object_parameter_values, relationship_parameter_values=relationship_parameter_values)
        m=run_spineopt(url_in; log_level=1)
        var_units_invested_available = m.ext[:variables][:units_invested_available]
        var_units_invested = m.ext[:variables][:units_invested]
        var_unit_flow = m.ext[:variables][:unit_flow]
        var_connections_invested_available = m.ext[:variables][:connections_invested_available]
        var_storages_invested_available = m.ext[:variables][:storages_invested_available]
        var_MGA_aux_diff = m.ext[:variables][:MGA_aux_diff]
        var_MGA_aux_binary = m.ext[:variables][:MGA_aux_binary]
        var_MGA_aux_objective = m.ext[:variables][:MGA_objective]
        MGA_results = m.ext[:outputs]
        t0 = SpineOpt._analysis_time(m)
        @testset "test MGA_diff_ub1" begin
            constraint = m.ext[:constraints][:MGA_diff_ub1]
            @test length(constraint) == 6
            scenarios = (stochastic_scenario(:parent), )
            time_slices = time_slice(m; temporal_block=temporal_block(:two_hourly))
            MGA_current_iteration = SpineOpt.MGA_iteration()[end-1]
            @testset for (s, t) in zip(scenarios, time_slices)
                key = (unit=unit(:unit_group_abbc),MGA_iteration=MGA_current_iteration)
                 key1 = (unit(:unit_ab), s, t)
                 key2 = (unit(:unit_bc), s, t)
                 var_u_inv_av_1 = var_units_invested_available[key1...]
                 var_u_inv_av_2 = var_units_invested_available[key2...]
                 prev_MGA_results_1 = MGA_results[:units_invested_available][(unit=unit(:unit_ab), stochastic_scenario=s, MGA_iteration=MGA_current_iteration)][t0.ref.x][t.start.x]
                 prev_MGA_results_2 = MGA_results[:units_invested_available][(unit=unit(:unit_ab), stochastic_scenario=s, MGA_iteration=MGA_current_iteration)][t0.ref.x][t.start.x]
                 expected_con = @build_constraint(
                            var_MGA_aux_diff[key]
                            <= (var_u_inv_av_1 - prev_MGA_results_1 + var_u_inv_av_2 - prev_MGA_results_2)
                            + units_invested_big_m_MGA*var_MGA_aux_binary[key])
                 con = constraint[key...]
                 observed_con = constraint_object(con)
                 @test _is_constraint_equal(observed_con, expected_con)
             end
             #FIXME: add for connection and node
        end
        @testset "test MGA_diff_ub2" begin
            constraint = m.ext[:constraints][:MGA_diff_ub2]
            @test length(constraint) == 6
            scenarios = (stochastic_scenario(:parent), )
            time_slices = time_slice(m; temporal_block=temporal_block(:two_hourly))
            MGA_current_iteration = SpineOpt.MGA_iteration()[end-1]
            @testset for (s, t) in zip(scenarios, time_slices)
                key = (unit=unit(:unit_group_abbc),MGA_iteration=MGA_current_iteration)
                 key1 = (unit(:unit_ab), s, t)
                 key2 = (unit(:unit_bc), s, t)
                 var_u_inv_av_1 = var_units_invested_available[key1...]
                 var_u_inv_av_2 = var_units_invested_available[key2...]
                 t0 = SpineOpt._analysis_time(m)
                 prev_MGA_results_1 = MGA_results[:units_invested_available][(unit=unit(:unit_ab), stochastic_scenario=s, MGA_iteration=MGA_current_iteration)][t0.ref.x][t.start.x]
                 prev_MGA_results_2 = MGA_results[:units_invested_available][(unit=unit(:unit_ab), stochastic_scenario=s, MGA_iteration=MGA_current_iteration)][t0.ref.x][t.start.x]
                 expected_con = @build_constraint(
                            var_MGA_aux_diff[key]
                            <= -(var_u_inv_av_1 - prev_MGA_results_1 + var_u_inv_av_2 - prev_MGA_results_2)
                            + units_invested_big_m_MGA*(1-var_MGA_aux_binary[key]))
                 con = constraint[key...]
                 observed_con = constraint_object(con)
                 @test _is_constraint_equal(observed_con, expected_con)
             end
             #FIXME: add for connection and node
        end
        @testset "test MGA_diff_lb1" begin
            constraint = m.ext[:constraints][:MGA_diff_lb1]
            @test length(constraint) == 6
            scenarios = (stochastic_scenario(:parent), )
            time_slices = time_slice(m; temporal_block=temporal_block(:two_hourly))
            MGA_current_iteration = SpineOpt.MGA_iteration()[end-1]
            @testset for (s, t) in zip(scenarios, time_slices)
                key = (unit=unit(:unit_group_abbc),MGA_iteration=MGA_current_iteration)
                 key1 = (unit(:unit_ab), s, t)
                 key2 = (unit(:unit_bc), s, t)
                 var_u_inv_av_1 = var_units_invested_available[key1...]
                 var_u_inv_av_2 = var_units_invested_available[key2...]
                 t0 = SpineOpt._analysis_time(m)
                 prev_MGA_results_1 = MGA_results[:units_invested_available][(unit=unit(:unit_ab), stochastic_scenario=s, MGA_iteration=MGA_current_iteration)][t0.ref.x][t.start.x]
                 prev_MGA_results_2 = MGA_results[:units_invested_available][(unit=unit(:unit_ab), stochastic_scenario=s, MGA_iteration=MGA_current_iteration)][t0.ref.x][t.start.x]
                 expected_con = @build_constraint(
                            var_MGA_aux_diff[key]
                            >= (var_u_inv_av_1 - prev_MGA_results_1 + var_u_inv_av_2 - prev_MGA_results_2))
                 con = constraint[key...]
                 observed_con = constraint_object(con)
                 @test _is_constraint_equal(observed_con, expected_con)
             end
             #FIXME: add for connection and node
        end
        @testset "test MGA_diff_lb2" begin
            constraint = m.ext[:constraints][:MGA_diff_lb2]
            @test length(constraint) == 6
            scenarios = (stochastic_scenario(:parent), )
            time_slices = time_slice(m; temporal_block=temporal_block(:two_hourly))
            MGA_current_iteration = SpineOpt.MGA_iteration()[end-1]
            @testset for (s, t) in zip(scenarios, time_slices)
                key = (unit=unit(:unit_group_abbc),MGA_iteration=MGA_current_iteration)
                 key1 = (unit(:unit_ab), s, t)
                 key2 = (unit(:unit_bc), s, t)
                 var_u_inv_av_1 = var_units_invested_available[key1...]
                 var_u_inv_av_2 = var_units_invested_available[key2...]
                 t0 = SpineOpt._analysis_time(m)
                 prev_MGA_results_1 = MGA_results[:units_invested_available][(unit=unit(:unit_ab), stochastic_scenario=s, MGA_iteration=MGA_current_iteration)][t0.ref.x][t.start.x]
                 prev_MGA_results_2 = MGA_results[:units_invested_available][(unit=unit(:unit_ab), stochastic_scenario=s, MGA_iteration=MGA_current_iteration)][t0.ref.x][t.start.x]
                 expected_con = @build_constraint(
                            var_MGA_aux_diff[key]
                            >= -(var_u_inv_av_1 - prev_MGA_results_1 + var_u_inv_av_2 - prev_MGA_results_2))
                 con = constraint[key...]
                 observed_con = constraint_object(con)
                 @test _is_constraint_equal(observed_con, expected_con)
             end
             #FIXME: add for connection and node
        end
        @testset "test MGA_slack_constraint" begin
            constraint = m.ext[:constraints][:MGA_slack_constraint]
            @test length(constraint) == 1
            scenarios = (stochastic_scenario(:parent), )
            time_slices = time_slice(m; temporal_block=temporal_block(:two_hourly))
            MGA_first_iteration = SpineOpt.MGA_iteration()[1]
            MGA_current_iteration = SpineOpt.MGA_iteration()[end-1]
            first_obj_result =  m.ext[:outputs][:total_costs][(model=model(:instance),MGA_iteration = MGA_first_iteration)]
            @testset for (s, t) in zip(scenarios, time_slices)
                 key1 = (unit(:unit_ab), s, t)
                 key2 = (unit(:unit_ab), node(:node_b), direction(:to_node), s, t)
                 var_u_inv_av_1 = var_units_invested[key1...]
                 var_u_inv_av_2 = var_unit_flow[key2...]
                 expected_con = @build_constraint(
                            var_u_inv_av_2*2*fuel_cost + var_u_inv_av_1
                            <= first_obj_result[t0.ref.x][t.start.x]*(1+mga_slack))
                 con = constraint[model(:instance)]
                 observed_con = constraint_object(con)
                 @test _is_constraint_equal(observed_con, expected_con)
             end
             #FIXME: add for connection and node
        end
        @testset "test MGA_objective_ub" begin
            constraint = m.ext[:constraints][:MGA_objective_ub]
            @test length(constraint) == 2
            scenarios = (stochastic_scenario(:parent), )
            t = SpineOpt.current_window(m)
            var_MGA_objective = m.ext[:variables][:MGA_objective]
            MGA_current_iteration = SpineOpt.MGA_iteration()[end-1]
             key1 = (unit=unit(:unit_group_abbc),MGA_iteration=MGA_current_iteration)
             key2 = (connection=connection(:connection_group_abbc),MGA_iteration=MGA_current_iteration)
             key3 = (node=node(:node_group_bc),MGA_iteration=MGA_current_iteration)
             key4 = (model = model(:instance),t=t)
             MGA_aux_diff_1 = var_MGA_aux_diff[key1]
             MGA_aux_diff_2 = var_MGA_aux_diff[key2]
             MGA_aux_diff_3 = var_MGA_aux_diff[key3]
             var_MGA_objective1 = var_MGA_objective[key4]
             expected_con = @build_constraint(
                        var_MGA_objective1
                        <=
                        MGA_aux_diff_1 + MGA_aux_diff_2 + MGA_aux_diff_3)
             con = constraint[MGA_current_iteration]
             observed_con = constraint_object(con)
             @test _is_constraint_equal(observed_con, expected_con)
        end
    end
end

# Sets 
## `node` 

 > **Index:** n 

Set of [node](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Object%20Classes/#node-1) objects in the model 

## `unit` 

 > **Index:** u 

Set of [unit](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Object%20Classes/#unit-1) objects in the model 

## `unit_constraint` 

 > **Index:** uc 

Set of [unit_constraint](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Object%20Classes/#unit_constraint-1) objects in the model 

## `connection` 

 > **Index:** conn 

Set of [connection](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Object%20Classes/#connection-1) objects in the model 

## `direction` 

 > **Index:** d 

Set of flow direction associated with a node, including ``to_node`` and ``from_node`` 

## `stochastic_scenario` 

 > **Index:** s 

Set of [stochastic_scenario](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Object%20Classes/#stochastic_scenario-1) objects in the model 

## `stochastic_path` 

 > **Index:** s 

Set of unique sequences of stochastic scenarios that traverse the stochastic direct acyclic graph (DAG) from root to leaves 

## `temporal_block` 

 > **Index:** tb 

Set of [temporal_block](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Object%20Classes/#temporal_block-1) objects in the model 

## `groups(node=n)` 

 > **Index:** ng 

Set of node objects that belong to the same [node\_group](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/the_basics/#Introduction-to-groups-of-objects-1) 

## `ind(*parameter*)` 

 > **Index:** .. 

Tuple of all objects, for which the parameter is defined 

## `N` 

 > **Index:** i 

Set of indexes for navigating an array value 

## `TimeSlice` 

 > **Index:** t 

Set of specific time-indexes for navigating a time-varying value 

## `t_before_t(t_after=t')` 

 > **Index:** t 

Set of timeslices that are directly before timeslice t' 

## `t_before_t(t_before=t')` 

 > **Index:** t 

Set of timeslices that are directly after timeslice t' 

## `t_in_t(t_short=t')` 

 > **Index:** t 

Set of timeslices that contain timeslice t' 

## `t_in_t(t_long=t')` 

 > **Index:** t 

Set of timeslices that are contained in timeslice t' 

## `t_overlaps_t(t')` 

 > **Index:** t 

Set of timeslices that overlap with timeslice t' 

## `t_lowest_resolution(node=n, temporal_block=tb)` 

 > **Index:** t 

 Set of the lowest resolution timeslices in node n and temporal block tb 

## `full_stochastic_paths` 

 > **Index:** [s_path] 

Set of all possible sequences of stochastic scenarios that traverse the stochastic direct acyclic graph (DAG) from root to leaves 

## `active_stochastic_paths(s)` 

 > **Index:** [s_path] 

Set of sequences of stochastic scenarios that contain the active scenarios s 

## `node__temporal_block` 

 > **Index:** (n, tb) 

Set of tuples of node and temporal block being defined under the relationship [node__temporal_block](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Relationship%20Classes/#node__temporal_block-1) 

## `unit__node` 

 > **Index:** (u, n) 

Set of tuples of unit and node being defined under the relationship [unit__to_node](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Relationship%20Classes/#unit__to_node-1) or [unit__from_node](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Relationship%20Classes/#unit__from_node-1) 

## `unit__node__unit_constraint` 

 > **Index:** (u, n, uc) 

Set of tuples of unit, node and unit constraint being defined under the relationship [unit\_\_to_node\_\_unit_constraint](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Relationship%20Classes/#unit__to_node__unit_constraint-1) or [unit\_\_from_node\_\_unit_constraint](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Relationship%20Classes/#unit__from_node__unit_constraint-1) 

## `connection__node__unit_constraint` 

 > **Index:** (conn, n, uc) 

Set of tuples of connection, node and unit constraint being defined under the relationship [connection\_\_to_node\_\_unit_constraint](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Relationship%20Classes/#connection__to_node__unit_constraint-1) or [connection\_\_from_node\_\_unit_constraint](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Relationship%20Classes/#connection__from_node__unit_constraint-1) 

## `unit__unit_constraint` 

 > **Index:** (u, uc) 

Set of tuples of unit and unit constraint being defined under the relationship [unit__unit_constraint](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Relationship%20Classes/#unit__unit_constraint-1) 

## `node__unit_constraint` 

 > **Index:** (n, uc) 

Set of tuples of node and unit constraint being defined under the relationship [node__unit_constraint](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Relationship%20Classes/#node__unit_constraint-1) 

## `constraint_unit_constraint_indices` 

 > **Index:** (unit\_constraint=uc, stochastic\_path=s, t=t) 

Set of indices for the defined unit constraints 

## `binary_gas_connection_flow_indices` 

 > **Index:** (connection=conn, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for binary\_gas\_connection_flow variables 

## `connection_flow_indices` 

 > **Index:** (connection=conn, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for connection_flow variables 

## `connection_intact_flow_indices` 

 > **Index:** (connection=conn, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for connection\_intact\_flow variables 

## `connections_invested_available_indices` 

 > **Index:** (connection=conn, stochastic_scenario=s, t=t) 

Set of valid indices for connections\_invested\_available variables 

## `mp_objective_lowerbound_indices` 

 > **Index:** (t=t) 

Set of valid indices (timeslice) for the model to update lowerbound for master problem of Benders decomposition 

## `node_injection_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the node_injection variables 

## `node_pressure_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the node_pressure variables 

## `node_slack_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the node_slack variables 

## `node_state_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the node_state variables 

## `node_voltage_angle_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the node\_voltage\_angle variables 

## `nonspin_ramp_down_unit_flow_indices` 

 > **Index:** (unit=u, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for the nonspin\_ramp\_down\_unit\_flow variables 

## `nonspin_ramp_up_unit_flow_indices` 

 > **Index:** (unit=u, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for the nonspin\_ramp\_up\_unit\_flow variables 

## `nonspin_units_shut_down_indices` 

 > **Index:** (unit=u, node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the nonspin\_units\_shut\_down variables 

## `nonspin_units_started_up_indices` 

 > **Index:** (unit=u, node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the nonspin\_units\_started\_up variables 

## `ramp_down_unit_flow_indices` 

 > **Index:** (unit=u, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for the ramp\_down\_unit\_flow variables 

## `ramp_up_unit_flow_indices` 

 > **Index:** (unit=u, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for the ramp\_up\_unit\_flow variables 

## `shut_down_unit_flow_indices` 

 > **Index:** (unit=u, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for the shut\_down\_unit\_flow variables 

## `start_up_unit_flow_indices` 

 > **Index:** (unit=u, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for the start\_up\_unit\_flow variables 

## `storages_invested_available_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the storages\_invested\_available variables 

## `unit_flow_indices` 

 > **Index:** (unit=u, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for the unit_flow variables 

## `operating_points(u)` 

 > **Index:** op 

Set of [operating_points](https://spine-project.github.io/SpineOpt.jl/latest/concept_reference/Parameters/#operating_points-1)s of a unit 

## `unit_flow_op_indices` 

 > **Index:** (unit=u, node=n, direction=d, op=i, stochastic_scenario=s, t=t) 

Set of valid indices for the unit\_flow\_op variables 

## `units_invested_available_indices` 

 > **Index:** (unit=u, stochastic_scenario=s, t=t) 

Set of valid indices for the units\_invested\_available variables 

## `units_on_indices` 

 > **Index:** (unit=u, stochastic_scenario=s, t=t) 

Set of valid indices for the units_on variables 

## `node_stochastic_time_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t) 

Set of valid stochastic scenario and timeslice indices for a node 

## `node_state_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the node_state variables 

## `node_time_indices` 

 > **Index:** (node=n, t=t) 

Set of valid timeslice indices for a node 

## `constraint_cyclic_node_state_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t, t=t) 

Set of valid indices for the cyclic node_state constraint 

## `operating_point_indices` 

 > **Index:** (unit=u, node=n, direction=d) 

Set of unit flows that use operating points 

## `unit_pw_heat_rate_indices` 

 > **Index:** (unit=u, node=n, node=n, stochastic_scenario=s, t=t) 

Set of indices for piece-wise linear heat rate approximations for units 

## `node_pressure_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the node_pressure variables 

## `connection_ptdf_flow_indices` 

 > **Index:** (connection=conn, node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the connection\_ptdf\_flow variables 

## `constraint_connection_flow_lodf_indices` 

 > **Index:** (connection=conn, connection=conn, stochastic_scenario=s, t=t) 

Set of valid indices for the connection LODF constraint 

## `unit_investment_lifetime_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the unit investment lifetime constraint 

## `candidate_connections_indices` 

 > **Index:** (connection=conn) 

Set of possible connections to invest in 

## `constraint_candidate_connection_flow_lb_indices` 

 > **Index:** (connection=conn, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for the candidate connection flow lower bound constraint 

## `constraint_candidate_connection_flow_ub_indices` 

 > **Index:** (connection=conn, node=n, direction=d, stochastic_scenario=s, t=t) 

Set of valid indices for the candidate connection flow upper bound constraint 

## `connection_investment_lifetime_indices` 

 > **Index:** (connection=conn, stochastic_scenario=s, t=t) 

Set of valid indices for the connection investment lifetime constraint 

## `storage_investment_lifetime_indices` 

 > **Index:** (node=n, stochastic_scenario=s, t=t) 

Set of valid indices for the storage investment lifetime constraint 

## `constraint_unit_constraint_indices` 

 > **Index:** (unit\_constraint=uc, t=t, stochastic\_scenario=s) 

Set of valid indices for the unit constraint 


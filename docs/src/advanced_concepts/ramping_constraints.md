# Ramping constraints
## Motivation

## Relevant parameters
Everything that is related to ramping is defined in parameters of the [unit__to_node](../concept_reference/relationship_classes.md#unit__to_node) relationship? Generally speaking, the ramping constraints will impose restrictions on the change in the [`unit_flow`](../mathematical_formulation/variables.md#unit_flow) variable between two consecutive timesteps.
### Shutdowns
  * `max_shutdown_ramp` : limit the maximum of the `unit_flow` variable the timestep right before a shutdown
  * `min_shutdown_ramp` : limit the minimum of the `unit_flow` variable the timestep right before a shutdown
  * `max_res_shutdown_ramp`
  * `min_res_shutdown_ramp`

### Startups
  * `max_start_up_ramp` : limit the maximum of the `unit_flow` variable the timestep right after a start-up
  * `min_start_up_ramp` : limit the minimum of the `unit_flow` variable the timestep right after a start-up
### Regular operation
  * `ramp_up_limit` : limit the maximum increase in the `unit_flow` variable between two consecutive timesteps for which the unit is online
  * `ramp_down_limit` : limit the maximum decrease in the `unit_flow` variable between two consecutive timesteps for which the unit is online
  * `ramp_up_cost` : cost associated with upward ramping
  * `ramp_down_cost` : cost associated with downward ramping

  * `minimum_operating_point` : the minimum
  * `unit_capacity`

## General principle

* Not sure if we want to cover the splitting here between the different ramping types or we leave this for the mathematical formulation and refer to it here

## Thoughts

* When I enter a min_stable operating point in a very simple example, it becomes infeasible -> to be investigated
* Same for max start-up ramp 

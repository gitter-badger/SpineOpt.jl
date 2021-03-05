# Ramping constraints

## Motivation
Spine Model aims to provide a high degree of flexibility in the imposed ramping restrictions for different units present in the created model. This means that the user has the freedom to impose restrictions on the change in output of units between consecutive timesteps. Both for online (spinning) units, and units starting up or shutting down, restrictions can be imposed. When a unit is also contributing to reserve provision, this will also be taken into account.

Ramping constraints are meant to reflect the technical capabilities of real-life units, which are typically be restricted in their operating abilities. This is only relevant for certain optimizations, and it is therefore optional to define these constraining parameters.

This documentation aims to inform the reader on which parameters are relevant for these restrictions, and which constraints that they will trigger.
## Relevant parameters
Everything that is related to ramping is defined in parameters of the [unit__to_node](../concept_reference/relationship_classes.md#unit__to_node) relationship. Generally speaking, the ramping constraints will impose restrictions on the change in the [`unit_flow`](../mathematical_formulation/variables.md#unit_flow) variable between two consecutive timesteps. All parameters that limit the ramping abilities of a unit are expressed as a fraction of the unit capacity. This means that a value of 1 indicates the full capacity of a unit. The discussion here will be kept conceptual, for the more technical description the reader is referred to the [formulation of ramping constraints](../mathematical_formulation/constraints.md#Ramping-and-reserve-constraints)
### Shutdowns
  * `max_shutdown_ramp` : limit the maximum of the `unit_flow` variable the timestep right before a shutdown. Inclusion of this parameter will trigger the creation of the [Constraint on maximum downward shut down ramps](../mathematical_formulation/constraints.md#Constraint-on-maximum-downward-shut-down-ramps)
  * `min_shutdown_ramp` : limit the minimum of the `unit_flow` variable the timestep right before a shutdown. Inclusion of this parameter will trigger the creation of the [Constraint on minimum downward shut down ramps](../mathematical_formulation/constraints.md#Constraint-on-minimum-downward-shut-down-ramps)

### Startups
  * `max_start_up_ramp` : limit the maximum of the `unit_flow` variable the timestep right after a start-up. Inclusion of this parameter will trigger the creation of the [Constraint on maximum upward start up ramps](../mathematical_formulation/constraints.md#Constraint-on-maximum-upward-start-up-ramps)
  * `min_start_up_ramp` : limit the minimum of the `unit_flow` variable the timestep right after a start-up. Inclusion of this parameter will trigger the creation of the [Constraint on minimum upward start up ramps](../mathematical_formulation/constraints.md#Constraint-on-minimum-upward-start-up-ramps)
### Regular operation
  * `ramp_up_limit` : limit the maximum increase in the `unit_flow` variable between two consecutive timesteps for which the unit is online. Inclusion of this parameter will trigger the creation of the [Constraint on spinning upward ramps](../mathematical_formulation/constraints.md#Constraint-on-spinning-upward-ramps)
  * `ramp_down_limit` : limit the maximum decrease in the `unit_flow` variable between two consecutive timesteps for which the unit is online. Inclusion of this parameter will trigger the creation of the [Constraint on spinning downward ramps](../mathematical_formulation/constraints.md#Constraint-on-spinning-downward-ramps)
  * `ramp_up_cost` : cost associated with upward ramping
  * `ramp_down_cost` : cost associated with downward ramping

  * `minimum_operating_point` : limit the minimum value of the `unit_flow` variable for a unit which is currently online. Inclusion of this parameter will trigger the creation of the [Constraint on minimum operating point](../mathematical_formulation/constraints.md#Constraint-on-minimum-operating-point)
  * `unit_capacity`: limit the maximum value of the `unit_flow` variable for a unit which is currently online. Inclusion of this parameter will trigger the creation of the [unit capacity constraint](../mathematical_formulation/constraints.md#Define-unit/technology-capacity)
### Reserves
  * `max_res_shutdown_ramp`
  * `min_res_shutdown_ramp`
## General principle and example use cases
The general principle of the Spine modelling ramping constraints is that all of these parameters can be defined separately for each unit. This allows the user to incorporate different units (which can either represent a single unit or a technology type) with different flexibility characteristics.

It should be noted that it is perfectly possible to omit all of the constraining parameters, except for the unit capacity. However, once a certain parameter is defined to restrict a unit in some way, it is necessary to define all of them.
### Simple case of unrestricted unit
When none of the ramping parameters mentioned above are defined, a unit is considered infinitely flexible. This means that in any given timestep, its output can be any value between 0 and its capacity, regardless of what the output of the unit was in the previous timestep, and regardless of the on- or offline status or the unit in the previous timestep.

The same result can be obtained by choosing extreme values $\in \{0,1\} $ for the relevant parameters.

### Spinning ramp restriction
A unit which is only restricted in spinning ramping can be created by choosing the following parameters:

 * `max_shutdown_ramp`  : 1
 * `min_shutdown_ramp`  : 0
 * `max_start_up_ramp`  : 1
 * `min_start_up_ramp`  : 0
 * `ramp_up_limit`      : 0.2
 * `ramp_down_limit`    : 0.4
 * `unit_capacity`      : 200
 * `minimum_operating_point`: 0

 This parameter choice implies that the unit's output between two consecutive timesteps can change with no more than $0.2  * 200$ and no less than $0.4 * 200$. For example, when the unit is running at an output of $100$ in some timestep $t$, its output for the next timestep must be somewhere in the interval $[20,140]$. Unless it shuts down completely.

### Shutdown restrictions

 By changing the parameter `max_shutdown_ramp` in the previous example, to a value of $0.5$, an additional restriction is imposed on the maximum output of the unit from which it can go offline. When this unit goes offline in a given timestep $t+1$, the output of the unit must be below $0.5*200 = 100$ in the timestep $t$ before that.

 Similarly, the parameter `min_shutdown_ramp` can be used to impose a minimum output value in the timestep  before a shutdown. For example, a value of $0.3$ in this example would mean that the unit can not be running below an output of $60$ in timestep $t$.

### Startup restrictions

 The startup restrictions are very similar to the shutdown restrictions, but of course apply to units that are starting up. Consider for example the same unit as in the example above, but now with a `max_start_up_ramp` equal to $0.4$ and `min_start_up_ramp` equal to $0.2$. When the unit is offline in timestep $t$ and comes online in timestep $t+1$, its output in timestep $t+1$ will be restricted to the interval $[40,80]$.

### Minimum operating point

The minimum operating point of a unit defines an output below which it can never run given that it is online. When this parameter is set to $0.2$ in the previous example, the unit can never have a non-zero output below $40$.

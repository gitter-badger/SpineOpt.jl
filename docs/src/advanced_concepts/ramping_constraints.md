# Ramping concept

@Kristof would probably try to avoid introducing ever chapter with "SpineOpt aims to provide...". I'd rather start out with "To enable a represent a high level of technical detail..." (To do enable what feature... -> we do...)
Spine Model aims to provide a high degree of flexibility in the imposed ramping restrictions for different units present in the created model. This means that the user has the freedom to impose restrictions on the change in output of units between consecutive timesteps, for online (spinning) units, units starting up and units shutting down. In this section, the concept of ramps in SpineOpt will be introduced. Furthermore, the use of reserves will be explained.

## Relevant objects, relationships and parameters
Note: this is not entirely true, one can also inplement ramps on the unit__from node relationships. (Would move this to the list elements). Also I think it'd be important, when listing this, that it can be defined on both a unit - node relationship, but (simialarly to the unit capacity) can be defined on a unit - node group aswell. This will be important for explaining how reserves work
Everything that is related to ramping is defined in parameters of the [unit__to_node](../concept_reference/relationship_classes.md#unit__to_node) relationship. Generally speaking, the ramping constraints will impose restrictions on the change in the [`unit_flow`](../mathematical_formulation/variables.md#unit_flow) variable between two consecutive timesteps.

All parameters that limit the ramping abilities of a unit are expressed as a fraction of the unit capacity. This means that a value of 1 indicates the full capacity of a unit. Note: I'd probably state this for every parameter, indicated below for the `max_shut_down_ramp`.

 The discussion here will be kept conceptual, for the mathematical formulation the reader is referred to the [formulation of ramping constraints](../mathematical_formulation/constraints.md#Ramping-and-reserve-constraints)
### Constraining shutdown ramps
  * `max_shutdown_ramp` : limit the maximum of the `unit_flow` variable the timestep right before a shutdown. The parameter is given as a fraction of the [unit\_flow\_capacity](@ref) parameter. Inclusion of this parameter will trigger the creation of the [Constraint on maximum downward shut down ramps](../mathematical_formulation/constraints.md#Constraint-on-maximum-downward-shut-down-ramps)
  * `min_shutdown_ramp` : limit the minimum of the `unit_flow` variable the timestep right before a shutdown. Inclusion of this parameter will trigger the creation of the [Constraint on minimum downward shut down ramps](../mathematical_formulation/constraints.md#Constraint-on-minimum-downward-shut-down-ramps)

### Constraining startup ramps
  * `max_start_up_ramp` : limit the maximum of the `unit_flow` variable the timestep right after a start-up. Inclusion of this parameter will trigger the creation of the [Constraint on maximum upward start up ramps](../mathematical_formulation/constraints.md#Constraint-on-maximum-upward-start-up-ramps)
  * `min_start_up_ramp` : limit the minimum of the `unit_flow` variable the timestep right after a start-up. Inclusion of this parameter will trigger the creation of the [Constraint on minimum upward start up ramps](../mathematical_formulation/constraints.md#Constraint-on-minimum-upward-start-up-ramps)
### Constraining spinning ramps (would probably name this one first, as maybe most familiar to people)
  * `ramp_up_limit` : limit the maximum increase in the `unit_flow` variable between two consecutive timesteps for which the unit is online. Inclusion of this parameter will trigger the creation of the [Constraint on spinning upward ramps](../mathematical_formulation/constraints.md#Constraint-on-spinning-upward-ramps)
  * `ramp_down_limit` : limit the maximum decrease in the `unit_flow` variable between two consecutive timesteps for which the unit is online. Inclusion of this parameter will trigger the creation of the [Constraint on spinning downward ramps](../mathematical_formulation/constraints.md#Constraint-on-spinning-downward-ramps)
  * `ramp_up_cost` : cost associated with upward ramping
  * `ramp_down_cost` : cost associated with downward ramping

  * `minimum_operating_point` : limit the minimum value of the `unit_flow` variable for a unit which is currently online. Inclusion of this parameter will trigger the creation of the [Constraint on minimum operating point](../mathematical_formulation/constraints.md#Constraint-on-minimum-operating-point)
  Would more the min operating point to the UC section
  * `unit_capacity`: limit the maximum value of the `unit_flow` variable for a unit which is currently online. Inclusion of this parameter will trigger the creation of the [unit capacity constraint](../mathematical_formulation/constraints.md#Define-unit/technology-capacity)

## General principle and example use cases
The general principle of the Spine modelling ramping constraints is that all of these parameters can be defined separately for each unit. This allows the user to incorporate different units (which can either represent a single unit or a technology type) with different flexibility characteristics.

It should be noted that it is perfectly possible to omit all of the constraining parameters mentioned above. However, once either of the ramping parameters is defined, it is necessary to also assign values to the other parameters. E.g. if a user only wants to restrict the spinning ramp up capability of a unit, one also has to assign values to the `max_startup_ramp`, `min_Shutdown_Ramp` etc.
### Illustrative examples
#### Step 1: Simple case of unrestricted unit
When none of the ramping parameters mentioned above are defined, the unit is considered to have full ramping flexibility. This means that in any given timestep, its output can be any value between 0 and its capacity, regardless of what the output of the unit was in the previous timestep, and regardless of the on- or offline status or the unit in the previous timestep. Parameter values for a `unit__node` relationship are illustratively given below. Note: I don't think this is true, as we of course still can have minimum down time etc. Maybe rephrase

* `max_shutdown_ramp`  : 1
* `min_shutdown_ramp`  : 0
* `max_start_up_ramp`  : 1
* `min_start_up_ramp`  : 0
* `ramp_up_limit`      : 1
* `ramp_down_limit`    : 1
* `unit_capacity`      : 200
* `minimum_operating_point`: 0

The same result can be obtained by choosing extreme values $\in \{0,1\}$ for the relevant parameters. To do: How to enable math mode here?

#### Step 2: Spinning ramp restriction
A unit which is only restricted in spinning ramping can be created by changing the `ramp_up/down_limit` parameters: (btw, I like this example!)

 * `ramp_up_limit`      : **0.2**
 * `ramp_down_limit`    : **0.4**

 This parameter choice implies that the unit's output between two consecutive timesteps can change with no more than $0.2  * 200$ and no less than $0.4 * 200$. For example, when the unit is running at an output of $100$ in some timestep $t$, its output for the next timestep must be somewhere in the interval $[20,140]$. Unless it shuts down completely.

#### Step 3: Shutdown restrictions

 By changing the parameter `max_shutdown_ramp` in the previous example, an additional restriction is imposed on the maximum output of the unit from which it can go offline.

 * `max_shutdown_ramp`      : **0.5**
 * `max_shutdown_ramp`    :   **0.3**

 When this unit goes offline in a given timestep $t+1$, the output of the unit must be below $0.5*200 = 100$ in the timestep $t$ before that.
 Similarly, the parameter `min_shutdown_ramp` can be used to impose a minimum output value in the timestep  before a shutdown. For example, a value of $0.3$ in this example would mean that the unit can not be running below an output of $60$ in timestep $t$.

#### Step 4: Startup restrictions

 The startup restrictions are very similar to the shutdown restrictions, but of course apply to units that are starting up. Consider for example the same unit as in the example above, but now with a `max_start_up_ramp` equal to $0.4$ and `min_start_up_ramp` equal to $0.2$:

 * `max_start_up_ramp`      : **0.4**
 * `min_start_up_ramp`    :   **0.2**

  When the unit is offline in timestep $t$ and comes online in timestep $t+1$, its output in timestep $t+1$ will be restricted to the interval $[40,80]$.

### Minimum operating point
To do: move this to unit commitment section
The minimum operating point of a unit defines an output below which it can never run given that it is online. When this parameter is set to $0.2$ in the previous example, the unit can never have a non-zero output below $40$.

# Reserve concept
Here we'll need to describe how exactly the ramp down and ramp up can be used for spinning reserves + the non-spinning reserves
## Non-spinning reserves
  * `max_res_shutdown_ramp`
  * `min_res_shutdown_ramp`

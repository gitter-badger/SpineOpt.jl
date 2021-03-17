# Unit commitment constraints

To incorporate technical detail about (clustered) unit-commitment statuses of units, the online, started and shutdown status of units can be tracked and constrained in SpineOpt.
In the following, relevant relationships and parameters are introduced and the general working principle is described.
@Kristof: maybe we should quickly talk about the units tomorrow.

## Key concepts
Here, we briefly describe the key concepts involved in the representation of (clustered) unit commitment models:

1. [number\_of\_units](@ref) defines how many units of a certain unit type are available. Typically this parameter takes a binary (UC) or integer (clustered UC) value. [^1]
Comment @Kristof: soory, didn't see that you introduce this later on
[^1] There should be a note somewhere that the number of available units can also be increased by invest + cross-reference to investment chapter

* [online\_variable\_type](@ref) is a method parameter and can take the values "unit\_online\_variable\_type\_binary", "unit\_online\_variable\_type\_integer", "unit\_online\_variable\_type\_linear". If the binary value is chosen, the units status is modelled as a binary (classic UC). For clustered unit commitment units, the integer type is applicable. Note that if the parameter is not defined, the default will be linear. If the units status is not crucial, this can reduce the computational burden.
...

 When the binary type is selected, the [`units_on`](../mathematical_formulation/variables#units_on) variable is restricted to $0$, or $1$, thus representing a single *real* unit which is either on- or offline. When the integer type is chosen, this variable can be any positive integer, bounded by the `units_available` variable. This means that the single unit in the model, now actually represents a number of *real* units that have the same characteristics, but can be activated separately.[^1] When it is not necessary to restrict the `units_on` variable to integer values, the parameter value can also be taken as the linear type. In that case, all values in the bounding interval $[0,$`units_available`$]$ are allowed for the `units_on` variable. The default type is linear.  

[^1]: Representing multiple *real* units that have the same characteristics with an integer availability instead of each of them separately with a binary availability has significant computational advantages.

* `number_of_units`: "number value"
The number of *real* units that this unit object represents.

Together with the `unit_availability_factor`, this will determine the maximum number of *real* units that can be online at any given time. (Thus restricting the `units_on` variable). The default value for this parameter is $1$.

* `unit_availability_factor`: "number value"
The fraction of the time that this unit is considered to be available.

In typical real-life settings, units are not available $100$% of the time, due to scheduled maintenance, unforeseen outages, or other things. This can be incorporated in the model by setting the `unit_availability_factor` to a fractional value. For each timestep in the model, an upper bound is then imposed on the `units_on` variable, equal to `number_of_units` $*$ `unit_availability_factor`. This parameter can not be used when the `online_variable_type` is binary. It should also be noted that when the `online_variable_type` is of integer type, the aforementioned product must be integer as well, since it will determine the value of the `units_available` parameter which is restricted to integer values. The default value for this parameter is $1$.


* `min_up_time`: "duration value"
The minimum time that a unit has to stay online after a startup.

Inclusion of this parameter will trigger the creation of the [constraint on Minimum Up Time](../mathematical_formulation/constraints.html#Minimum-up-time-(basic-version))

* `min_down_time`: "duration value"
The minimum time that a unit has to stay offline after a shutdown.

Inclusion of this parameter will trigger the creation of the [constraint on Minimum Down Time](../mathematical_formulation/constraints.html#Minimum-down-time-(basic-version))

* `start_up_cost`: "number value"
Cost associated with starting up a unit.
* `shut_down_cost`: "number value"
Cost associated with shutting down a unit.

Note: I'd probably also add minimum operating point here. Without the minimum operating point, UC does probably not make much sense.

I feel like `units_on__temporal_block` should be added here aswell.
Also we need to add the unit status variables to the mathematical_formulation, but should probably also briefly explain them here.

Also can we change the formatting a bit? When I build the documentation, the indentations are a bit off

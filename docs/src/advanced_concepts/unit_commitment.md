# Unit commitment constraints

## Motivation
Spine Model provides flexibility in the imposed restrictions for the on- and offline status of different units. These are particularly important in Unit Commitment problems. Spine Model supports the clustered unit commitment framework, in which commitment and ramping constraints are defined on a technology level, rather than for individual units. Since technology types are represented by a single unit object in Spine, but actually represent multiple *real* units, the distinction will be made hereafter by explicitly stating that it concerns *real* units where relevant.

This document aims to inform the reader with which parameters are relevant to impose commitment restrictions, and demonstrate how they can be used to do so.
## Relevant parameters
This section gives an overview of the relevant parameters for unit commitment restrictions. All of them are defined for a [unit object](../../concept_reference/object_classes.html#unit). The parameters are presented in the following format:

* `parameter_name` : "Allowed value type" or "Allowed value"
Brief explanation of what this parameter means or does.


* `online_variable_type`: "unit\_online\_variable\_type\_binary", "unit\_online\_variable\_type\_integer", "unit\_online\_variable\_type\_linear"
Determine what the Spine unit represents: a single unit or a group of *real* units with the same characteristics.

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

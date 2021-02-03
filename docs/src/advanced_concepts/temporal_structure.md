# Temporal Structure

## Motivation
Spine Model aims to provide a high degree of flexibility in the temporal dimension across different components of the created model. This means that the user has some freedom to choose how the temporal aspects of different components of the model are defined. This freedom increases the variety of problems that can be tackled in Spine: from very coarse, long term models, to very detailed models with a more limited horizon, or a mix of both. The choice of the user on how this flexibility is used will lead to the temporal structure of the model.

The main components of flexibility consist of the following parts:
  * The horizon that is modeled: end and start time
  * Temporal resolution
  * Possibility of a rolling optimization window
  * Support for commonly used methods such as representative days

Part of the temporal flexibility in Spine is due to the fact that these options mentioned above can be taken differently across different components of the model, which can be very useful when different markets are coupled in a single model. The resolution and horizon of the gas market can for example be taken differently than that of the electricity market. This documentation aims to give the reader insight in how these aspects are defined, and which objects are used for this.

We start by introducing the relevant objects with their parameters, and the relevant relationship classes for the temporal structure. Afterwards, we will discuss how this setting creates flexibility and will present some of the practical approaches to create a variety of temporal structures.

## Objects, relationships, and their parameters
In this section, the objects and relationships will be discussed that form the temporal structure together.
### Objects
For the objects, the relevant parameters will also be introduced, along with the type of values that are allowed, following the format below:  

* 'parameter_name' : "Allowed value type"

#### `model_instance`
Each `model_instance` object holds general information about the model at hand. Here we only discuss the time related parameters:
* `model_start` and `model_end` : "Date time value"
These two parameters define the model horizon. A Datetime value is to be taken for both parameters, in which case they directly mark respectively the beginning and end of the modeled time horizon.[^1]

[^1]: In the documentation of Maren, it is mentioned that the `model_end` parameter can also be given as a duration. However, this does not seem to work when I try it. I get the following error: MethodError: no method matching SpineInterface.TimeSlice(::Dates.DateTime, ::Dates.Minute; duration_unit=Dates.Minute). Furthermore, an array of DateTimes should be possible, to create non-connected periods -> seems to be not working either. Issue has been filed.

* `duration_unit` (optional): "hour or minute"
 This parameters gives the unit of duration that is used in the model calculations. The allowed values are 'hour' and 'minute'. This parameter should be aligned with other parameters in the model, for example: when fuel costs are expressed in euro/MWh, and unit capacity in MW, then the `duration_unit` should be 'hour'. The default value for this parameter is 'minute'.

* `roll_forward` (optional): "duration value"
This parameter defines how much the optimization window rolls forward in a rolling horizon optimization and should be expressed as a duration. In a rolling horizon optimization, a (small) part of the model is optimized at each iteration, after which the window rolls forward to optimize a different part. Overlap between consecutive optimization windows is possible. In the practical approaches presented below, the rolling window optimization will be explained in more detail. The default value of this parameter is the entire model time horizon, which leads to a single optimization for the entire time horizon.


#### `temporal_block`
A temporal block defines the properties of the optimization that is to be solved in the current window. Most importantly, it holds the necessary information about the resolution and horizon of the optimization. A single model can have multiple temporal blocks, which is one of the main sources of temporal flexibility in Spine: by linking different parts of the model to different temporal blocks, a single model can contain aspects that are solved with different temporal resolutions or time horizons.

* `resolution` (optional): "duration value" or "array of duration values"
This parameter specifies the resolution of the temporal block, or in other words: the length of the timesteps used in the optimization run. Generally speaking, variables and constraints are generated for each timestep of an optimization. For example, the nodal balance constraint must hold for each timestep. An array of duration values can be used to have a resolution that varies with time itself. It can for example be used when uncertainty in one of the inputs rises as the optimization moves away from the model start. Think of a forecast of for instance wind power generation, which might be available in quarter hourly detail for one day in the future, and in hourly detail for the next two days. It is possible to take a quarter hourly resolution for the full horizon of three days, one then simply takes an equal value for all four quarters belonging to the same hour of the two final days. However, by lowering the temporal resolution after the first day, the computational burden is lowered substantially. [^3] The default value for this parameter is 1 hour.

[^3]: It is possible to give as input an array of durations, but this does not seem to be working for me. error message: MethodError: no method matching zero(::SpineInterface.Duration) in the code line: _time_interval_blocks at SpineOpt\nWeao\src\data_structure\temporal_structure.jl:153

* `block_start` (optional): "duration value" or "Date time value"
Indicates the start of this temporal block. The main use of this parameter is to create an offset from the model start. The default value is equal to a duration of 0. It is useful to distinguish here between two cases: a single solve, or a rolling window optimization.

**single solve**
When a Date time value is chosen, this is directly the start of the optimization for this temporal block. When a duration is chosen, it is added to the `model_start` to obtain the start of this `temporal_block`. In the case of a duration, the chosen value directly marks the offset of the optimization with respect to the `model_start`. The default value for this parameter is the `model_start`.

**rolling window optimization**
To create a temporal_block that is rolling along with the optimization window, a rolling temporal_block, a duration value should be chosen. The temporal `block_start` will again mark the offset of the optimization start but now with respect to the start of each optimization window. To create a static temporal_block, that has a fixed `block_start` (and `block_end`, see below) and does not move along with the rolling window but rather splats into the rolling window, once the rolling window hits the start of the static temporal_block, the `block_start`parameter needs to be defined as a `DateTime` value. #TODO: this is not supported yet!

* `block_end`(optional): "duration value" or "Date time value"

**single solve**
When a Date time value is chosen, this is directly the end of the optimization for this temporal block. In a single solve optimization, a combination of `block_start` and `block_end` can easily be used to run optimizations that cover only part of the model horizon. Multiple `temporal_block` objects can then be used to create optimizations for disconnected time periods, which is commonly used in the method of representative days.

**rolling window optimization**
To create a temporal_block that is rolling along with the optimization window, a rolling temporal_block, a duration value should be chosen. The `block_end` parameter will in this case determine the size of the optimization window, with respect to the start of each optimization window. If multiple temporal_blocks with different `block_end` parameters exist, the maximum value will determine the size of the optimization window. Note, this is different from the `roll_forward` parameter, which determines how much the window moves for after each optimization. For more info, see [Minimal requirements to get a model running: one single `temporal_block`](@ref).\\
To create a static temporal_block, that doesn't move along with the rolling optimization window, the `block_end` needs to be defined as a `DateTime` value. #TODO: this is not yet supported


### Relationships

#### `model_instance_temporal_block`
In this relationship, a model instance is linked to a temporal block. If this relationship doesn't exist - the temporal block is disregarded from this optimization model.
#### `model_default_temporal_block`
Defines the default temporal block used for model objects, which will be replaced when a specific relationship is defined for a model in `model_instance_temporal_block`.
#### `node_temporal_block`
This relationship will link a node to a temporal block. A node has to be linked to a temporal block, otherwise it will not be included in an optimization. The advantage of linking nodes explicitly to a temporal block is that different nodes within the same model can be modeled differently. This leads to the possibility of modeling different commodities with a different resolution (e.g. electricity quarter-hourly and gas hourly). Furthermore, resolutions can be made different across regions by representing each region with its own node. When multiple nodes should be linked to the same temporal block, a node group can be defined and instead of linking all the individual nodes to a temporal block, the action can be performed once for the entire node group.[^4]

[^4]: I noticed that the result of this action is not the same as linking the individual nodes to a temporal block, it looked like the node group does not take over the demand attribute of the included nodes.
#### `units_on_temporal_block`
This relationship links the `units_on` variable of a unit to a temporal block and will therefore govern the time-resolution of the unit's online/offline status. Note that the separation between this relationship and the `node_temporal_block` relationship allows the user to give different time resolutions to the optimization of a unit's output (`unit_flow` variable) on the one hand and the same unit's on- and off status (`units_on` variable) on the other hand.
#### `unit_investment_temporal_block`
This relationship sets the temporal dimensions for investment decisions of a certain unit. The separation between this relationship and the `units_on_temporal_block`, allows the user for example to give a much finer resolution to a unit's on- or offline status than to it's investment decisions.
#### `model_default_investment_temporal_block`
Defines the default temporal block used for investment decisions, which will be replaced when a specific relationship is defined for a unit in `unit_investment_temporal_block`.
## General principle

The general principle of the Spine modeling temporal structure is that different temporal blocks can be defined and linked to different objects in a model. This leads to great flexibility in the temporal structure of the model as a whole. To illustrate this, we will discuss some of the possibilities that arise in this framework.

### One single `temporal_block`

#### Single solve
The simplest case is a single solve of the entire time horizon (so `roll_forward` not defined) with a fixed resolution. In this case, only one temporal block has to be defined with a fixed resolution. Each node has to be linked to this `temporal_block`. [^5]

TODO: varying resolution, but currently not working

#### Rolling window optimization
A model with a single `temporal_block` can also be optimized in a rolling horizon framework. In this case, the `roll_forward` parameter has to be defined in the `model_instance` object. The `roll_forward` parameter will then determine how much the optimization moves forward with every step, while the size of the temporal block will determine how large a time frame is optimized in each step. To see this more clearly, let's take a look at an example.

Suppose we want to model a horizon of one week, with a rolling window size of one day. The `roll_forward` parameter will then be a duration value of 1d. If we take the `temporal_block` parameters `block_start` and `block_end` to be the duration values 0h and 1d respectively, the model will optimize each day of the week separately. However, we could also take the `block_end` parameter to be 2d. Now the model will start by optimizing day 1 and day 2 together, after which it keeps only the values obtained for the first day, and moves forward to optimize the second and third day together.

TODO: varying resolution, but currently not working

### Advanced usage: multiple `temporal_block` objects

#### Single solve
##### Dsiconnected time periods
Multiple temporal blocks can be used to optimize disconnected periods. Let's take a look at an example in which two temporal blocks are defined.

* `temporal_block_1`
  * `block_start`: 0h
  * `block_start`: 4h
* `temporal_block_2`
  * `block_start`: 12h
  * `block_start`: 16h

This example will lead to an optimization of the first four hours of the model horizon, and also of hour 12 to 16. By defining exactly the same relationships for the two temporal blocks, an optimization of disconnected periods is achieved for exactly the same model components. This leads to the possibility of implementing the widely used representative days method. If desired, it is possible to choose a different temporal resolution for the different `temporal_blocks`.

##### Different regions/commodities in different resolutions

Multiple temporal blocks can also be used to model different regions or different commodities with a different resolution. This is especially useful when there is a certain region or commodity of interest, while other elements are connected to this but require less detail. For this kind of usage, the relationships that are defined for the temporal blocks will be different, as shown in the example below.

* `temporal_blocks`
  * `temporal_block_1`
    * `resolution`: 1h
  * `temporal_block_2`
    * `resolution`: 2h
* `nodes`
  * `node_1`
  * `node_2`
* `node_temporal_block` relationships
  * `node_1_temporal_block_1`
  * `node_2_temporal_block_2`

Similarly, the on- and offline status of a unit can be modeled with a lower resolution than the actual output of that unit, by defining the `units_on_temporal_block` relationship with a different temporal block than the one used for the `node_temporal_block` relationship (of the node to which the unit is connected).


#### Rolling horizon
##### Rolling horizon with different window sizes
Similar to what has been discussed above in [Different regions/commodities in different resolutions](@ref), different commodities or regions can be modeled with a different resolution in the rolling horizon setting. The way to do it is completely analogous. Furthermore, when using the rolling horizon framework, a different window size can be chosen for the different modeled components, by simply using a different `temporal_block_end` paramter. #TODO: What happens to coupling constraints between different regions?

##### Rolling horizon where the resolution is dependent on the absolute time
TODO : How can this be done, since there is no parameter that indicates whether a temporal block is static or rolling

##### Putting it all together: rolling horizon with variable resolution that differs for different model components
Below is an example of an advanced use case in which a rolling horizon optimization is used, and different model components are optimized with a different resolution. By choosing the relevant parameters in the following way:
* `model_instance`
  * `roll_forward`: 4h
* `temporal_blocks`
  * `temporal_block_A`
    * `resolution`: [1h 1h 2h 2h 3h 3h]
    * `block_end`: 14h
  * `temporal_block_B`
    * `resolution`: [2h 2h 4h 6h]
    * `block_end`: 14h
* `nodes`
  * `node_1`
  * `node_2`
* `node_temporal_block` relationships
  * `node_1_temporal_block_1`
  * `node_2_temporal_block_2`
The two model components that are considered have a different resolution, and their own resolution is also varying within the optimization window. Note that in this case the two optimization windows have the same size, but this is not strictly necessary. The image below visualizes the first two window optimizations of this model.
![temporal structure](Temporal_structure.svg)

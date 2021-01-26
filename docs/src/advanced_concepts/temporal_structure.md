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

#### [Object Classes](@ref)
Each `model_instance` object holds general information about the model at hand. Here we only discuss the time related parameters:
* `model_start` and `model_end` : "Date time value"
These two parameters define the model horizon. A Datetime value is to be taken for both parameters, in which case they directly mark respectively the beginning and end of the modeled time horizon.[^1]

[^1]: In the documentation of Maren, it is mentioned that the `model_end` parameter can also be given as a duration. However, this does not seem to work when I try it. I get the following error: MethodError: no method matching SpineInterface.TimeSlice(::Dates.DateTime, ::Dates.Minute; duration_unit=Dates.Minute). Furthermore, an array of DateTimes should be possible, to create non-connected periods -> to be tested.

* `duration_unit` (optional): "hour or minute"
 This parameters gives the unit of duration that is used in the model calculations. The allowed values are 'hour' and 'minute'. This parameter should be aligned with other parameters in the model, for example: when fuel costs are expressed in euro/MWh, and unit capacity in MW, then the `duration_unit` should be 'hour'. The default value for this parameter is 'minute'.

* `roll_forward` (optional): "duration value"
This parameter defines how much the optimization window rolls forward in a rolling horizon optimization and should be expressed as a duration. In a rolling horizon optimization, a (small) part of the model is optimized at each iteration, after which the window rolls forward to optimize a different part. Overlap between consecutive optimization windows is possible. Let's take a look at this by means of an example. Suppose we have a model that has a time horizon of one week. When no `roll_forward` is defined, the full week is optimized in a single solve. However, when `roll_forward` is set to 24h, an optimization would take place for the first day only, after which the window rolls forward and optimizes the second day separately and so on. The default value of this parameter is the entire model time horizon, which leads to a single optimization for the entire time horizon.




#### `temporal_block`
A temporal block defines the properties of the time range that is to be solved. A single model can have multiple temporal blocks, which is one of the main sources of temporal flexibility in Spine: by linking different parts of the model to different temporal blocks, a single model can contain aspects that are solved with different temporal resolutions or time horizons.

* `resolution` (optional): "duration value" or "array of duration values"
This parameter specifies the resolution of the temporal block, or in other words: the length of the timesteps used in the optimization run. Generally speaking, variables and constraints are generated for each timestep of an optimization. For example, the nodal balance constraint must hold for each timestep.[^3] The default value for this parameter is 1 hour.

[^3]: It is possible to give as input an array of durations, but this does not seem to be working for me. error message: MethodError: no method matching zero(::SpineInterface.Duration) in the code line: _time_interval_blocks at SpineOpt\nWeao\src\data_structure\temporal_structure.jl:153

* `block_start` (optional): "duration value" or "Date time value"
Indicates the start of this temporal block. When a Date time value is chosen, this is directly the start of the optimization for this temporal block. When a duration is chosen, it is added to the `model_start` to obtain the start of this `temporal_block`. The default value for this parameter is the `model_start`.
* `block_end`(optional): "duration value" or "Date time value"
Completely equivalent to `block_start` except that the default value is now `model_end`. When a duration is taken, it is also added to the `model_start`.

Note that when a single temporal block is defined for the model, the more stringent borders of the two intervals [`model_start` , `model_end`], [`block_start` , `block_end`] will be used for the optimization timeframe.

### Relationships

#### `model_instance_temporal_block`
In this relationship, a model instance is linked to a temporal block.
#### `model_default_temporal_block`
Defines the default temporal block used for model objects, which will be replaced when a specific relationship is defined for a model in `model_instance_temporal_block`.
#### `node_temporal_block`
This relationship will link a node to a temporal block. A node has to be linked to a temporal block, otherwise it will not be included in an optimization. When multiple nodes should be linked to the same temporal block, a node group can be defined and instead of linking all the individual nodes to a temporal block, the action can be performed once for the entire node group.[^4]

[^4]: I noticed that the result of this action is not the same as linking the individual nodes to a temporal block, it looked like the node group does not take over the demand attribute of the included nodes.
#### `units_on_temporal_block`
This relationship links the `units_on` variable of a unit to a temporal block and will therefore govern the time-resolution of the unit's online/offline status. Note that the separation between this relationship and the `node_temporal_block` relationship allows the user to give different time resolutions to the optimization of a unit's output (`unit_flow` variable) on the one hand and the same unit's on- and off status (`units_on` variable) on the other hand.
#### `unit_investment_temporal_block`
This relationship sets the temporal dimensions for investment decisions of a certain unit. The separation between this relationship and the `units_on_temporal_block`, allows the user for example to give a much coarser resolution to a unit's on- or offline status than to it's investment decisions.
#### `model_default_investment_temporal_block`
Defines the default temporal block used for investment decisions, which will be replaced when a specific relationship is defined for a unit in `unit_investment_temporal_block`.
## General principle

The general principle of the Spine modeling temporal structure is that different temporal blocks can be defined and linked to different objects in the a model. This leads to great flexibility in the temporal structure of the model as a whole. To illustrate this, we will discuss some of the possibilities that arise in this framework.

### Minimal requirements to get a model running: one single `temporal_block`
The simplest case is a single solve of the entire time horizon (so `roll_forward` not defined) with a fixed resolution. In this case, only one temporal block has to be defined with a fixed resolution. Each node has to be linked to this `temporal_block`. [^5]

[^5]: When I figure out how to make this work, I plan to include something here on a single temporal_block with a varying resolution.

A model with a single `temporal_block` can also be optimized in a rolling horizon framework. In this case, the `roll_forward` parameter has to be defined in the `model_instance` object. The `roll_forward` parameter will then determine how much the optimization moves forward with every step, while the size of the temporal block will determine how large a time frame is optimized in each step. To see this more clearly, let's take a look at an example.

Suppose we want to model a horizon of one week, with a rolling window size of one day. The `roll_forward` parameter will then be a duration value of 1d. If we take the `temporal_block` parameters `block_start` and `block_end` to be the duration values 0h and 1d respectively, the model will optimize each day of the week separately. However, we could also take the `block_end` parameter to be 2d. Now the model will start by optimizing day 1 and day 2 together, after which it keeps only the values obtained for the first day, and moves forward to optimize the second and third day together.

TODO: disconnected optimization periods

### Advanced usage: multiple `temporal_block` objects

TODO: I have tested some simple cases (the ones described in the relationship class descriptions), but more advanced cases are still to be tested and documented.

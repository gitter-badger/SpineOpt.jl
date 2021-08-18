# Stochastic Framework

## Stochastic analysis for optimization problems

Stochastic optimization refers to a collection of methods for minimizing or maximizing an objective function when randomness is present.
Specific applications are varied, but include: running simulations to refine the placement of acoustic sensors on a beam, deciding when to release water from a reservoir for hydroelectric power generation, and optimizing the parameters of a statistical model for a given data set. Randomness usually enters the problem in two ways: through the cost function or the constraint set.

Like deterministic optimization, there is no single solution method that works well for all problems. Structural assumptions, such as limits on the size of the decision and outcome spaces, or convexity, are needed to make problems tractable.

Usually, there is a division between solution methods for problems with a single time period (single stage problems) and those with multiple time periods (multistage problems), which are the most prominent ones.
Single stage problems try to find a single, optimal decision, such as the best set of parameters for a statistical model given data. Whereas, multistage problems try to find an optimal sequence of decisions, such as scheduling water releases from hydroelectric plants over a two year period.

Single stage problems are usually solved with modified deterministic optimization methods.
However, the dependence of future decisions on random outcomes makes direct modification of deterministic methods difficult in multistage problems. Multistage methods are more reliant on statistical approximation and strong assumptions about problem structure, such as finite decision and outcome spaces, or a compact Markovian representation of the decision process.

## Stochastic analysis using *SpineOpt.jl*

Scenario-based stochastics in unit commitment and economic dispatch models typically only consider branching scenario trees.
However, sometimes the available stochastic data doesn't span over the entire desired modelling horizon,
or all the modelled phenomena.
Especially with increasing interest in energy system integration and sector coupling,
stochastic data of consistent quality and/or length might be hard to come by.

While these data issues can be circumvented by either cloning stochastic data across multiple scenario branches
or generating dummy forecasts, they can result in inflated problem sizes.
Furthermore, ensuring realistic correlations between generated forecasts is extremely difficult,
especially across multiple energy sectors.

The stochastic framework in *SpineOpt.jl* aims to support stochastic directed acyclic graphs (DAGs)
instead of only branching trees, allowing for scenarios to converge later on in the modelled horizon.
In addition, the framework allows for slightly different stochastic scenario graphs for different variables,
making it easier to define e.g. variables common between all stochastic scenarios.

## Key concepts

Here, we briefly describe the key concepts required to understand the stochastic framework:

1. **[stochastic\_scenario](@ref)** is essentially just a label for an alternative period of time, describing one possiblity of what may come to pass. Even in deterministic modelling with *SpineOpt.jl*, a single [stochastic\_scenario](@ref) is required for labelling the deterministic timeline.

2. **Stochastic DAG** is the directed acyclic graph describing the [parent\_stochastic\_scenario\_\_child\_stochastic\_scenario](@ref) relationships between the `stochastic scenarios`. The key difference between a *stochastic DAG* and a traditional *stochastic tree* is that the scenarios are allowed to have multiple parents, making it possible to converge scenarios into each other in addition to branching.

3. **Stochastic path** is a unique sequence of `stochastic scenarios` for traversing the *stochastic DAG*. Every *(finite) stochastic DAG* has a limited number of *full stochastic paths* that traverse it from roots *(scenarios without parents)* to leaves *(scenarios without children)*. Here, we use the term *stochastic path* to refer to any subset of scenarios within a *full stochastic path*.

4. **[stochastic\_structure](@ref)** is essentially a "realization" of the *stochastic DAG*, with additional information like the [stochastic\_scenario\_end](@ref) and [weight\_relative\_to\_parents](@ref) [Parameters](@ref). These become relevant when we start discussing interactions between different `stochastic structures`.

```@raw html
<img src="../../figs/dag_fullpath_path.svg" width="40%"/>
```

The above figure presents an example *stochastic DAG* with the individual `stochastic scenarios` labelled from `s0-s8`.
An example *full stochastic path* `[s0, s1, s5, s8]` is highlighted in red,
while an example *stochastic path* `[s2, s4, s7]` is highlighted in blue.

## General idea in brief

The major issue with *stochastic DAGs* compared to *stochastic trees*, is that indexing constraints that
include variables from multiple time steps *(henceforth referred to as "dynamic constraints")* needs rethinking.
With *stochastic trees*, constraints can always be unambiguously indexed using `(stochastic_scenario, last_time_step)`,
since all `stochastic scenarios` only have a single parent.
However, this is no longer the case for *stochastic DAGs*, as illustrated in the figures below:

```@raw html
<img src="../../figs/branching.svg" width="40%"/>
<img src="../../figs/converging.svg" width="40%"/>
```

The example on the left illustrates the "traditional" indexing in branching *stochastic trees*,
where backtracking through the tree always leads to unambiguous `(stochastic_scenario, time_step)` indices.
The example on the right shows a similar situation in a *stochastic DAG*, where backtracking through the DAG leads to four
different `(stochastic_scenario, time_step)` indices, and thus requires four constraints to be generated and indexed.

### Stochastic path indexing

As discussed in the previous section, dynamic constraints in *stochastic DAGs* cannot be unambiguously indexed
using a single `(stochastic_scenario, time_step)`.
However, they *can* be unambiguously indexed using `(stochastic_path, time_step)`,
where the *stochastic path* is the unique sequence of `stochastic scenarios` traversing the DAG.
Since there are only a limited number of ways to traverse the DAG, represented by the *full stochastic paths*,
we can identify the number of unique paths necessary for constraint generation as follows:

1. Identify all unique *full stochastic paths*, meaning all the possible ways of traversing the DAG from roots to leaves.
2. Find all the `stochastic scenarios` that are active on all the `time steps` included in the constraint.
3. Find all the unique *stochastic paths* by intersecting the set of active `stochastic scenarios` with the *full stochastic paths*.
4. Generate constraints over each unique *stochastic path* found in step 3.

#### Example dynamic constraint generation

```@raw html
<img src="../../figs/constraint_paths.svg" width="40%"/>
```

The above figure shows examples of two different dynamic constraints generated in a *stochastic DAG*:
the red constraint including variables from timesteps `t4-t5`
and the blue constraint including variables from timesteps `t1, t3`.
The *full stochastic paths* for traversing the above DAG are as follows:

1. `[s0, s1, s5, s8]`
2. `[s0, s2, s3, s5, s8]`
3. `[s0, s2, s4, s6, s8]`
4. `[s0, s2, s4, s7, s8]`

For the red constraint, the `stochastic scenarios` `s5-s8` are active on the `time steps` `t4-t5`.
All the above *full stochastic paths* include at least two of the active `stochastic scenarios`,
but full paths 1 and 2 both produce an identical path `[s5, s8]`,
so the set of unique *stochastic paths* for the red constraint becomes:

1. `[s5, s8]`
2. `[s6, s8]`
3. `[s7, s8]`

There are no paths `[s5, s6], [s5, s7], [s6, s7]` since following the DAG one cannot start from `s5` and end up in `s6`,
even though these `stochastic scenarios` are active.

The blue constraint illustrates a case where the time step range is non-continuous.
The active `stochastic scenarios` on `t1, t3` are `s1, s2, s4, s5`,
so again by comparing these to the *full stochastic paths* we get:

1. `[s1, s5]`
2. `[s2, s5]`
3. `[s2, s4]`

In this case, the *full stochastic paths* 3 and 4 both produce the path `[s2, s4]`,
so only three unique constraints need to be generated.
Again, the path `[s1, s4]` is invalid, since the DAG cannot be traversed from `s1` to `s4`.

### Interaction between different stochastic structures

*Stochastic path* indexing in constraints also allows for "distorting" the *stochastic DAG* in different parts of the model.
As long as the *stochastic DAG* itself isn't changed,
meaning the [parent\_stochastic\_scenario\_\_child\_stochastic\_scenario](@ref) relationships and the resulting *full stochastic paths*,
we can actually define different `stochastic structures` and still be able to handle constraint generation between them.
This is due to the fact that when determining the *stochastic paths*,
it makes no difference whether we're looking at the same [stochastic\_structure](@ref) at different `time steps`,
or at two `stochastic structures`, one of which has been delayed, on the same `time step`.
This is illustrated by the figure below:

```@raw html
<img src="../../figs/delayed_stochastic_paths.svg" width="50%"/>
```

The above represents constraint generation over two `stochastic structures`,
where the lower [stochastic\_structure](@ref) has been delayed in respect to the one above.
Nevertheless, the procedure for finding the *stochastic paths* for the constraints remains identical to the previous example:

1. Identify all unique *full stochastic paths*, meaning all the possible ways of traversing the DAG. As long as the DAG remains the same between all the involved `stochastic structures`, the pathing remains the same.
2. Find all the `stochastic scenarios` that are active on all the `stochastic structures` and `time steps` included in the constraint.
3. Find all the unique stochastic paths by intersecting the set of active scenarios with the *full stochastic paths*.
4. Generate constraints over each unique stochastic path found in step 3.


## Stochastics in the model data structure

While the [Key concepts](@ref) and [General idea in brief](@ref) sections go over the stochastic framework
in *SpineOpt.jl* in a more general sense, here we'll go over how to set up stochastics using *SpineOpt.jl* data structure.
Simple step-by-step examples are also provided in the [Example of deterministic stochastics](@ref),
[Example of branching stochastics](@ref), and [Example of converging stochastics](@ref) sections further below.
We won't go into too much detail about the related [Object Classes](@ref), [Relationship Classes](@ref), or
[Parameters](@ref), since those can be found in their respective sections.
Introductions to these concepts can also be found in the [Structural object classes](@ref) and
[Structural relationship classes](@ref) sections, if necessary.

### Setting up the stochastic framework

As with all things in *SpineOpt.jl*, you'll want to start with adding the desired number of objects to the relevant
[Object Classes](@ref), as one cannot define relationships over objects that don't exist.
For the stochastic framework, this means creating at least one [stochastic\_scenario](@ref) and
[stochastic\_structure](@ref) object each.
This needs to be done even if your model is fully deterministic, as even the deterministic structure needs to be
labelled for *SpineOpt.jl* to recognize that it exists.

Next, if your model has multiple [stochastic\_scenario](@ref) objects, you'll want to define how they are related
using the [parent\_stochastic\_scenario\_\_child\_stochastic\_scenario](@ref) relationship.
This relationship essentially defines the *stochastic DAG*, as well as all the possible *stochastic paths*,
explained in the [Key concepts](@ref) section.
Unless the [parent\_stochastic\_scenario\_\_child\_stochastic\_scenario](@ref) relationship is defined,
there won't be a *stochastic DAG*, and all [stochastic\_scenario](@ref) objects will be assumed to be completely
independent of each other.

Now that you've set up the desired [stochastic\_scenario](@ref) and [stochastic\_structure](@ref) objects, as well as
defined the *stochastic DAG* using the [parent\_stochastic\_scenario\_\_child\_stochastic\_scenario](@ref) relationship,
it's time to define the properties of the [stochastic\_structure](@ref) objects using the
[stochastic\_structure\_\_stochastic\_scenario](@ref) relationship, and the [stochastic\_scenario\_end](@ref) and
[weight\_relative\_to\_parents](@ref) [Parameters](@ref) therein.
You'll always have to define at least one [stochastic\_structure\_\_stochastic\_scenario](@ref) relationship,
as the [stochastic\_structure](@ref) object is what connects the [Systemic object classes](@ref)
to the stochastic framework.
[stochastic\_structure\_\_stochastic\_scenario](@ref) relationship holds two key [Parameters](@ref):

- **[weight\_relative\_to\_parents](@ref)** defines the coefficient the corresponding [stochastic\_scenario](@ref) has in the [Objective function](@ref), and needs to be defined for each [stochastic\_scenario](@ref) included in the [stochastic\_structure](@ref). The weight is relative to the parents of the [stochastic\_scenario], and is calculated as presented below.

```
# For root `stochastic_scenarios` (meaning no parents)

weight(scenario) = weight_relative_to_parents(scenario)

# If not a root `stochastic_scenario`

weight(scenario) = sum([weight(parent) * weight_relative_to_parents(scenario)] for parent in parents)
```

- **[stochastic\_scenario\_end](@ref)** is a `Duration` type parameter that tells when the [stochastic_scenario](@ref) ends in relation to the start of the current optimization. When defined, the [stochastic\_scenario](@ref) ends at the defined point in time, and spawns its children according to [parent\_stochastic\_scenario\_\_child\_stochastic\_scenario](@ref), if any. **Note that this means the children are included in the [stochastic\_structure](@ref), even without an explicit relationship!** If [stochastic\_scenario\_end](@ref) isn't defined, the [stochastic_scenario](@ref) is assumed to go on indefinetely.

Finally, with all the pieces in place, we'll need to connect the defined [stochastic\_structure](@ref) objects to the
desired objects in the [Systemic object classes](@ref) using the [Structural relationship classes](@ref) like 
[node\_\_stochastic\_structure](@ref) etc.
Here, we essentially tell which parts of the modelled system use which [stochastic\_structure](@ref).
Since creating each of these relationships individually can be a bit of a pain, there are a few
[Meta relationship classes](@ref) like the [model\_\_default\_stochastic\_structure](@ref),
that can be used to set [model](@ref)-wide defaults that are used if specific relationships are missing.

### Example of deterministic stochastics

Here, we'll demonstrate step-by-step how to create the simplest possible stochastic frame: the fully deterministic one.
See the [Deterministic Stochastic Structure](@ref) [archetype](@ref Archetypes) for how the final data structure looks like,
as well as how to connect this `stochastic_structure` to the rest of your model.

1. Create a [stochastic\_scenario](@ref) called e.g. `realization` and a [stochastic\_structure](@ref) called e.g. `deterministic`.
2. We can skip the [parent\_stochastic\_scenario\_\_child\_stochastic\_scenario](@ref) relationship, since there isn't a *stochastic DAG* in this example, and the default behaviour of each [stochastic\_scenario](@ref) being independent works for our purposes *(only one [stochastic\_scenario](@ref) anyhow)*.
3. Create the [stochastic\_structure\_\_stochastic\_scenario](@ref) relationship for `(deterministic, realization)`, and set its [weight\_relative\_to\_parents](@ref) parameter to 1. We don't need to define the [stochastic\_scenario\_end](@ref) parameter, as we want the `realization` to go on indefinitely.
4. Relate the `deterministic` [stochastic\_structure](@ref) to all the desired system objects using the appropriate [Structural relationship classes](@ref), or use the [model](@ref)-level default [Meta relationship classes](@ref).

### Example of branching stochastics

Here, we'll demonstrate step-by-step how to create a simple branching stochastic tree, where one scenario branches into
three at a specific point in time.
See the [Branching Stochastic Tree](@ref) [archetype](@ref Archetypes) for how the final data structure looks like,
as well as how to connect this `stochastic_structure` to the rest of your model.

1. Create four [stochastic\_scenario](@ref) objects called e.g. `realization`, `forecast1`, `forecast2`, and `forecast3`, and a [stochastic\_structure](@ref) called e.g. `branching`.
2. Define the *stochastic DAG* by creating the [parent\_stochastic\_scenario\_\_child\_stochastic\_scenario](@ref) relationships for `(realization, forecast1)`, `(realization, forecast2)`, and `(realization, forecast3)`.
3. Create the [stochastic\_structure\_\_stochastic\_scenario](@ref) relationship for `(branching, realization)`, `(branching, forecast1)`, `(branching, forecast2)`, and `(branching, forecast3)`.
4. Set the [weight\_relative\_to\_parents](@ref) parameter to 1 and the [stochastic\_scenario\_end](@ref) parameter e.g. to `6h` for the [stochastic\_structure\_\_stochastic\_scenario](@ref) relationship `(branching, realization)`. Now, the `realization` [stochastic\_scenario](@ref) will end after 6 hours of `time steps`, and its children *(`forecast1`, `forecast2`, and `forecast3`)* will become active.
5. Set the [weight\_relative\_to\_parents](@ref) [Parameters](@ref) for the `(branching, forecast1)`, `(branching, forecast2)`, and `(branching, forecast3)` [stochastic\_structure\_\_stochastic\_scenario](@ref) relationships to whatever you desire, e.g. 0.33 for equal probabilities across all forecasts.
6. Relate the `branching` [stochastic\_structure](@ref) to all the desired system objects using the appropriate [Structural relationship classes](@ref), or use the [model](@ref)-level default [Meta relationship classes](@ref).

### Example of converging stochastics

Here, we'll demonstrate step-by-step how to create a simple *stochastic DAG*, where both branching and converging occurs.
This example relies on the previous [Example of branching stochastics](@ref), but adds another [stochastic\_scenario](@ref)
at the end, which is a child of the `forecast1`, `forecast2`, and `forecast3` scenarios.
See the [Converging Stochastic Tree](@ref) [archetype](@ref Archetypes) for how the final data structure looks like,
as well as how to connect this `stochastic_structure` to the rest of your model.

1. Follow the steps 1-5 in the previous [Example of branching stochastics](@ref), except call the [stochastic\_structure](@ref) something different, e.g. `converging`.
2. Create a new [stochastic\_scenario](@ref) called e.g. `converged_forecast`.
3. Alter the *stochastic DAG* by creating the [parent\_stochastic\_scenario\_\_child\_stochastic\_scenario](@ref) relationships for `(forecast1, converged_forecast)`, `(forecast2, converged_forecast)`, and `(forecast3, converged_forecast)`. Now all three forecasts will converge into a single `converged_forecast`.
4. Add the [stochastic\_structure\_\_stochastic\_scenario](@ref) relationship for `(converging, converged_forecast)`, and set its [weight\_relative\_to\_parents](@ref) parameter to 1. Now, all the probability mass in `forecast1`, `forecast2`, and `forecast3` will be summed up back to the `converged_forecast`.
5. Set the [stochastic\_scenario\_end](@ref) [Parameters](@ref) of the [stochastic\_structure\_\_stochastic\_scenario](@ref) relationships `(converging, forecast1)`, `(converging, forecast2)`, and `(converging, forecast3)` to e.g. `1D`, so that all three scenarios end at the same time and the `converged_forecast` becomes active.
6. Relate the `converging` [stochastic\_structure](@ref) to all the desired system objects using the appropriate [Structural relationship classes](@ref), or use the [model](@ref)-level default [Meta relationship classes](@ref).

## Working with stochastic updating data

Now that we've discussed how to set up stochastics for SpineOpt, let's focus on stochastic data.
The most complex form of input data SpineOpt can currently handle is both *stochastic* and *updating*,
meaning that the values the parameter takes can depend on both the [stochastic\_scenario](@ref),
and the *analysis time (first time step)* of each solve.
However, just *stochastic* or just *updating* cases are supported as well, using the same input data format.

In SpineOpt, stochastic data uses the `Map` data type from [*SpineInterface.jl*](https://github.com/Spine-project/SpineInterface.jl).
Essentially, `Maps` are general indexed data containers, which SpineOpt tries to interpret as stochastic data.
Every time SpineOpt calls a parameter, it passes the [stochastic\_scenario](@ref) and *analysis time* as keyword
arguments to the parameter, but depending on the parameter type,
it doesn't necessarily do anything with that information.
For `Map` type parameters, those keyword arguments are used for navigating the indices of the `Map` to try and find
the corresponding value.
If the `Map` doesn't include the [stochastic\_scenario](@ref) index it's looking for,
it assumes there's no *stochastic* information in the `Map` and carries on to search for *analysis time* indices.
This logic is useful for defining both *stochastic* and *updating* data, as well as either case by itself,
as shown in the following examples.

### Example of stochastic data

By *stochastic data*, we mean parameter values that depend only on the [stochastic\_scenario](@ref).
In such a case, the input data must be formatted as a `Map` with the following structure

|[stochastic\_scenario](@ref)|value|
|---|---|
|`scenario1`|`value1`|
|`scenario2`|`value2`|

where [stochastic\_scenario](@ref) indices are simply `Strings` corresponding to the names of the [stochastic\_scenario](@ref) objects.
The *values* can be whatever data types [*SpineInterface.jl*](https://github.com/Spine-project/SpineInterface.jl)
supports, like `Constants`, `DateTimes`, `Durations`, or `TimeSeries`.
In the above example, the parameter will take `value1` in `scenario1`, and `value2` in `scenario2`.
Note that since there's no *analysis time* index in this example, the *values* are used regardless of the *analysis time*.

### Example of updating data

By *updating data*, we mean parameter values that depend only on the *analysis time*.
In such a case, the input data must be formatted as a `Map` with the following structure

|analysis time|value|
|---|---|
|`2000-01-01T00:00:00`|`value1`|
|`2000-01-01T12:00:00`|`value2`|

where the *analysis time* indices are `DateTime` values.
The *values* can be whatever data types [*SpineInterface.jl*](https://github.com/Spine-project/SpineInterface.jl)
supports, like `Constants`, `DateTimes`, `Durations`, or `TimeSeries`.
In the above example, the parameter will take `value1` if the first time step of the current simulation is between
`2000-01-01T00:00:00` and `2000-01-01T12:00:00`, and `value2` if the first time step of the simulation is after
`2000-01-01T12:00:00`.
Note that since there's no [stochastic\_scenario](@ref) index in this example,
the *values* are used regardless of the [stochastic\_scenario](@ref).

### Example of stochastic updating data

By *stochastic updating data*, we mean parameter values that depend on both the [stochastic\_scenario](@ref)
and the *analysis time*.
In such a case, the input data must be formatted as a `Map` with the following structure

|[stochastic\_scenario](@ref)|analysis time|value|
|---|---|---|
|`scenario1`|`2000-01-01T00:00:00`|`value1`|
|`scenario1`|`2000-01-01T12:00:00`|`value2`|
|`scenario2`|`2000-01-01T00:00:00`|`value3`|
|`scenario2`|`2000-01-01T12:00:00`|`value4`|

where the [stochastic\_scenario](@ref) indices are simply `Strings` corresponding to the names of the [stochastic\_scenario](@ref) objects,
and the *analysis time* indices are `DateTime` values.
The *values* can be whatever data types [*SpineInterface.jl*](https://github.com/Spine-project/SpineInterface.jl)
supports, like `Constants`, `DateTimes`, `Durations`, or `TimeSeries`.
In the above example, the parameter will take `value1` if the first time step of the current simulation is between
`2000-01-01T00:00:00` and `2000-01-01T12:00:00` and the parameter is called in `scenario1`, and `value3` in `scenario2`.
If the first time step of the current simulation is after `2000-01-01T12:00:00`,
the parameter will take `value2` in `scenario1`, and `value4` in `scenario2`.

## Constraint generation with stochastic path indexing

Every time a constraint might refer to variables either on different time steps or on different `stochastic scenarios`
(meaning different `nodes` or `units`), the constraint needs to use stochastic path indexing in order to be correctly
generated for arbitrary stochastic DAGs.
In practise, this means following the procedure outlined below:

1. Identify all unique *full stochastic paths*, meaning all the possible ways of traversing the DAG. This is done along with generating the stochastic structure, so no real impact on constraint generation.
2. **Find all the `stochastic scenarios` that are active on all the `stochastic structures` and `time slices` included in the constraint.**
3. **Find all the unique stochastic paths by intersecting the set of active scenarios with the *full stochastic paths*.**
4. Generate constraints over each unique stochastic path found in step 3.

Steps 2 and 3 are the crucial ones, and are currently handled by separate `constraint_<constraint_name>_indices` functions.
Essentially, these functions go through all the variables on all the time steps included in the constraint,
collect the set of active `stochastic_scenarios` on each time step,
and then determine the unique active stochastic paths on each time step.
The functions pre-form the index set over which the constraint is then generated in the `add_constraint_<constraint_name>` functions.
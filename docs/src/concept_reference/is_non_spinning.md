By setting the parameter [is\_non\_spinning](@ref) to `true`, a node is treated as a non-spinning reserve node. Note that this is only to differentiate spinning from non-spinning reserves.
It is still necessary to define the [is\_reserve\_node](@ref) to `true`.
reserve [node](@ref) in the model. To define the maximum reserve provision of a non-spinning reserve flow (defined on a [unit\_\_to\_node](@ref) relationship), it is also necessary to define the [max\_res\_startup\_ramp](@ref) and the [max\_res\_shutdown\_ramp](@ref) parameters, respectively. It is also possible to define a minimum reserve provision ramp by defining the parameters [min\_res\_startup\_ramp](@ref) and [min\_res\_shutdown\_ramp](@ref). The mathematical formulation holds a chapter on [Ramping and reserve constraints](@ref)
and the general concept of setting up a model with reserves is described in [Ramping and Reserves](@ref).
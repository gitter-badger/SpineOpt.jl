The `fix_nonspin_units_shut_down` parameter simply fixes the value of the [nonspin\_units\_shut\_down](@ref) variable to the provided value. As such, it determines directly how many member [units](@ref unit) are involved in providing downward reserve commodity flows to the [node](@ref) to which it is linked by the [unit\_\_to\_node](@ref) relationship.

When a single value is selected, this value is kept constant throughout the model. It is also possible to provide a timeseries of values, which can be used for example to impose initial conditions by providing a value only for the first timestep included in the model.
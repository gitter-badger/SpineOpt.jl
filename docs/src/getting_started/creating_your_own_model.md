# Creating Your Own Model

This part of the guide shows first an example how to insert objects and their parameter data.
Then it shows what other objects, relationships and parameter data needs to be added for a very basic model.
Lastly, the model instance is run.

This section explains the process of creating a *SpineOpt.jl* model from scratch in order to give you an understanding
of the underlying principles of the data structure, etc.
If you simply want to try something out quickly to see results, check out the [Example Models](@ref) section.
Furthermore, if you're in a hurry, the [Archetypes](@ref) section provides you with some pre-made templates
for the different parts of a *SpineOpt.jl* model to get you started quickly.

## Setting up a workflow for SpineOpt in Spine Toolbox

The next steps will set up a SpineOpt specific input database by creating a new Spine database, loading a blank SpineOpt template, connecting it to a SpineOpt instance and setting up a database for model results.

- Create a new Spine Toolbox project in an empty folder of your choice: *File* --> *New project...*
- Create the input database
    - Drag an empty *Data store* from the toolbar to the *Design View*.
    - Give it a name like "Input DB".
    - Select SQL database dialect (sqlite is a local file and works without a server).
    - Click *New Spine DB* in the *Data Store Properties* window and create a new database (and save it, if it's sqlite).
    - For more information about creating and managing Spine Toolbox database, see the [documentation](https://spine-toolbox.readthedocs.io/en/latest/spine_db_editor/index.html)

![image](https://user-images.githubusercontent.com/40472544/114974364-e8013200-9e8a-11eb-99d6-9fbbd0d3992b.png)

![image](https://user-images.githubusercontent.com/40472544/114976986-97400800-9e8f-11eb-8bec-79d85aac5a66.png)

- Fill the *Input DB* with SpineOpt data format **either** by:
    - Drag a tool *Load template* from the SpineOpt ribbon to the *Design View*.
    - Connect an arrow from the *Load template* to the new *Input DB*.
    - Make sure the  *Load template* item from the Design view is selected (then you can edit the properties of that workflow item in the *Tool properties* window.
    - Add the url link in *Available resources* to the *Tool arguments* - you are passing the database address as a command line argument to the load_template.jl script so that it knows where to store the output.
    - Then execute the *Load template* tool. Please note that this process uses SpineOpt to generate the data structure. It takes time, since everything is compiled when running a tool in Julia for the first time in each Julia session. You may also see lot of messages and warnings concernging the compilation, but they should be benign.

![image](https://user-images.githubusercontent.com/40472544/114975150-6d391680-9e8c-11eb-94d3-325f56ff55cf.png)

![image](https://user-images.githubusercontent.com/40472544/114975271-9eb1e200-9e8c-11eb-93a5-5da3d07b8039.png)

![image](https://user-images.githubusercontent.com/40472544/114975643-44fde780-9e8d-11eb-9ea6-873b39d8ce9f.png)

![image](https://user-images.githubusercontent.com/40472544/114975723-68c12d80-9e8d-11eb-8053-a17ca1190114.png)

- ...**or** by:
    - Start Julia (you can start a separate Julia console in Spine Toolbox: go to *Consoles* --> *Start Julia Console*).
    - Copy the URL address of the Data Store from the 'Data Store Properties' --> a copy icon at the bottom.
    - Then run the following script with the right URL address pasted. The process uses SpineOpt itself to build the database structure. Please note that 'using SpineOpt' for the first time for each Julia session takes time - everything is being compiled.
        - Known issue: On Windows, the backslash between directories need to be changed to a double forward slash.

```julia
julia> using SpineOpt

julia> SpineOpt.import_data("copied URL address, inside these quotes", SpineOpt.template(), "Load SpineOpt template")
```

- Drag SpineOpt tool icon to the *Design view*.
- Connect an arrow from the *Input DB* to *SpineOpt*.

![image](https://user-images.githubusercontent.com/40472544/114976496-bdb17380-9e8e-11eb-827c-232bd5027818.png)


- Create a database for results
    - Drag a new *Data store* from the toolbar to the *Design View*.
    - You can rename it to e.g. *Results*. Select SQL database dialect (sqlite is a local file and works without a server).
    - Click *New Spine DB* in the *Data Store Properties* window and create a new database (and save it, if it's sqlite).
    - Connect an arrow from the *SpineOpt* to *Results*.

![image](https://user-images.githubusercontent.com/40472544/114977707-c99e3500-9e90-11eb-9da1-356ed191ffb3.png)

- Select *SpineOpt* tool in the *Design view*.
- Add the url link for the input data store and the output data store from *Available resources* to the *Tool arguments* (in that order).

![image](https://user-images.githubusercontent.com/40472544/114977877-171aa200-9e91-11eb-89e0-9896f6cc1fab.png)

SpineOpt would be ready to run, but for the *Input DB*, which is empty of content (it's just a template that contains a SpineOpt specific data structure). The [next step](https://spine-project.github.io/SpineOpt.jl/latest/getting_started/creating_your_own_model/) goes through setting up and running a simple toy model.

## Creating a SpineOpt model instance
- First, open the database editor by double-clicking the *Input DB*.
- Right click on *model* in the *Object tree*.
- Choose *Add objects*.
- Then, add a model object by writing a name to the *object name* field. You can use e.g. *instance*.
- Click ok.
- The [model](@ref) object in SpineOpt is an abstraction that represents the model itself. Every SpineOpt database needs to have at least one `model` object.
- The model object holds general information about the optimization. The whole range of functionalities is explained in **Advanced Concepts** chapter - in here a minimal set of parameters is used.

![image](https://user-images.githubusercontent.com/40472544/114978841-880e8980-9e92-11eb-9272-5dc46708006f.png)

![image](https://user-images.githubusercontent.com/40472544/114978964-ba1feb80-9e92-11eb-9f73-14a6c11ad3bd.png)

## Add parameter values to the model instance
- Select the model object `instance` from the object tree.
- Go to the `Object parameter value` tab.
- Every parameter value belongs to a specific alternative. This allows to hold multiple values for the same parameter of a particular object. The alternative values are used to create scenarios. Choose, `Base` for all parameter values (`Base` is required in Spine Toolbox - all other alternatives can be chosen freely).
- Then define a `model_start` time and a `model_end` time. 
    - Double-click on the empty row under `parameter_name` and select [model\_start](@ref). 
    - A `None` should appear in `value` column. 
    - To asign a start date value, right-click on `None` and open the editor (cannot be entered directly, since the datatype needs to be changed). 
    - The parameter type of `model_start` is of type `Datetime`. 
    - Set the value to e.g. `2019-01-01T00:00:00`. 
    - Proceed accordingly for the [model\_end](@ref).  

![image](https://user-images.githubusercontent.com/40472544/115030082-5cf65b00-9ecf-11eb-84c3-9dc1c03d4627.png) 

Further reading on adding parameter values can be found [here](https://spine-toolbox.readthedocs.io/en/latest/spine_db_editor/adding_data.html).

## Add other necessary objects and parameter data for the objects. 
- Add all objects and their parameter data by replicating what has been done in the picture below. Do it the same way as explained above with the following caveats.
- Whilst most object names can be freely defined by the user, there is one object name in the example below that needs to be written exactly since it is used internally by SpineOpt: `unit_flow`. 
- The `parameter_name` can be selected from a drop down menu.
- The date time and time series parameter data can be added by using right-click to access the *Edit...* dialog. When creating the time series, use the fixed resolution with `Start time` of the model run and with `1h` resolution. Then only values need to be entered (or copy pasted) and time stamps come automatically.
- Parameter `balance_type` needs to have value `balance_type_none` in the gas node, since it allows the node to create energy (natural gas) against a price and therefore the energy balance is not maintained.

![image](https://user-images.githubusercontent.com/40472544/115030258-8f07bd00-9ecf-11eb-80aa-a717ba5df2f0.png)

## Define temporal and stochastic structures
- To specify the temporal structure for SpineOpt, you need to define [temporal\_block](@ref) objects. Think of a `temporal_block` as a distinctive way of 'slicing' time across the model horizon.
- To link the temporal structure to the spatial structure, you need to specify [node\_\_temporal\_block](@ref) relationships, establishing which `temporal__block` applies to each `node`. This relationship is added by right-clicking the `node__temporal_block` in the relationship tree and then using the `add relationships...` dialog. Double clicking on an empty cell gives you the list of valid objects. The relationship name is automatically formed, but you can change it if that is desirable.
- To keep things simple at this point, let's just define one `temporal_block` for our model and apply it to all `nodes`. We add the object `hourly_temporal_block` of type `temporal_block` following the same procedure as before and establish `node__temporal_block` relationships between `node_gas` and `hourly_temporal_block`, and `electricity_node` and `hourly_temporal_block`.
- In practical terms, the above means that there energy flows over `gas_node` and `electricity_node` for each 'time-slice' comprised in `hourly_temporal_block`.
- Similarly with the stochastic structure, each node is assigned a `deterministic` `stochastic_structure`. 

## Define the spatial structure
- To specify the spatial structure for SpineOpt, you will need to use the [node](@ref), [unit](@ref), and [connection](@ref) objects added before.
- Nodes can be understood as spatial aggregators. In combination with units and connections, they form the energy network.
- Units in SpineOpt represent any kind of conversion process. As one example, a unit can represent a power plant that converts the flow of a commodity fuel into an electricity and/or heat flow.
- Connections on the other hand describe the transport of goods from one location to another. Electricity lines and gas pipelines are examples of such connections. This example does not use connections.
- The database should have an object `gas_turbine` for the `unit` object class and objects `node_gas` and `node_elec` for the `node` object class.
- Next, define how the `unit` and the `nodes` interact with each other: create a [unit\_\_from\_node](@ref) relationship between `gas_turbine` and `node_gas`, and [unit\_\_to\_node](@ref) relationships between `gas_turbine` and `node_elec`.
- In practical terms, the above means that there is an energy flow going from `node_gas` into `node_elec`, through the `gas_turbine`.


## Add remaining relationships and parameter data for the relationships. 
- Similar to adding the objects and their parameter data, add the relationships and their parameter data based on the picture below. 
- The capacity of the gas_turbine has to be sufficient to meet the highest demand for electricity, otherwise the model will be infeasible (it is possible to set penalty values, but they are not included in this example).
- The parameter `fix_ratio_in_out_unit_flow` forces the ratio between an input and output flow to be a constant. This is one way to establish an efficiency for a conversion process.

![image](https://user-images.githubusercontent.com/40472544/116714620-9dc99600-a9de-11eb-869f-60bf84482888.png)

## Run the model
- Select *SpineOpt* 
- Press *Execute selection*.

![image](https://user-images.githubusercontent.com/40472544/115010605-48599900-9eb6-11eb-930d-b2a258b61bf7.png)

## If it fails
- Double-check that the data is correct
- Try to see what the problem might be
- Ask help from the [discussion forum](https://github.com/Spine-project/SpineOpt.jl/discussions)

## Explore the results 
- Double-clicking the *Results* database.

![image](https://user-images.githubusercontent.com/40472544/115010687-5d362c80-9eb6-11eb-8542-93a765c186cf.png) 

## Create and run scenarios and build the model further
- Create a new alternative
- Add parameter data for the new alternative
- Connect alternatives under a scenario. Toolbox modifies `Base` data with the data from the alternatives in the same scenario.
- Execute multiple scenarios in parallel. First run in a new Julia instance will need to compile SpineOpt taking some time.

![image](https://user-images.githubusercontent.com/40472544/116698265-d3658380-a9cc-11eb-9408-c46a9e06de74.png)

![image](https://user-images.githubusercontent.com/40472544/115011214-0da43080-9eb7-11eb-93e5-e2991e81b429.png)

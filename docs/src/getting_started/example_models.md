# Example Models

The *SpineOpt.jl* repository includes a few ready-made example models based on the case studies performed in the project.
These are included in sub-folders under `examples\`, where the input data is provided as `.json` or `.sqlite` files.
This way, you can easily get a feel for how SpineOpt works with pre-made datasets,
either through [Spine Toolbox](https://github.com/Spine-project/Spine-Toolbox), or directly from the Julia REPL.
The example models included in the *SpineOpt.jl* repository are briefly explained in the following sections.

## Simple Example

### Introduction

#### Model assumptions

Two power plants take fuel from a source node and release electricity to another node in order to supply a demand.

Power plant ‘a’ has a capacity of 25 MWh, a variable operating cost of 5 euro/fuel unit, and generates 0.8 MWh of electricity per unit of fuel.

Power plant ‘b’ has a capacity of 25 MWh, a variable operating cost of 4 euro/fuel unit, and generates 0.8 MWh of electricity per unit of fuel.

The demand at the electricity node varies during the 5-year period according to the following image :

![image](./pictures/electrical_demand.png)

The fuel node is able to provide infinite energy.

Here is scheme of the system :

![image](https://spine-toolbox.readthedocs.io/en/master/_images/simple_system_schematic.png)

### Guide

#### Entering input data

##### Importing the SpineOpt database template
- Download the basic SpineOpt database [template](https://github.com/Spine-project/SpineOpt.jl/tree/master/templates/models) (click on the link, then right-click on the file and select *Save link as*…)
- Select the ‘input’ Data Store item in the *Design View*.
- Go to *Data Store Properties* and hit **Open editor**. This will open the newly created database in the *Spine DB editor*, looking similar to this:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/case_study_a5_spine_db_editor_empty.png)

>**Note**: The *Spine DB editor* is a dedicated interface within Spine Toolbox for visualizing and managing Spine databases.

- Press **Alt + F** to display the main menu, select **File -> Import…**, and then select the template file you previously downloaded. The contents of that file will be imported into the current database, and you should then see classes like ‘commodity’, ‘connection’ and ‘model’ under the root node in the *Object tree* (on the left).
- From the main menu, select **Session -> Commit**. Enter ‘Import SpineOpt template’ as message in the popup dialog, and click **Commit**.

>**Note**: The SpineOpt basic template contains (i) the fundamental entity classes and parameter definitions that SpineOpt recognizes and expects; and (ii) some predefined entities for a common deterministic model with a ‘flat’ temporal structure.

##### Creating objects

- Always in the Spine DB editor, locate the Object tree (typically at the top-left). Expand the root element if not expanded.
- Right click on the node class, and select *Add objects* from the context menu. The *Add objects* dialog will pop up.
- Enter the names for the system nodes as seen in the image below, then press *Ok*. This will create two objects of class node, called *fuel_node* and *electricity_node*.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/simple_system_add_nodes.png)

- Right click on the *unit* class, and select *Add objects* from the context menu. The *Add objects* dialog will pop up.
- Enter the names for the system units as seen in the image below, then press *Ok*. This will create two objects of class *unit*, called *power_plant_a* and *power_plant_b*.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/simple_system_add_units.png)

>**Note**: In SpineOpt, nodes are points where an energy balance takes place, whereas units are energy conversion devices that can take energy from nodes, and release energy to nodes.

- Right click on the output class, and select *Add objects* from the context menu. The *Add objects* dialog will pop up.
- Enter *unit_flow* under object name as in the image below, then press *Ok*. This will create one object of class *unit*, called *unit_flow*.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/simple_system_add_output.png)

>**Note**: In SpineOpt, outputs represent optimization variables that can be written to the output database as part of a report.

>**Note**:
To modify an object after you enter it, right click on it and select **Edit…** from the context menu.

##### Establishing relationships

- Always in the Spine DB editor, locate the *Relationship tree* (typically at the bottom-left). Expand the *root* element if not expanded.
- Right click on the *unit__from_node* class, and select *Add relationships* from the context menu. The *Add relationships* dialog will pop up.
- Select the names of the two units and their **sending** nodes, as seen in the image below; then press *Ok*. This will establish that both *power_plant_a* and *power_plant_b* take energy from the *fuel_node*.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/simple_system_add_unit__from_node_relationships.png)

- Right click on the *unit__to_node* class, and select *Add relationships* from the context menu. The *Add relationships* dialog will pop up.
- Select the names of the two units and their **receiving** nodes, as seen in the image below; then press *Ok*. This will establish that both *power_plant_a* and *power_plant_b* release energy into the *electricity_node*.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/simple_system_add_unit__to_node_relationships.png)

- Right click on the *report__output class*, and select *Add relationships* from the context menu. The *Add relationships* dialog will pop up.
- Enter *report1* under *report*, and *unit_flow* under *output*, as seen in the image below; then press *Ok*. This will tell SpineOpt to write the value of the *unit_flow* optimization variable to the output database, as part of *report1*.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/simple_system_add_report__output_relationships.png)

##### Specifying object parameter values

- Back to *Object tree*, expand the *node* class and select *electricity_node*.
- Locate the *Object parameter* table (typically at the top-center).
- In the *Object parameter* table (typically at the top-center), select the *demand parameter* and the *Base* alternative.
- The value was chosen to be a Time series with a fixed resolution of 1 month. But this choice was arbitrary, therefore you can set the values that suits your application.

![image](./pictures/electricity_node.png)
![image](./pictures/demand.png)

- Select *fuel_node* in the *Object tree*.
- In the *Object parameter* table, select the *balance_type* parameter and the *Base* alternative, and enter the value *balance_type_none* as seen in the image below. This will establish that the fuel node is not balanced, and thus provide as much fuel as needed.

![image](./pictures/fuel_node.png)


##### Specifying relationship parameter values

In a similar way as for the object parameter values, you can set the relationships according to the following picture :

![image](./pictures/units_relationships.png)

When you’re ready, commit all changes to the database.

#### Executing the setup_workflow

Go back to Spine Toolbox’s main window, and hit the Execute project button from the tool bar.
You should see ‘Executing All Directed Acyclic Graphs’ printed in the Event log (at the bottom left by default).

Select the ‘Run SpineOpt 1’ Tool. You should see the output from SpineOpt in the Julia Console.

#### Examining the results

Select the output data store and open the Spine DB editor.
Press **Alt + F** to display the main menu, and select Pivot $->$ Index.
Select report-unit-node-direction-stochastic-scenario under Relationship tree, and the first cell under alternative in the Frozen table.
The Pivot table will be populated with results from the SpineOpt run. It will look something like the image below. (+image)

![image](https://spine-toolbox.readthedocs.io/en/master/_images/simple_system_results_pivot_table.png)

#### Advanced concepts

##### Temporal Framework

We can set different *temporal  blocks* and apply them to different *nodes* or *unit* whishing to enlight the fact that some of them behave following a certain time resolution whereas the other follow another time resolution.

In this case, for example, we can set that the *fuel_node* adapts itself to the demand on a yearly basis, whereas the *electricity_node* follows a variable monthly demand. The following pictures shows how the parameters should be set.

![image](./pictures/temporal_framework.png)

This use of the temporal framework properties is depicted for a simple model, but it can be included in more complex models following a similar procedure. One has only to pay attention that the definition of the *temporal__block* structure is a representation of something that can happen in reality.


##### Stochastic framework

We can conduct a few stochastic analysis based on the Stochastic Framework. In order to do that, import the **.json** files from this [link](https://github.com/Spine-project/SpineOpt.jl/tree/master/templates/archetypes).


**Deterministic Stochastic Structure**
>`templates/archetypes/deterministic_stochastic_structure.json`

The deterministic stochastic structure will only create a structure called *realization* that will have a probability of occurence of *1*. Therefore, it is called a deterministic structure.

**Branching Stochastic Tree**
>`templates/archetypes/branching_stochastic_tree.json`

As explained in the section [Archetypes](@ref), the branching stochastic framework allows to consider different scenario with a fixed probability of occurence. In this case for example, we could investigate the *vom_cost* i.e. the operational costs of a given unit, and look especially at what would happen if :
- the costs are at a high value with a 30% probability
- the costs are at a low value with a 70% probability

This can be set using the following picture :

![image](./pictures/branching_scenario.png)

During the first 6 months, the model behaves according to the `realization` scenario and the demand evolves according to the following picture :

![image](./pictures/realization.png)

Then for the rest of the period (4,5 years) the model behaves according to the `branching` stochastic structure and the demand evolves according to the following picture :

![image](./pictures/branching.png)


**Converging Stochastic Tree**
>`templates/archetypes/converging_stochastic_tree.json`

It is also possible to include a directed acyclic graph, DAG, into the stochastic analysis.
You can do that by creating a stochastic_structure that starts out as a single *stochastic_scenario* called *realization*, which then branches out into three roughly equiprobable *stochastic_scenarios* called *forecast1*, *forecast2*, and *forecast3* after 6 hours. Then, after 24 hours (1 day), these three forecasts converge into a single *stochastic_scenario* called *converged_forecast*.

#### Investment Optimization

It is interesting as well to look at the way the model adapts itself when an investment strategy is present.

As presented in the section **Investment Optimization**, there are a few parameters that can be set, either on a unit, a node or a connection, in order to include an investment strategy into the model.

In this example, it was chosen to set the `candidate_units`, `unit_investment_cost`, `unit_investment_lifetime` and  `unit_investment_variable_type`parameters as can be seen on the picture down below.

![image](./pictures/investment.png)

In order for the model to run appropriately, it's important to make sure that the relationships `model_default_investment_stochastic_structure` and `model_default_investment_temporal_block` are defined.

In this example, as it is chosen to invest in the two units, one should also care that the relationships `unit_investment_stochastic_structure` and `unit_investment_temporal_block` are correctly defined.

For this specific problem, with the specific demand on the `electricity_node`, we get the results depicted on the pictures down below.

The model choses to start initially by investing in 4 units of power_plant_b to meet the demand. Then after 1 month, it already suggest to invest in a unit of power_plant_a and in another one after 1 year and 9 months.

![image](./pictures/investment_units.png)

As it was decided to apply a monthly `temporal_block` on the `electricity_node` and a yearly `temporal_block` on the `fuel_node`, we see that the energy flow on the different nodes changes according to different time steps. We can see that on the following pictures.

![image](./pictures/electricitynode_investment.png)

![image](./pictures/fuelnode_investment.png) 



## Case Study A5 Example

### Introduction

#### Model assumptions

For each power station in the river, the following information is known:

- The capacity, or maximum electricity output. This datum also provides the maximum water discharge as per the efficiency curve (see next point).
- The efficiency curve, or conversion rate from water to electricity. In this study, a piece-wise linear efficiency with two segments is assumed. Moreover, this curve is monotonically decreasing, i.e., the efficiency in the first segment is strictly greater than the efficiency in the second segment.
- The maximum magazine level, or amount of water that can be stored in the reservoir.
- The magazine level at the beginning of the simulation period, and at the end.
- The minimum amount of water that the plant needs to discharge at every hour. This is usually zero (except for one of the plants).
- The minimum amount of water that needs to be spilled at every hour. Spilled water does not go through the turbine and thus does not serve to produce electricity; it just helps keeping the magazine level at bay.
- The downstream plant, or next plant in the river course.
- The time that it takes for the water to reach the downstream plant. This time can be different depending on whether the water is discharged (goes through the turbine) or spilled.
- The local inflow, or amount of water that naturally enters the reservoir at every hour. In this study, it is assumed constant over the entire simulation period.
- The hourly average water discharge. It is assumed that before the beginning of the simulation, this amount of water has constantly been discharged at every hour.

The system is operated so as to maximize total profit over the week, while respecting capacity constraints, maximum magazine level constrains, and so on. Hourly profit per plant is simply computed as the product of the electricity price and the production, minus a penalty for changes on the water discharge in two consecutive hours. This penalty is computed as the product of a constant penalty factor, common to all plants, and the absolute value of the difference in discharge with respect to the previous hour.

#### Modelling choices

The model of the electric system is fairly simple, only two elements are needed:

- A common electricity node.
- A load unit that takes electricity from that node.

On the contrary, the model of the river system is more detailed. Each power station in the river is modelled using the following elements:

- An upper water node, located at the entrance of the station.
- A lower water node, located at the exit of the station.
- A power plant unit, that discharges water from the upper node into the lower node, and feeds electricity produced in the process to the common electricity node.
- A spillway connection, that takes spilled water from the upper node and releases it to the downstream upper node.
- A discharge connection, that takes water from the lower node and releases it to the downstream upper node.

Below is a schematic of the model. For clarity, only the Rebnis station is presented in full detail:

![image](./pictures/case_study_a5_schematic.png)


### Guide

#### Set-up a workflow

Start by setting up a workflow as explained in the section **Setting up a workflow**.

#### Importing the database

The database for this example can directly be imported in the Spine DB editor.

First, download the file at this [link](https://github.com/Spine-project/SpineOpt.jl/blob/master/examples/case_study_A5/test_systemA5.sqlite).

Then, you can choose this file to be the input database of the model.

By opening the Spine DB editor, you should then get a screen similar to :

![image](./pictures/database_import.png)

To use SpineOpt in your project, you need to create a Tool specification for it. Click on the small arrow next to the Tool icon (put icon) (in the Main section of the tool bar), and press New… The Tool specification editor will popup: + picture!

![image](https://spine-toolbox.readthedocs.io/en/master/_images/edit_tool_specification_blank.png)

Type ‘SpineOpt’ as the name of the specification and select ‘Julia’ as the type. Unselect Execute in work directory.

Press file-regular next to Main program file to create a new Julia file. Enter a file name, e.g. ‘run_spineopt.jl’, and click Save.

Back in the Tool specification editor form, select the file you just created under Main program file. Then, enter the following text in the text editor to the right: +script
    At this point, the form should be looking similar to this: + picture
    ![image](https://spine-toolbox.readthedocs.io/en/master/_images/edit_tool_specification_spine_opt.png)
Ctrl+S to save everything, then close the Tool specification editor.


#### Setting up the project
Drag the Data Store icon ds_icon from the tool bar and drop it into the Design View. This will open the Add Data Store dialog. Type ‘input’ as the Data Store name and click Ok.

Repeat the above procedure to create a Data Store called ‘output’.

Create a database for the ‘input‘ Data Store:
  Select the input Data Store item in the Design View to show the Data Store Properties (on the right side of the window, usually).
  In Data Store Properties, select the sqlite dialect at the top, and hit New Spine db.

Repeat the above procedure to create a database for the ‘output’ Data Store.

Click on the small arrow next to the Tool icon (tool_icon) and drag the ‘SpineOpt’ item from the drop-down menu into the Design View. This will open the Add Tool dialog. Type ‘SpineOpt’ as the Tool name and click Ok.

Click on one of ‘input’ connectors and then on one of ‘SpineOpt’ connectors. This will create a connection from the former to the latter.

Repeat the procedure to create a connection from SpineOpt to output. It should look something like this: + picture

![image](https://spine-toolbox.readthedocs.io/en/master/_images/case_study_a5_item_connections.png)

Setup the arguments for the SpineOpt Tool:
    Select the SpineOpt Tool to show the Tool Properties (on the right side of the window, usually). You should see two elements listed under Available resources, {db_url@input} and {db_url@output}.
    Drag the first resource, {db_url@input}, and drop it in Command line arguments, just as shown in the image below. + picture
    ![image](https://spine-toolbox.readthedocs.io/en/master/_images/case_study_a5_spine_opt_tool_properties.png)
    Drag the second resource, {db_url@output}, and drop it right below the previous one. The panel should be now looking like this: + picture
    ![image](https://spine-toolbox.readthedocs.io/en/master/_images/case_study_a5_spine_opt_tool_properties_cmdline_args.png)
    Double-check that the order of the arguments is correct: first, {db_url@input}, and second, {db_url@output}. (You can drag and drop to reorganize them if needed.)

From the main menu, select File -> Save project.


#### Adding the database
You can add the database to the data structure by click on the icon, selecting the right type of database (In this case "sqlite") and then choosing the right file pressing the directory button as show in the picture. + picture

The database used in this example can be found on (link to the database repository) :

Question : I don't know if it's better to explain in detail how to create the database, as it's done in : [Case A5 example](https://spine-toolbox.readthedocs.io/en/master/case_study_a5.html#executing-the-workflow), or just say that we can get the already made database for the repo ?


#### Executing the workflow
Once the workflow is defined and input data is in place, the project is ready to be executed. Hit the Execute project button (logo) on the tool bar.

You should see ‘Executing All Directed Acyclic Graphs’ printed in the Event log (on the lower left by default). SpineOpt output messages will appear in the Process Log panel in the middle. After some processing, ‘DAG 1/1 completed successfully’ appears and the execution is complete.

#### Examining the Results
To examine the results, select the output data store and open the Spine DB editor.
![image](https://spine-toolbox.readthedocs.io/en/master/_images/case_study_a5_output.png)


If for example, the flow on the electricity load (i.e., the total electricity production in the system) is to be checked, go to Object tree, expand the unit object class, and select *electricity_load*, as illustrated in the picture above. Next, go to *Relationship parameter* value and double-click the first cell under value. The Parameter value editor will pop up. You should see something like this:

![image](https://spine-toolbox.readthedocs.io/en/master/_images/case_study_a5_output_electricity_load_unit_flow.png)


In the case the database wouldn't be available, you can create it yourself following the steps described down below.
Just pay attention that the format of the Time series may not be recognize by Spine Toolbox. If it's the case, either enter those data manually or aim for downloading the **.sqlite** file.

##### Importing the SpineOpt database template

- Download the SpineOpt database template (right click on the link, then select Save link as…)

- Select the input Data Store item in the Design View.

- Go to Data Store Properties and hit Open editor. This will open the newly created database in the Spine DB editor, looking similar to this:

![image](https://user-images.githubusercontent.com/40472544/115030082-5cf65b00-9ecf-11eb-84c3-9dc1c03d4627.png)

- Press Alt + F to display the main menu, select File -> Import…, and then select the template file you previously downloaded. The contents of that file will be imported into the current database, and you should then see classes like ‘commodity’, ‘connection’ and ‘model’ under the root node in the Object tree (on the left).

- From the main menu, select Session -> Commit. Enter ‘Import SpineOpt template’ as message in the popup dialog, and click Commit.

##### Creating objects

1. Add power plants to the model. Create objects of class unit as follows:

  - Select the list of plant names from the text-box below and copy it to the clipboard (Ctrl+C):
```
Rebnis_pwr_plant
Sadva_pwr_plant
Bergnäs_pwr_plant
Slagnäs_pwr_plant
Bastusel_pwr_plant
Grytfors_pwr_plant
Gallejaur_pwr_plant
Vargfors_pwr_plant
Rengård_pwr_plant
Båtfors_pwr_plant
Finnfors_pwr_plant
Granfors_pwr_plant
Krångfors_pwr_plant
Selsfors_pwr_plant
Kvistforsen_pwr_plant
```
  - Go to Object tree (on the top left of the window, usually), right-click on unit and select Add objects from the context menu. This will open the Add objects dialog.

  - Select the first cell under the object name column and press Ctrl+V. This will paste the list of plant names from the clipboard into that column; the object class name column will be filled automatically with ‘unit‘. The form should now be looking similar to this:
  ![image](https://spine-toolbox.readthedocs.io/en/master/_images/add_power_plant_units.png)

  - Click Ok.

  - Back in the Spine DB editor, under Object tree, double click on unit to confirm that the objects are effectively there.

  - Commit changes with the message ‘Add power plants’.

2. Add discharge and spillway connections. Create objects of class connection with the following names:
```
Rebnis_to_Bergnäs_disch
Sadva_to_Bergnäs_disch
Bergnäs_to_Slagnäs_disch
Slagnäs_to_Bastusel_disch
Bastusel_to_Grytfors_disch
Grytfors_to_Gallejaur_disch
Gallejaur_to_Vargfors_disch
Vargfors_to_Rengård_disch
Rengård_to_Båtfors_disch
Båtfors_to_Finnfors_disch
Finnfors_to_Granfors_disch
Granfors_to_Krångfors_disch
Krångfors_to_Selsfors_disch
Selsfors_to_Kvistforsen_disch
Kvistforsen_to_downstream_disch
Rebnis_to_Bergnäs_spill
Sadva_to_Bergnäs_spill
Bergnäs_to_Slagnäs_spill
Slagnäs_to_Bastusel_spill
Bastusel_to_Grytfors_spill
Grytfors_to_Gallejaur_spill
Gallejaur_to_Vargfors_spill
Vargfors_to_Rengård_spill
Rengård_to_Båtfors_spill
Båtfors_to_Finnfors_spill
Finnfors_to_Granfors_spill
Granfors_to_Krångfors_spill
Krångfors_to_Selsfors_spill
Selsfors_to_Kvistforsen_spill
Kvistforsen_to_downstream_spill
```
3. Add water nodes. Create objects of class node with the following names:
```
Rebnis_upper
Sadva_upper
Bergnäs_upper
Slagnäs_upper
Bastusel_upper
Grytfors_upper
Gallejaur_upper
Vargfors_upper
Rengård_upper
Båtfors_upper
Finnfors_upper
Granfors_upper
Krångfors_upper
Selsfors_upper
Kvistforsen_upper
Rebnis_lower
Sadva_lower
Bergnäs_lower
Slagnäs_lower
Bastusel_lower
Grytfors_lower
Gallejaur_lower
Vargfors_lower
Rengård_lower
Båtfors_lower
Finnfors_lower
Granfors_lower
Krångfors_lower
Selsfors_lower
Kvistforsen_lower
```
4. Next, create the following objects (all names in lower-case):

- `instance` of class `model`.
- `water` and `electricity` of class `commodity`.
- `electricity_node` of class `node`.
- `electricity_load` of class `unit`.
- `some_week` of class `temporal_block`.
- `deterministic` of class `stochastic_structure`.
- `realization` of class `stochastic_scenario`.

Finally, create the following objects to get results back from Spine Opt (again, all names in lower-case):

`my_report` of class `report`.

`unit_flow`, `connection_flow`, and `node_state` of class `output`.

> **_NOTE:_** To modify an object after you enter it, right click on it and select **Edit…** from the context menu.

##### Specifying object parameter values

1. Specify the general behaviour of our model. Enter model parameter values as follows:

    - Select the model parameter value data from the text-box below and copy it to the clipboard (**Ctrl+C**):
```
model	instance	duration_unit	Base	"hour"
model	instance	model_end	Base	{"type": "date_time", "data": "2019-01-08T00:00:00"}
model	instance	model_start	Base	{"type": "date_time", "data": "2019-01-01T00:00:00"}
```
    - Go to Object parameter value (on the top-center of the window, usually). Make sure that the columns in the table are ordered as follows:
```
object_class_name | object_name | parameter_name | alternative_name | value | database
```
    - Select the first empty cell under `object_class_name` and press **Ctrl+V**. This will paste the model parameter value data from the clipboard into the table. The form should be looking like this:
    ![image](https://spine-toolbox.readthedocs.io/en/latest/_images/case_study_a5_model_parameters.png)

2. Specify the resolution of our temporal block. Repeat the same procedure with the data below:
```
temporal_block	some_week	resolution	Base	{"type": "duration", "data": "1h"}
```

3. Specify the behaviour of all system nodes. Repeat the same procedure with the data below, where:

    - `demand` represents the local inflow (negative in most cases).
    - `fix_node_state` represents fixed reservoir levels (at the beginning and the end).
    - `has_state` indicates whether or not the node is a reservoir (true for all the upper nodes).
    - `state_coeff` is the reservoir ‘efficienty’ (always 1, meaning that there aren’t any loses).
    - `node_state_cap` is the maximum level of the reservoirs.

```
node	Bastusel_upper	demand	Base	-0.2579768519
node	Bergnäs_upper	demand	Base	-22.29
node	Båtfors_upper	demand	Base	-2
node	Finnfors_upper	demand	Base	0
node	Gallejaur_upper	demand	Base	15.356962963
node	Granfors_upper	demand	Base	0
node	Grytfors_upper	demand	Base	-3.78
node	Krångfors_upper	demand	Base	0
node	Kvistforsen_upper	demand	Base	-1.3273809524
node	Rebnis_upper	demand	Base	-3.68
node	Rengård_upper	demand	Base	-10.37
node	Sadva_upper	demand	Base	-5.43
node	Selsfors_upper	demand	Base	0
node	Slagnäs_upper	demand	Base	0
node	Vargfors_upper	demand	Base	-3.5584953704
node	Bastusel_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 5581.44, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 5417.28}}
node	Bergnäs_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 114543.6, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 105898.8}}
node	Båtfors_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 1117.2, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 891.1}}
node	Finnfors_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 234.0, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 234.0}}
node	Gallejaur_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 1224.0, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 2808.0}}
node	Granfors_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 232.4, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 212.8}}
node	Grytfors_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 1060.8, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 1110.72}}
node	Krångfors_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 201.3, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 207.9}}
node	Kvistforsen_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 769.066666704, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 560.0}}
node	Rebnis_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 70243.509200184, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 59524.122689676}}
node	Rengård_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 1022.0, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 770.0}}
node	Sadva_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 99057.7777728, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 93831.111108}}
node	Selsfors_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 40.0, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 200.0}}
node	Slagnäs_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 384.0, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 537.6}}
node	Vargfors_upper	fix_node_state	Base	{"type": "time_series", "data": {"2019-01-01T00:00:00": 3386.76, "2019-01-01T01:00:00": NaN, "2019-01-07T23:00:00": 3847.68}}
node	Bastusel_upper	has_state	Base	true
node	Bergnäs_upper	has_state	Base	true
node	Båtfors_upper	has_state	Base	true
node	Finnfors_upper	has_state	Base	true
node	Gallejaur_upper	has_state	Base	true
node	Granfors_upper	has_state	Base	true
node	Grytfors_upper	has_state	Base	true
node	Krångfors_upper	has_state	Base	true
node	Kvistforsen_upper	has_state	Base	true
node	Rebnis_upper	has_state	Base	true
node	Rengård_upper	has_state	Base	true
node	Sadva_upper	has_state	Base	true
node	Selsfors_upper	has_state	Base	true
node	Slagnäs_upper	has_state	Base	true
node	Vargfors_upper	has_state	Base	true
node	Bastusel_upper	state_coeff	Base	1
node	Bergnäs_upper	state_coeff	Base	1
node	Båtfors_upper	state_coeff	Base	1
node	Finnfors_upper	state_coeff	Base	1
node	Gallejaur_upper	state_coeff	Base	1
node	Granfors_upper	state_coeff	Base	1
node	Grytfors_upper	state_coeff	Base	1
node	Krångfors_upper	state_coeff	Base	1
node	Kvistforsen_upper	state_coeff	Base	1
node	Rebnis_upper	state_coeff	Base	1
node	Rengård_upper	state_coeff	Base	1
node	Sadva_upper	state_coeff	Base	1
node	Selsfors_upper	state_coeff	Base	1
node	Slagnäs_upper	state_coeff	Base	1
node	Vargfors_upper	state_coeff	Base	1
node	Bastusel_upper	node_state_cap	Base	8208
node	Bergnäs_upper	node_state_cap	Base	216120
node	Båtfors_upper	node_state_cap	Base	1330
node	Finnfors_upper	node_state_cap	Base	300
node	Gallejaur_upper	node_state_cap	Base	3600
node	Granfors_upper	node_state_cap	Base	280
node	Grytfors_upper	node_state_cap	Base	1248
node	Krångfors_upper	node_state_cap	Base	330
node	Kvistforsen_upper	node_state_cap	Base	1120
node	Rebnis_upper	node_state_cap	Base	205560
node	Rengård_upper	node_state_cap	Base	1400
node	Sadva_upper	node_state_cap	Base	168000
node	Selsfors_upper	node_state_cap	Base	500
node	Slagnäs_upper	node_state_cap	Base	768
node	Vargfors_upper	node_state_cap	Base	4008
```

##### Establishing relationships
> **_TIP:_** To enter the same text on several cells, copy the text into the clipboard, then select all target cells and press **Ctrl+V**.

1. Establish that (i) power plant units receive water from the station’s upper node, and (ii) the electricity load unit takes electricity from the common electricity node. Create relationships of class `unit__from_node` as follows:

    - Select the list of unit and node names from the text-box below and copy it to the clipboard (**Ctrl+C**).
```
Rebnis_pwr_plant	Rebnis_upper
Sadva_pwr_plant	Sadva_upper
Bergnäs_pwr_plant	Bergnäs_upper
Slagnäs_pwr_plant	Slagnäs_upper
Bastusel_pwr_plant	Bastusel_upper
Grytfors_pwr_plant	Grytfors_upper
Gallejaur_pwr_plant	Gallejaur_upper
Vargfors_pwr_plant	Vargfors_upper
Rengård_pwr_plant	Rengård_upper
Båtfors_pwr_plant	Båtfors_upper
Finnfors_pwr_plant	Finnfors_upper
Granfors_pwr_plant	Granfors_upper
Krångfors_pwr_plant	Krångfors_upper
Selsfors_pwr_plant	Selsfors_upper
Kvistforsen_pwr_plant	Kvistforsen_upper
electricity_load	electricity_node
```
    - Go to Relationship tree (on the bottom left of the window, usually), right-click on unit__from_node and select Add relationships from the context menu. This will open the Add relationships dialog.

    - Select the first cell under the unit column and press Ctrl+V. This will paste the list of plant and node names from the clipboard into the table. The form should be looking like this:
![image](https://spine-toolbox.readthedocs.io/en/latest/_images/add_pwr_plant_water_from_node.png)

    - Click Ok.

    - Back in the Spine DB editor, under Relationship tree, double click on unit__from_node to confirm that the relationships are effectively there.

    - From the main menu, select Session -> Commit to open the Commit changes dialog. Enter ‘Add from nodes of power plants‘ as the commit message and click Commit.

2. Establish that (i) power plant units release water to the station’s lower node, and (ii) power plant units inject electricity to the common electricity node. Repeate the above procedure to create relationships of class `unit__to_node` with the following data:
```
Rebnis_pwr_plant	Rebnis_lower
Sadva_pwr_plant	Sadva_lower
Bergnäs_pwr_plant	Bergnäs_lower
Slagnäs_pwr_plant	Slagnäs_lower
Bastusel_pwr_plant	Bastusel_lower
Grytfors_pwr_plant	Grytfors_lower
Gallejaur_pwr_plant	Gallejaur_lower
Vargfors_pwr_plant	Vargfors_lower
Rengård_pwr_plant	Rengård_lower
Båtfors_pwr_plant	Båtfors_lower
Finnfors_pwr_plant	Finnfors_lower
Granfors_pwr_plant	Granfors_lower
Krångfors_pwr_plant	Krångfors_lower
Selsfors_pwr_plant	Selsfors_lower
Kvistforsen_pwr_plant	Kvistforsen_lower
Rebnis_pwr_plant	electricity_node
Sadva_pwr_plant	electricity_node
Bergnäs_pwr_plant	electricity_node
Slagnäs_pwr_plant	electricity_node
Bastusel_pwr_plant	electricity_node
Grytfors_pwr_plant	electricity_node
Gallejaur_pwr_plant	electricity_node
Vargfors_pwr_plant	electricity_node
Rengård_pwr_plant	electricity_node
Båtfors_pwr_plant	electricity_node
Finnfors_pwr_plant	electricity_node
Granfors_pwr_plant	electricity_node
Krångfors_pwr_plant	electricity_node
Selsfors_pwr_plant	electricity_node
Kvistforsen_pwr_plant	electricity_node
```
> **_NOTE:_** At this point, you might be wondering what’s the purpose of the `unit__node__node relationship` class. Shouldn’t it be enough to have `unit__from_node` and `unit__to_node` to represent the topology of the system? The answer is yes; but in addition to topology, we also need to represent the conversion process that happens in the unit, where the water from one node is turned into electricty for another node. And for this purpose, we use a relationship `parameter value` on the `unit__node__node` relationships (see Specifying relationship parameter values).

3. Establish that (i) discharge connections take water from the lower node of the upstream station, and (ii) spillway connections take water from the upper node of the upstream station. Repeat the procedure to create relationships of class `connection__from_node` with the following data:
```
Bastusel_to_Grytfors_disch	Bastusel_lower
Bergnäs_to_Slagnäs_disch	Bergnäs_lower
Båtfors_to_Finnfors_disch	Båtfors_lower
Finnfors_to_Granfors_disch	Finnfors_lower
Gallejaur_to_Vargfors_disch	Gallejaur_lower
Granfors_to_Krångfors_disch	Granfors_lower
Grytfors_to_Gallejaur_disch	Grytfors_lower
Krångfors_to_Selsfors_disch	Krångfors_lower
Kvistforsen_to_downstream_disch	Kvistforsen_lower
Rebnis_to_Bergnäs_disch	Rebnis_lower
Rengård_to_Båtfors_disch	Rengård_lower
Sadva_to_Bergnäs_disch	Sadva_lower
Selsfors_to_Kvistforsen_disch	Selsfors_lower
Slagnäs_to_Bastusel_disch	Slagnäs_lower
Vargfors_to_Rengård_disch	Vargfors_lower
Bastusel_to_Grytfors_spill	Bastusel_upper
Bergnäs_to_Slagnäs_spill	Bergnäs_upper
Båtfors_to_Finnfors_spill	Båtfors_upper
Finnfors_to_Granfors_spill	Finnfors_upper
Gallejaur_to_Vargfors_spill	Gallejaur_upper
Granfors_to_Krångfors_spill	Granfors_upper
Grytfors_to_Gallejaur_spill	Grytfors_upper
Krångfors_to_Selsfors_spill	Krångfors_upper
Kvistforsen_to_downstream_spill	Kvistforsen_upper
Rebnis_to_Bergnäs_spill	Rebnis_upper
Rengård_to_Båtfors_spill	Rengård_upper
Sadva_to_Bergnäs_spill	Sadva_upper
Selsfors_to_Kvistforsen_spill	Selsfors_upper
Slagnäs_to_Bastusel_spill	Slagnäs_upper
Vargfors_to_Rengård_spill	Vargfors_upper
```
4. Establish that both discharge and spillway connections release water onto the upper node of the downstream station. Repeat the procedure to create `connection__to_node` relationships with the following data:
```
Bastusel_to_Grytfors_disch	Grytfors_upper
Bastusel_to_Grytfors_spill	Grytfors_upper
Bergnäs_to_Slagnäs_disch	Slagnäs_upper
Bergnäs_to_Slagnäs_spill	Slagnäs_upper
Båtfors_to_Finnfors_disch	Finnfors_upper
Båtfors_to_Finnfors_spill	Finnfors_upper
Finnfors_to_Granfors_disch	Granfors_upper
Finnfors_to_Granfors_spill	Granfors_upper
Gallejaur_to_Vargfors_disch	Vargfors_upper
Gallejaur_to_Vargfors_spill	Vargfors_upper
Granfors_to_Krångfors_disch	Krångfors_upper
Granfors_to_Krångfors_spill	Krångfors_upper
Grytfors_to_Gallejaur_disch	Gallejaur_upper
Grytfors_to_Gallejaur_spill	Gallejaur_upper
Krångfors_to_Selsfors_disch	Selsfors_upper
Krångfors_to_Selsfors_spill	Selsfors_upper
Rebnis_to_Bergnäs_disch	Bergnäs_upper
Rebnis_to_Bergnäs_spill	Bergnäs_upper
Rengård_to_Båtfors_disch	Båtfors_upper
Rengård_to_Båtfors_spill	Båtfors_upper
Sadva_to_Bergnäs_disch	Bergnäs_upper
Sadva_to_Bergnäs_spill	Bergnäs_upper
Selsfors_to_Kvistforsen_disch	Kvistforsen_upper
Selsfors_to_Kvistforsen_spill	Kvistforsen_upper
Slagnäs_to_Bastusel_disch	Bastusel_upper
Slagnäs_to_Bastusel_spill	Bastusel_upper
Vargfors_to_Rengård_disch	Rengård_upper
Vargfors_to_Rengård_spill	Rengård_upper
```
> **_NOTE:_** At this point, you might be wondering what’s the purpose of the `connection__node__node` relationship class. Shouldn’t it be enough to have `connection__from_node` and `connection__to_node` to represent the topology of the system? The answer is yes; but in addition to topology, we also need to represent the delay in the river branches. And for this purpose, we use a relationship parameter value on the `connection__node__node` relationships (see Specifying relationship parameter values).

5. Establish that water nodes balance water and the electricity node balances electricity. Repeat the procedure to create `node__commodity` relationships between all upper and lower reservoir nodes and the water commodity, as well as between the `electricity_node` and electricity.
```
Rebnis_upper	water
Sadva_upper	water
Bergnäs_upper	water
Slagnäs_upper	water
Bastusel_upper	water
Grytfors_upper	water
Gallejaur_upper	water
Vargfors_upper	water
Rengård_upper	water
Båtfors_upper	water
Finnfors_upper	water
Granfors_upper	water
Krångfors_upper	water
Selsfors_upper	water
Kvistforsen_upper	water
Rebnis_lower	water
Sadva_lower	water
Bergnäs_lower	water
Slagnäs_lower	water
Bastusel_lower	water
Grytfors_lower	water
Gallejaur_lower	water
Vargfors_lower	water
Rengård_lower	water
Båtfors_lower	water
Finnfors_lower	water
Granfors_lower	water
Krångfors_lower	water
Selsfors_lower	water
Kvistforsen_lower	water
electricity_node	electricity
```

6. Establish that all nodes are balanced at each time slice in the one week horizon. Create relationships of class `model__default_temporal_block` between the model instance and the `temporal_block` `some_week`.

7. Establish that this model is deterministic. Create a relationships of class `model__default_stochastic_structure` between the model instance and deterministic, and a relationship of class `stochastic_structure__stochastic_scenario` between deterministic and realization.

8. Finally, create one relationship of class `report__output` between `my_report` and each of the following output objects: `unit_flow`, `connection_flow`, and `node_state`, as well as one relationship of `class model__report` between instance and `my_report`. This is so results from running Spine Opt are written to the ouput database.

##### Specifying relationship parameter values

1. Specify (i) the capacity of hydro power plants, and (ii) the variable operating cost of the electricity unit (equal to the negative electricity price). Enter `unit__from_node parameter` values as follows:

    - Select the parameter value data from the text-box below and copy it to the clipboard (**Ctrl+C**):
```
unit__from_node	Bastusel_pwr_plant,Bastusel_upper	unit_capacity	Base	127.5
unit__from_node	Bergnäs_pwr_plant,Bergnäs_upper	unit_capacity	Base	120
unit__from_node	Båtfors_pwr_plant,Båtfors_upper	unit_capacity	Base	210
unit__from_node	Finnfors_pwr_plant,Finnfors_upper	unit_capacity	Base	176.25
unit__from_node	Gallejaur_pwr_plant,Gallejaur_upper	unit_capacity	Base	228.75
unit__from_node	Granfors_pwr_plant,Granfors_upper	unit_capacity	Base	180
unit__from_node	Grytfors_pwr_plant,Grytfors_upper	unit_capacity	Base	123.75
unit__from_node	Krångfors_pwr_plant,Krångfors_upper	unit_capacity	Base	180
unit__from_node	Kvistforsen_pwr_plant,Kvistforsen_upper	minimum_operating_point	Base	0.0888888888889
unit__from_node	Kvistforsen_pwr_plant,Kvistforsen_upper	unit_capacity	Base	225
unit__from_node	Rebnis_pwr_plant,Rebnis_upper	unit_capacity	Base	60
unit__from_node	Rengård_pwr_plant,Rengård_upper	unit_capacity	Base	165
unit__from_node	Sadva_pwr_plant,Sadva_upper	unit_capacity	Base	52.5
unit__from_node	Selsfors_pwr_plant,Selsfors_upper	unit_capacity	Base	225
unit__from_node	Slagnäs_pwr_plant,Slagnäs_upper	unit_capacity	Base	120
unit__from_node	Vargfors_pwr_plant,Vargfors_upper	unit_capacity	Base	232.5
unit__from_node	electricity_load,electricity_node	vom_cost	Base	{"type": "time_series", "index": {"start": "2019-01-01 00:00:00", "resolution": "1h", "ignore_year": false, "repeat": false}, "data": [-162.03, -156.36, -151.06, -153.52, -158.91, -164.02, -175.56, -283.11, -278.76, -299.57, -285.28, -207.34, -194.95, -190.41, -185.4, -183.41, -191.54, -202.9, -197.69, -195.33, -186.72, -178.87, -174.71, -168.75, -172.89, -172.13, -171.66, -173.27, -176.97, -179.63, -226.41, -271.96, -399.3, -402.53, -353.28, -330.79, -294.54, -271.29, -248.71, -226.79, -240.93, -374.44, -255.54, -210.47, -186.65, -178.21, -173.18, -166.44, -165.09, -162.91, -161.11, -162.53, -166.04, -169.16, -174.28, -185.37, -195.79, -189.92, -187.74, -181.96, -179.12, -178.36, -177.13, -177.03, -177.69, -184.8, -187.27, -179.49, -175.23, -172.67, -169.07, -165.37, -170.06, -171.48, -171.58, -174.14, -180.3, -185.89, -195.37, -328.65, -365.91, -315.0, -242.68, -230.73, -225.33, -225.8, -213.38, -207.32, -215.37, -243.81, -243.53, -215.56, -192.05, -187.88, -181.15, -172.15, -174.16, -171.05, -170.77, -174.82, -179.62, -178.87, -191.49, -229.64, -336.07, -242.07, -228.5, -201.85, -196.67, -192.34, -190.36, -187.44, -186.68, -190.26, -191.21, -187.53, -179.34, -171.9, -166.53, -160.59, -166.08, -157.74, -145.36, -145.64, -147.42, -149.77, -153.33, -141.33, -145.08, -150.52, -153.42, -159.43, -159.05, -149.49, -147.89, -150.52, -157.08, -172.37, -174.06, -171.15, -160.46, -147.8, -141.61, -134.39, -144.41, -140.19, -138.59, -140.0, -139.53, -140.28, -144.03, -146.57, -149.39, -156.24, -157.93, -156.43, -155.21, -149.86, -148.07, -147.13, -148.82, -162.53, -174.74, -170.89, -163.94, -157.93, -150.7, -143.94]}
```    
    - Go to Relationship parameter value (on the bottom-center of the window, usually). Make sure that the columns in the table are ordered as follows:
```
relationship_class_name | object_name_list | parameter_name | alternative_name | value | database
```
    - Select the first empty cell under `relationship_class_name` and press **Ctrl+V**. This will paste the parameter value data from the clipboard into the table.

2. Specify the conversion ratio from water to electricity and from water to water of different hydro power plants (the latter being equal to 1). Repeat the same procedure with the data below:
```
unit__node__node	Bastusel_pwr_plant,electricity_node,Bastusel_upper	fix_ratio_out_in_unit_flow	Base	0.577810871184
unit__node__node	Bergnäs_pwr_plant,electricity_node,Bergnäs_upper	fix_ratio_out_in_unit_flow	Base	0.0506329113924
unit__node__node	Båtfors_pwr_plant,electricity_node,Båtfors_upper	fix_ratio_out_in_unit_flow	Base	0.148282097649
unit__node__node	Finnfors_pwr_plant,electricity_node,Finnfors_upper	fix_ratio_out_in_unit_flow	Base	0.180985725828
unit__node__node	Gallejaur_pwr_plant,electricity_node,Gallejaur_upper	fix_ratio_out_in_unit_flow	Base	0.730442000415
unit__node__node	Granfors_pwr_plant,electricity_node,Granfors_upper	fix_ratio_out_in_unit_flow	Base	0.164556962025
unit__node__node	Grytfors_pwr_plant,electricity_node,Grytfors_upper	fix_ratio_out_in_unit_flow	Base	0.190257000384
unit__node__node	Krångfors_pwr_plant,electricity_node,Krångfors_upper	fix_ratio_out_in_unit_flow	Base	0.274261603376
unit__node__node	Kvistforsen_pwr_plant,electricity_node,Kvistforsen_upper	fix_ratio_out_in_unit_flow	Base	0.472573839662
unit__node__node	Rebnis_pwr_plant,electricity_node,Rebnis_upper	fix_ratio_out_in_unit_flow	Base	0.810126582278
unit__node__node	Rengård_pwr_plant,electricity_node,Rengård_upper	fix_ratio_out_in_unit_flow	Base	0.165707710012
unit__node__node	Sadva_pwr_plant,electricity_node,Sadva_upper	fix_ratio_out_in_unit_flow	Base	0.448462929476
unit__node__node	Selsfors_pwr_plant,electricity_node,Selsfors_upper	fix_ratio_out_in_unit_flow	Base	0.209282700422
unit__node__node	Slagnäs_pwr_plant,electricity_node,Slagnäs_upper	fix_ratio_out_in_unit_flow	Base	0.0443037974684
unit__node__node	Vargfors_pwr_plant,electricity_node,Vargfors_upper	fix_ratio_out_in_unit_flow	Base	0.34299714169
unit__node__node	Bastusel_pwr_plant,Bastusel_lower,Bastusel_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Bergnäs_pwr_plant,Bergnäs_lower,Bergnäs_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Båtfors_pwr_plant,Båtfors_lower,Båtfors_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Finnfors_pwr_plant,Finnfors_lower,Finnfors_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Gallejaur_pwr_plant,Gallejaur_lower,Gallejaur_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Granfors_pwr_plant,Granfors_lower,Granfors_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Grytfors_pwr_plant,Grytfors_lower,Grytfors_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Krångfors_pwr_plant,Krångfors_lower,Krångfors_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Kvistforsen_pwr_plant,Kvistforsen_lower,Kvistforsen_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Rebnis_pwr_plant,Rebnis_lower,Rebnis_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Rengård_pwr_plant,Rengård_lower,Rengård_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Sadva_pwr_plant,Sadva_lower,Sadva_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Selsfors_pwr_plant,Selsfors_lower,Selsfors_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Slagnäs_pwr_plant,Slagnäs_lower,Slagnäs_upper	fix_ratio_out_in_unit_flow	Base	1
unit__node__node	Vargfors_pwr_plant,Vargfors_lower,Vargfors_upper	fix_ratio_out_in_unit_flow	Base	1
```

3. specify the average discharge and spillage in the first hours of the simulation. Repeat the same procedure with the data below:
```
connection__from_node	Bastusel_to_Grytfors_disch,Bastusel_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [110.7, 110.7]}
connection__from_node	Bergnäs_to_Slagnäs_disch,Bergnäs_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [105.0, 105.0]}
connection__from_node	Båtfors_to_Finnfors_disch,Båtfors_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [150.2, 150.2]}
connection__from_node	Finnfors_to_Granfors_disch,Finnfors_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [155.3, 155.3]}
connection__from_node	Gallejaur_to_Vargfors_disch,Gallejaur_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [118.2, 118.2]}
connection__from_node	Granfors_to_Krångfors_disch,Granfors_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [155.6, 155.6]}
connection__from_node	Grytfors_to_Gallejaur_disch,Grytfors_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [117.2, 117.2]}
connection__from_node	Krångfors_to_Selsfors_disch,Krångfors_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [156.0, 156.0]}
connection__from_node	Kvistforsen_to_downstream_disch,Kvistforsen_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [158.5, 158.5]}
connection__from_node	Rebnis_to_Bergnäs_disch,Rebnis_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [21.5, 21.5]}
connection__from_node	Rengård_to_Båtfors_disch,Rengård_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [141.5, 141.5]}
connection__from_node	Sadva_to_Bergnäs_disch,Sadva_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [34.6, 34.6]}
connection__from_node	Selsfors_to_Kvistforsen_disch,Selsfors_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [158.4, 158.4]}
connection__from_node	Slagnäs_to_Bastusel_disch,Slagnäs_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [106.6, 106.6]}
connection__from_node	Vargfors_to_Rengård_disch,Vargfors_lower	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [119.6, 119.6]}
connection__from_node	Bastusel_to_Grytfors_spill,Bastusel_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Bergnäs_to_Slagnäs_spill,Bergnäs_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Båtfors_to_Finnfors_spill,Båtfors_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Finnfors_to_Granfors_spill,Finnfors_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Gallejaur_to_Vargfors_spill,Gallejaur_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Granfors_to_Krångfors_spill,Granfors_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Grytfors_to_Gallejaur_spill,Grytfors_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Krångfors_to_Selsfors_spill,Krångfors_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Kvistforsen_to_downstream_spill,Kvistforsen_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Rebnis_to_Bergnäs_spill,Rebnis_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Rengård_to_Båtfors_spill,Rengård_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Sadva_to_Bergnäs_spill,Sadva_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Selsfors_to_Kvistforsen_spill,Selsfors_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Slagnäs_to_Bastusel_spill,Slagnäs_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
connection__from_node	Vargfors_to_Rengård_spill,Vargfors_upper	fix_connection_flow	Base	{"type": "time_series", "index": {"start": "2018-12-30 00:00:00", "resolution": "2D"}, "data": [0.0, 0.0]}
```

4. Finally, specify the delay and transfer ratio of different water connections (the latter being equal to 1). Repeat the same procedure with the data below:
```
connection__node__node	Bastusel_to_Grytfors_disch,Grytfors_upper,Bastusel_lower	connection_flow_delay	Base	{"type": "duration", "data": "1h"}
connection__node__node	Bastusel_to_Grytfors_spill,Grytfors_upper,Bastusel_upper	connection_flow_delay	Base	{"type": "duration", "data": "150m"}
connection__node__node	Bergnäs_to_Slagnäs_disch,Slagnäs_upper,Bergnäs_lower	connection_flow_delay	Base	{"type": "duration", "data": "1h"}
connection__node__node	Bergnäs_to_Slagnäs_spill,Slagnäs_upper,Bergnäs_upper	connection_flow_delay	Base	{"type": "duration", "data": "1h"}
connection__node__node	Båtfors_to_Finnfors_disch,Finnfors_upper,Båtfors_lower	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Båtfors_to_Finnfors_spill,Finnfors_upper,Båtfors_upper	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Finnfors_to_Granfors_disch,Granfors_upper,Finnfors_lower	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Finnfors_to_Granfors_spill,Granfors_upper,Finnfors_upper	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Gallejaur_to_Vargfors_disch,Vargfors_upper,Gallejaur_lower	connection_flow_delay	Base	{"type": "duration", "data": "30m"}
connection__node__node	Gallejaur_to_Vargfors_spill,Vargfors_upper,Gallejaur_upper	connection_flow_delay	Base	{"type": "duration", "data": "150m"}
connection__node__node	Granfors_to_Krångfors_disch,Krångfors_upper,Granfors_lower	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Granfors_to_Krångfors_spill,Krångfors_upper,Granfors_upper	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Grytfors_to_Gallejaur_disch,Gallejaur_upper,Grytfors_lower	connection_flow_delay	Base	{"type": "duration", "data": "15m"}
connection__node__node	Grytfors_to_Gallejaur_spill,Gallejaur_upper,Grytfors_upper	connection_flow_delay	Base	{"type": "duration", "data": "15m"}
connection__node__node	Krångfors_to_Selsfors_disch,Selsfors_upper,Krångfors_lower	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Krångfors_to_Selsfors_spill,Selsfors_upper,Krångfors_upper	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Rebnis_to_Bergnäs_disch,Bergnäs_upper,Rebnis_lower	connection_flow_delay	Base	{"type": "duration", "data": "2D"}
connection__node__node	Rebnis_to_Bergnäs_spill,Bergnäs_upper,Rebnis_upper	connection_flow_delay	Base	{"type": "duration", "data": "2D"}
connection__node__node	Rengård_to_Båtfors_disch,Båtfors_upper,Rengård_lower	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Rengård_to_Båtfors_spill,Båtfors_upper,Rengård_upper	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Sadva_to_Bergnäs_disch,Bergnäs_upper,Sadva_lower	connection_flow_delay	Base	{"type": "duration", "data": "2D"}
connection__node__node	Sadva_to_Bergnäs_spill,Bergnäs_upper,Sadva_upper	connection_flow_delay	Base	{"type": "duration", "data": "2D"}
connection__node__node	Selsfors_to_Kvistforsen_disch,Kvistforsen_upper,Selsfors_lower	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Selsfors_to_Kvistforsen_spill,Kvistforsen_upper,Selsfors_upper	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Slagnäs_to_Bastusel_disch,Bastusel_upper,Slagnäs_lower	connection_flow_delay	Base	{"type": "duration", "data": "4h"}
connection__node__node	Slagnäs_to_Bastusel_spill,Bastusel_upper,Slagnäs_upper	connection_flow_delay	Base	{"type": "duration", "data": "4h"}
connection__node__node	Vargfors_to_Rengård_disch,Rengård_upper,Vargfors_lower	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Vargfors_to_Rengård_spill,Rengård_upper,Vargfors_upper	connection_flow_delay	Base	{"type": "duration", "data": "3h"}
connection__node__node	Bastusel_to_Grytfors_disch,Grytfors_upper,Bastusel_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Bastusel_to_Grytfors_spill,Grytfors_upper,Bastusel_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Bergnäs_to_Slagnäs_disch,Slagnäs_upper,Bergnäs_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Bergnäs_to_Slagnäs_spill,Slagnäs_upper,Bergnäs_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Båtfors_to_Finnfors_disch,Finnfors_upper,Båtfors_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Båtfors_to_Finnfors_spill,Finnfors_upper,Båtfors_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Finnfors_to_Granfors_disch,Granfors_upper,Finnfors_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Finnfors_to_Granfors_spill,Granfors_upper,Finnfors_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Gallejaur_to_Vargfors_disch,Vargfors_upper,Gallejaur_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Gallejaur_to_Vargfors_spill,Vargfors_upper,Gallejaur_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Granfors_to_Krångfors_disch,Krångfors_upper,Granfors_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Granfors_to_Krångfors_spill,Krångfors_upper,Granfors_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Grytfors_to_Gallejaur_disch,Gallejaur_upper,Grytfors_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Grytfors_to_Gallejaur_spill,Gallejaur_upper,Grytfors_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Krångfors_to_Selsfors_disch,Selsfors_upper,Krångfors_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Krångfors_to_Selsfors_spill,Selsfors_upper,Krångfors_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Rebnis_to_Bergnäs_disch,Bergnäs_upper,Rebnis_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Rebnis_to_Bergnäs_spill,Bergnäs_upper,Rebnis_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Rengård_to_Båtfors_disch,Båtfors_upper,Rengård_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Rengård_to_Båtfors_spill,Båtfors_upper,Rengård_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Sadva_to_Bergnäs_disch,Bergnäs_upper,Sadva_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Sadva_to_Bergnäs_spill,Bergnäs_upper,Sadva_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Selsfors_to_Kvistforsen_disch,Kvistforsen_upper,Selsfors_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Selsfors_to_Kvistforsen_spill,Kvistforsen_upper,Selsfors_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Slagnäs_to_Bastusel_disch,Bastusel_upper,Slagnäs_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Slagnäs_to_Bastusel_spill,Bastusel_upper,Slagnäs_upper	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Vargfors_to_Rengård_disch,Rengård_upper,Vargfors_lower	fix_ratio_out_in_connection_flow	Base	1
connection__node__node	Vargfors_to_Rengård_spill,Rengård_upper,Vargfors_upper	fix_ratio_out_in_connection_flow	Base	1
```

5. When you’re ready, commit all changes to the database.

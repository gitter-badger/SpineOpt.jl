# Spine DB Editor

## Getting started

### Launching the editor

To open a single database in Spine database editor:

- Create a *Data Store* project item.
- Select the *Data Store*.
- Enter the url of the database in *Data Store Properties*.
- Press the **Open editor** button in *Data Store Properties*.

To open multiple databases in Spine database editor:

- Repeat steps 1 to 3 above for each database.
- Create a *View* project item.
- Connect each *Data Store* item to the *View* item.
- Select the *View* item.
- Press **Open editor** in *View Properties*.

### User interface

The form has the following main UI components:

**Entity trees** (*Object tree* and *Relationship tree*): they present the structure of classes and entities in all databases in the shape of a tree.

**Stacked tables** (*Object parameter value*, *Object parameter definition*, *Relationship parameter value*, and *Relationship parameter definition*): they present object and relationship parameter data in the form of stacked tables.

**Pivot table and Frozen table**: they present data for a given class in the form of a pivot table, optionally with frozen dimensions.

**Entity graph**: it presents the structure of classes and entities in the shape of a graph.

**Tool/Feature tree**: it presents tools, features, and methods defined in the databases.

**Parameter value list**: it presents parameter value lists available in the databases.

**Alternative/Scenario tree**: it presents scenarios and alternatives defined in the databases.

**Parameter tag**: it presents parameter tags defined in the databases.

>**Tip** : You can customize the UI from the View and Pivot sections in the hamburger menu.

## Viewing the data

This section describes the available tools to view data.

### Viewing entities and classes

#### Using *Entity trees*

*Entity trees* present the structure of classes and entities in all databases in the shape of a tree:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/object_tree.png)

In *Object tree*:

- To view all object classes from all databases -> expand the root item (automatically expanded when loading the form).
- To view all objects of a class-> expand the corresponding object class item.
- To view all relationship classes involving an object class -> expand any objects of that class.
- To view all relationships of a class involving a given object -> expand the corresponding relationship class item under the corresponding object item.

In *Relationship tree*:

- To view all relationship classes from all databases -> expand the root item (automatically expanded when loading the form).
- To view all relationships of a class -> expand the corresponding relationship class item.

> **Note** To expand an item in *Object tree* or *Relationship tree*, double-click on the item or press the right arrow while it’s active. Items in gray don’t have any children, thus they cannot be expanded. To collapse an expanded item, double-click on it again or press the left arrow while it’s active.

> **Tip** To expand or collapse an item and all its descentants in *Object tree* or *Relationship tree*, right click on the item to display the context menu, and select **Fully expand** or **Fully collapse**.

> **Tip** In *Object tree*, the same relationship appears in many places (as many as it has dimensions). To jump to the next ocurrence of a relationship item, either double-click on the item, or right-click on it to display the context menu, and select **Find next**.

#### Using *Entity graph*

*Entity graph* presents the structure of classes and entities from one database in the shape of a graph :

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/entity_graph.png)

> **Tip** To see it in action, check out [this video](https://youtu.be/pSdl9fogNaE)

##### Building the graph

- To build the graph -> select any number of items in either *Object tree* or *Relationship tree*. What is included in the graph depends on the specific selection you make:
- To include all objects and relationships from the database -> select the root item in either *Object tree* or *Relationship tree*.
- To include all objects of a class -> select the corresponding class item in *Object tree*.
- To include all relationships of a class -> select the corresponding class item in *Relationship tree*.
- To include all relationships of a specific class involving a specific object -> select the corresponding relationship class item under the corresponding object item in *Object tree*.
- To include specific objects or relationships -> select the corresponding item in either *Object tree* or *Relationship tree*.

> **Note** In *Entity graph*, a small unnamed vertex represents a relationship, whereas a bigger named vertex represents an object. An arc between a relationship and an object indicates that the object is a member in that relationship.

The graph automatically includes relationships whenever all the member objects are included (even if these relationships are not selected in *Object tree* or *Relationship tree*). You can change this behavior to automatically include relationships whenever any of the member objects are included. To do this, enable **Auto-expand objects** via the **Graph** menu, or via *Entity graph*’s context menu.

> **Tip** To extend the selection in *Object tree* or *Relationship tree*, press and hold the **Ctrl** key while clicking on the items.

> **Tip** *Object tree* and *Relationship tree* also support **Sticky selection**, which allows one to extend the selection by clicking on items without pressing Ctrl. To enable **Sticky selection**, select **Settings** from the hamburger menu, and check the corresponding box.

#### Manipulating the graph

You can move items in the graph by dragging them with your mouse. By default, each items moves individually. To make relationship items move along with their member objects, select **Settings** from the hamburger menu and check the box next to, *Move relationships along with objects in Entity graph*.
- To display *Entity graph*’s context menu, just right-click on an empty space in the graph.
- To save the position of items into the database, select the items in the graph and choose **Save positions** from the context menu. To clear saved positions, select the items again and choose **Clear saved positions** from the context menu.
- To hide part of the graph, select the items you want to hide and choose **Hide** from context menu. To show the hidden items again, select **Show hidden** from the context menu.
- To prune the graph, select the items you want to prune and then choose **Prune entities** or **Prune classes** from the context menu. To restore specific prunned items, display the context menu, hover **Restore** and select the items you want to restore from the popup menu. To restore all prunned items at once, select **Restore all** from the context menu.
- To zoom in and out, scroll your mouse wheel over *Entity graph* or use **Zoom** buttons in the context menu.
- To rotate clockwise or anti-clockwise, press and hold the **Shift** key while scrolling your mouse wheel, or use the **Rotate** buttons in the context menu.
- To adjust the arcs’ lenght, use the **Arc length** buttons in the context menu.
- To rebuild the graph after moving items around, select **Rebuild graph** from the context menu.
- To export the current graph as a PDF file, select **Export graph as PDF** from the context menu.

> **Note** : *Entity graph* supports extended selection and rubber-band selection. To extend a selection, press and hold **Ctrl** while clicking on the items. To perform rubber-band selection, press and hold **Ctrl** while dragging your mouse around the items you want to select.

> **Note** : Prunned items are remembered across graph builds.

To display an object or relationship item’s context menu, just right-click on it.

To expand or collapse relationships for an object item, hover **Expand** or **Collapse** and select the relationship class from the popup menu.


###  Viewing parameter definitions and values

#### Using *Stacked tables*

*Stacked tables* present object and relationship parameter data from all databases in the form of stacked tables:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/object_parameter_value_table.png)

- To filter Stacked tables by any entities and/or classes -> select the corresponding items in either Object tree, Relationship tree, or Entity graph. To remove all these filters, select the root item in either Object tree or Relationship tree.
- To filter parameter definitions and values by certain parameter tags -> select those tags in Parameter tag toolbar.
- To apply a custom filter on a Stacked table, click on any horizontal header. A menu will pop up listing the items in the corresponding column:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/object_name_filter_menu.png)

Uncheck the items you don’t want to see in the table and press **Ok**. Additionally, you can type in the search bar at the top of the menu to filter the list of items. To remove the current filter, select **Remove filters**.

To filter a *Stacked table* according to a selection of items in the table itself, right-click on the selection to show the context menu, and then select **Filter by** or **Filter excluding**. To remove these filters, select **Remove filters** from the header menus of the filtered columns.

> **Tip** : You can rearrange columns in *Stacked tables* by dragging the headers with your mouse. The ordering will be remembered the next time you open Spine DB editor.

### Viewing parameter values and relationships

#### Using *Pivot table* and *Frozen table*

*Pivot table* and *Frozen table* present data for an individual class from one database in the form of a pivot table, optionally with frozen dimensions:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/pivot_table.png)

To populate the tables with data for a certain class, just select the corresponding class item in either *Object tree* or *Relationship tree*.

#### Selecting the input type

*Pivot table* and *Frozen table* support four different input types:

**Parameter value** (the default): it shows objects, parameter definitions, alternatives, and databases in the headers, and corresponding parameter values in the table body.

**Index expansion**: Similar to the above, but it also shows parameter indexes in the headers. Indexes are extracted from special parameter values, such as time-series.

**Relationship**: it shows objects, and databases in the headers, and corresponding relationships in the table body. It only works when selecting a relationship class in *Relationship tree*.

**Scenario**: it shows scenarios, alternatives, and databases in the header, and corresponding rank in the table body.

You can select the input type from the **Pivot** section in the hamburger menu.

> **Note** : In *Pivot table*, header blocks in the top-left area indicate what is shown in each horizontal and vertical header. For example, in **Parameter value** input type, by default, the horizontal header has two rows, listing alternative and parameter names, respectively; whereas the vertical header has one or more columns listing object names.

#### Pivoting and freezing

- To pivot the data, drag a header block across the top-left area of the table. You can turn a horizontal header into a vertical header and viceversa, as well as rearrange headers vertically or horizontally.
- To freeze a dimension, drag the corresponding header block from *Pivot table* into *Frozen table*. To unfreeze a frozen dimension, just do the opposite.

> **Note** : Your pivoting and freezing selections for any class will be remembered when switching to another class.

#### Filtering

To apply a custom filter on *Pivot table*, click on the arrow next to the name of any header block. A menu will pop up listing the items in the corresponding row or column:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/object_name_filter_menu.png)

Uncheck the items you don’t want to see in the table and press **Ok**. Additionally, you can type in the search bar at the top of the menu to filter the list of items. To remove the current filter, select **Remove filters**.

To filter the pivot table by an individual vector across the frozen dimensions, select the corresponding row in *Frozen table*.

### Viewing alternatives and scenarios

You can find alternatives and scenarios from all databases under *Alternative/Scenario tree*:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/alternative_scenario_tree.png)

To view the alternatives and scenarios from each database, expand the root item for that database. To view all alternatives, expand the **alternative** item. To view all scenarios, expand the **scenario** item. To view the alternatives for a particular scenario, expand the **scenario_alternative** item under the corresponding scenario item.

### Viewing tools and Features

You can find tools, features, and methods from all databases under *Tool/Feature tree*:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/tool_feature_tree.png)

To view the features and tools from each database, expand the root item for that database. To view all features, expand the **feature** item. To view all tools, expand the **tool** item. To view the features for a particular tool, expand the **tool_feature** item under the corresponding tool item. To view the methods for a particular tool-feature, expand the **tool_feature_method** item under the corresponding tool-feature item.

### Viewing parameter value lists

You can find parameter value lists from all databases under *Parameter value list*:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/parameter_value_list.png)

To view the parameter value lists from each database, expand the root item for that database. To view the values for each list, expand the corresponding list item.

### Viewing parameter tags

You can find parameter tags from all databases under Parameter tag:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/parameter_tag.png)

To view the tags from each database, expand the root item for that database.


## Plotting data

Basic data visualization is available in the Spine database editors. Currently, it is possible to plot scalar values as well as time series, arrays and one dimensional maps with some limitations.

To plot a column, select the values from a table and then *Plot* from the **right click** popup menu.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/plotting_popup_menu.png)

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/plotting_window_single_column.png)

Selecting data in multiple columns plots the selection in a single window.

To add a plot to an existing window select the target plot window from the Plot in *window* submenu.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/plotting_popup_menu_plot_in_window.png)

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/plotting_window_added_plot.png)

### *X* column in *Pivot table*

It is possible to plot a column of scalar values against a designated *X* column in the *Pivot table*.

To set a column as the *X* column right click the top empty area above the column header and select Use as *X* from the popup menu. (*X*) in the topmost cell indicates that the column is designated as the *X* axis.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/plotting_use_as_x_popup.png)

When selecting and plotting other columns in the same table the data will be plotted against the values in the *X* column instead of row numbers.



## Adding data

This section describes the available tools to add new data.

### Adding object classes

#### From *Object tree*

Right-click on the root item in *Object tree* to display the context menu, and select **Add object classes**.

The *Add object classes* dialog will pop up:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/add_object_classes_dialog.png)

Enter the names of the classes you want to add under the *object class name* column. Optionally, you can enter a description for each class under the *description* column. To select icons for your classes, double click on the corresponding cell under the *display icon* column. Finally, select the databases where you want to add the classes under *databases*. When you’re ready, press **Ok**.

### Adding objects

#### From *Object tree* or *Entity graph*

Right-click on an object class item in *Object tree*, or on an empty space in the *Entity graph*, and select **Add objects** from the context menu.

The *Add objects* dialog will pop up:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/add_objects_dialog.png)

Enter the names of the object classes under object class name, and the names of the objects under *object name*. To display a list of available classes, start typing or double click on any cell under the *object class name* column. Optionally, you can enter a description for each object under the description column. Finally, select the databases where you want to add the objects under *databases*. When you’re ready, press **Ok**.

#### From *Pivot* table

To add an object to a specific class, bring the class to *Pivot table* using any input type (see **Using Pivot table and Frozen table**). Then, enter the object name in the last cell of the header corresponding to that class.

#### Duplicating objects

To duplicate an existing object with all its relationships and parameter values, right-click over the corresponding object item in Object tree to display the context menu, and select **Duplicate object**. Enter a name for the duplicate and press **Ok**.

### Adding object groups

Right-click on an object class item in Object tree, and select **Add object group** from the context menu.

The *Add object group* dialog will pop up:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/add_object_group_dialog.png)

Enter the name of the group, adn select the database where you want the group to be created. Select the member objects under *Non members*, and press the button in the middle that has a plus sign. Multiple selection works.

When you’re happy with your selections, press **Ok** to add the group to the database.

### Adding relationship classes

#### From *Object tree* or *Relationship tree*

Right-click on an object class item in *Object tree*, or on the root item in *Relationship tree*, and select **Add relationship classes** from the context menu.

The *Add relationship classes* dialog will pop up:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/add_relationship_classes_dialog.png)

Select the number of dimensions using the spinbox at the top; then, enter the names of the object classes for each dimension under each *object class name* column, and the names of the relationship classes under *relationship class name*. To display a list of available object classes, start typing or double click on any cell under the *object class name* columns. Optionally, you can enter a description for each relationship class under the *description* column. Finally, select the databases where you want to add the relationship classes under *databases*. When you’re ready, press **Ok**.

### Adding relationships

#### From *Object tree* or *Relationship tree*

Right-click on a relationship class item either in Object tree or *Relationship tree*, and select **Add relationships** from the context menu.

The *Add relationships* dialog will pop up:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/add_relationships_dialog.png)

Select the relationship class from the combo box at the top; then, enter the names of the objects for each member object class under the corresponding column, and the name of the relationship under *relationship name*. To display a list of available objects for a member class, start typing or double click on any cell under that class’s column. Finally, select the databases where you want to add the relationships under *databases*. When you’re ready, press **Ok**.

#### From *Pivot table*

To add a relationship for a specific class, bring the class to *Pivot table* using the **Relationship** input type (see **Using Pivot table and Frozen table**). The *Pivot table* headers will be populated with all possible combinations of objects across the member classes. Locate the objects you want as members in the new relationship, and check the corresponding box in the table body.

#### From *Entity graph*

Make sure all the objects you want as members in the new relationship are in the graph. To start the relationship, either double click on one of the object items, or right click on it to display the context menu, and choose **Add relationships**. A menu will pop up showing the available relationship classes. Select the class you want; the mouse cursor will adopt a cross-hairs shape. Click on each of the remaining member objects, one by one and in the right order, to add them to the relationship. Once you’ve added enough objects for the relationship class, a dialog will pop up. Check the boxes next to the relationships you want to add, and press **Ok**.

> **Tip** : All the *Add*… dialogs support pasting tabular (spreadsheet) data from the clipboard. Just select any cell in the table and press **Ctrl+V**. If needed, the table will grow to accommodate the exceeding data. To paste data on multiple cells, select all the cells you want to paste on and press **Ctrl+V**.

### Adding paramater definitions

#### From *Stacked tables*

To add new parameter definitions for an object class, just fill the last empty row of *Object parameter definition*. Enter the name of the class under *object_class_name*, and the name of the parameter under *parameter_name*. To display a list of available object classes, start typing or double click under the *object_class_name* column. Optionally, you can also specify a default value, a parameter value list, or any number of parameter tags under the appropriate columns. The parameter is added when the background of the cells under *object_class_name* and *parameter_name* become gray.

To add new parameter definitions for a relationship class, just fill the last empty row of *Relationship parameter definition*, following the same guidelines as above.

#### From *Pivot table*

To add a new parameter definition for a class, bring the corresponding class to *Pivot table* using the **Parameter value** input type (see **Using Pivot table and Frozen table**). The **parameter** header of *Pivot table* will be populated with existing parameter definitions for the class. Enter a name for the new parameter in the last cell of that header.

### Adding parameter values

#### From *Stacked tables*

To add new parameter values for an object, just fill the last empty row of *Object parameter value*. Enter the name of the class under *object_class_name*, the name of the object under *object_name*, the name of the parameter under *parameter_name*, and the name of the alternative under *alternative_name*. Optionally, you can also specify the parameter value right away under the *value* column. To display a list of available object classes, objects, parameters, or alternatives, just start typing or double click under the appropriate column. The parameter value is added when the background of the cells under *object_class_name*, *object_name*, and *parameter_name* become gray.

To add new parameter values for a relationship class, just fill the last empty row of *Relationship parameter value*, following the same guidelines as above.

> **Note** : To add parameter values for an object, the object has to exist beforehand. However, when adding parameter values for a relationship, you can specify any valid combination of objects under *object_name_list*, and a relationship will be created among those objects if one doesn’t yet exist.

#### From *Pivot table*

To add parameter value for any object or relationship, bring the corresponding class to Pivot table using the **Parameter value** input type (see **Using Pivot table and Frozen table**). Then, enter the parameter value in the corresponding cell in the table body.

> **Tip** : All *Stacked tables* and *Pivot table* support pasting tabular (e.g., spreadsheet) data from the clipboard. Just select any cell in the table and press **Ctrl+V**. If needed, *Stacked tables* will grow to accommodate the exceeding data. To paste data on multiple cells, select all the cells you want to paste on and press **Ctrl+V**.

### Adding tools, features and methods

To add a new feature, go to *Tool/Feature* tree and select the last item under **feature** in the appropriate database, start typing or press **F2** to display available parameter definitions, and select the one you want to become a feature.

> **Note** : Only parameter definitions that have associated a parameter value list can become features.

- To add a new tool -> just select the last item under tool in the appropriate database, and enter the name of the tool.
- To add a feature for a particular tool -> drag the feature item and drop it over the tool_feature list under the corresponding tool.
- To add a new method for a tool-feature -> select the last item under tool_feature_method (in the appropriate database), start typing or press F2 to display available methods, and select the one you want to add.

### Adding alternatives and scenarios

#### From *Alternative/Scenario tree*

- To add a new alternative -> just select the last item under **alternative** in the appropriate database, and enter the name of the alternative.
- To add a new scenario -> just select the last item under **scenario** in the appropriate database, and enter the name of the scenario.
- To add an alternative for a particular scenario -> drag the alternative item and drop it over the **scenario_alternative** list under the corresponding scenario. The position where you drop it determines the alternative’s *rank* within the scenario.

> **Note** : Alternatives with higher rank have priority when determining the parameter value for a certain scenario. If the parameter value is specified for two alternatives, and both of them happen to coexist in a same scenario, the value from the alternative with the higher rank is picked.

#### From *Pivot table*

Select the **Scenario** input type (see **Using Pivot table and Frozen table**). To add a new scenario, enter a name in the last cell of the **scenario** header. To add a new alternative, enter a name in the last cell of the **alternative** header.

### Adding parameter value lists

- To add a new parameter value list, go to *Parameter value list* and select the last item under the appropriate database, and enter the name of the list.
- To add new values for the list, select the last empty item under the corresponding list item, and enter the value. To enter a complex value, right-click on the empty item and select **Open editor** from the context menu.

> **Note** : To be actually added to the database, a parameter value list must have at least one value.

### Adding parameter tags

To add a new parameter tag, go to *Parameter tag* and select the last item under the appropriate database, and enter the tag’s name.


## Parameter value editor

Parameter value editor is used to edit object and relationship parameter values such as time series, time patterns or durations. It can also convert between different value types, e.g. from a time series to a time pattern.

The editor is available from a **right click** popup menu or by **double clicking** a parameter value in one of the Spine database editors.

### Choosing value type

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/value_editor_parameter_type.png)

The combo box at the top of the editor window allows changing the type of the current value.

### Plain values

The simplest parameter values are of the *Plain value* type. The editor window lets you to write a number or string directly to the input field or set it to true, false or null as needed.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/value_editor_plain.png)

### Maps

Maps are versatile nested data structures designed to contain complex data including one and multi dimensional indexed arrays. In Parameter value editor a map is shown as a table where the last non-empty cell on each row contains the value while the preceding cells contain the value’s indexes.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/value_editor_map.png)

The extra gray column on the right allows expanding the map with a new dimension. You can append a value to the map by editing the bottom gray row. The reddish cells are merely a guide for the eye to indicate that the map has different nesting depths.

A **Right click** popup menu gives options to open a value editor for individual cells, to add/insert/remove rows or columns (effectively changing map’s dimensions), or to trim empty columns from the right hand side.

Copying and pasting data between cells and external programs works using the usual **Ctrl-C** and **Ctrl-V** keyboard shortcuts.

**Convert leaves to time series** ‘compacts’ the map by converting the last dimension into time series. This works only if the last dimension’s type is datetime. For example the following map contains two time dimensions. Since the indexes are datetimes, the ‘inner’ dimension can be converted to time series.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/value_editor_map_before_conversion.png)

After clicking **Convert leaves to time series** the map looks like this:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/value_editor_map_after_conversion.png)

### Time series

There are two types of time series: *variable* and *fixed resolution*. Variable resolution means that the time stamps can be arbitrary while in fixed resolution series the time steps between consecutive stamps are fixed.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/value_editor_time_series_variable.png)

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/value_editor_time_series_fixed.png)

The editor window is split into two in both cases. The left side holds all the options and a table with all the data while the right side shows a plot of the series. The plot is not editable and is for visualization purposes only.

In the table rows can be added or removed from a popup menu available by a **right click**. Editing the last gray row appends a new value to the series. Data can be copied and pasted by **Ctrl-C** and **Ctrl-V**. Copying from/to an external spreadsheet program is supported.

The time steps of a fixed resolution series are edited by the *Start time* and *Resolution fields*. The format for the start time is [ISO8601](https://en.wikipedia.org/wiki/ISO_8601). The *Resolution* field takes a single time step or a comma separated list of steps. If a list of resolution steps is provided then the steps are repeated so as to fit the data in the table.

The *Ignore* year option available for both variable and fixed resolution time series allows the time series to be used independent of the year. Only the month, day and time information is used by the model.

The *Repeat* option means that the time series is cycled, i.e. it starts from the beginning once the time steps run out.

### Time patterns

The time pattern editor holds a single table which shows the time period on the right column and the corresponding values on the left. Inserting/removing rows and copy-pasting works as in the time series editor.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/value_editor_time_pattern.png)

### Arrays

Arrays are lists of values of a single type. Their editor is split into two: the left side holds the actual array while the right side contains a plot of the array values versus the values’ positions within the array. Note that not all value types can be plotted. The type can be selected from the *Value type* combobox. Inserting/removing rows and copy-pasting works as in the time series editor.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/value_editor_array.png)

### Date times

The datetime value should be entered in [ISO8601](https://en.wikipedia.org/wiki/ISO_8601) format. Clicking small arrow on the input field pops up a calendar that can be used to select a date.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/value_editor_datetime.png)

### Durations

A single value or a comma separated list of time durations can be entered to the *Duration* field.

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/value_editor_duration.png)


## Updating data

This section describes the available tools to update existing data.

### Updating entities and classes

#### From *Object tree*, *Relationship tree*, or *Entity graph*

Select any number of entity and/or class items in *Object tree* or *Relationship tree*, or any number of object and/or relationship items in *Entity graph*. Then, right-click on the selection and choose **Edit…** from the context menu.

One separate *Edit…* dialog will pop up for each selected entity or class type, and the tables will be filled with the current data of selected items. E.g.:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/edit_object_classes_dialog.png)

Modify the field(s) you want under the corresponding column(s). Specify the databases where you want to update each item under the *databases* column. When you’re ready, press **Ok**.

#### From *Pivot table*

To rename an object of a specific class, bring the class to Pivot table using any input type (see **Using Pivot table and Frozen table**). Then, just edit the appropriate cell in the corresponding class header.

### Updating parameter definitions and values

#### From *Stacked tables*

To update parameter data, just go to the appropriate Stacked table and edit the corresponding row.

#### From *Pivot table*

To rename parameter definitions for a class, bring the corresponding class to *Pivot table* using the **Parameter value** input type (see **Using Pivot table and Frozen table**). Then, just edit the appropriate cell in the **parameter** header.

To modify parameter values for an object or relationship, bring the corresponding class to *Pivot table* using the **Parameter value** input type (see **Using Pivot table and Frozen table**). Then, just edit the appropriate cell in the table body.

### Updating alternatives and scenarios

#### From *Pivot table*

Select the *Scenario* input type (see **Using Pivot table and Frozen table**). To rename a scenario, just edit the proper cell in the **scenario** header. To rename an alternative, just edit the proper cell in the **alternative** header.

#### From *Alternative/Scenario tree*

To rename a scenario or alternative, just edit the appropriate item in *Alternative/Scenario tree*. To change scenario alternative ranks, just drag and drop the items under **scenario_alternatives**.

### Updating tools and Features

To change a feature or method, or rename a tool, just edit the appropriate item in *Tool/Feature tree*.

### Updating parameter values Lists

To rename a parameter value list or change any of its values, just edit the appropriate item in *Parameter value list*.


## Removing data

This section describes the available tools to remove data.

### Removing entities and classes

#### From *Object tree*, *Relationship tree* or *Entity graph*

Select the items in *Object tree*, *Relationship tree*, or *Entity graph*, corresponding to the entities and classes you want to remove. Then, right-click on the selection and choose **Remove** from the context menu.

The *Remove* items dialog will popup:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/remove_entities_dialog.png)

Specify the databases from where you want to remove each item under the databases column, and press **Ok**.

#### From *Pivot table*

To remove objects or relationships from a specific class, bring the class to *Pivot table* using the **Parameter value** input type (see **Using Pivot table and Frozen table**), and select the cells in the table headers corresponding to the objects and/or relationships you want to remove. Then, right-click on the selection and choose the corresponding **Remove** option from the context menu.

Alternatively, to remove relationships for a specific class, bring the class to *Pivot table* using the **Relationship** input type (see **Using Pivot table and Frozen table**). The *Pivot table* headers will be populated with all possible combinations of objects across the member classes. Locate the member objects of the relationship you want to remove, and uncheck the corresponding box in the table body.

### Removing parameter definitions and values

#### From *Stacked tables*

To remove parameter definitions or values, go to the relevant *Stacked table* and select any cell in the row corresponding to the items you want to remove Then, right-click on the selection and choose the appropriate **Remove** option from the context menu.

#### From *Pivot table*

To remove parameter definitions and/or values for a certain class, bring the corresponding class to *Pivot table* using the **Parameter value** input type (see **Using Pivot table and Frozen table**). Then:

  - Select the cells in the parameter header corresponding to the parameter definitions you want to remove, right-click on the selection and choose **Remove parameter definitions** from the context menu
  - Select the cells in the table body corresponding to the parameter values you want to remove, right-click on the selection and choose **Remove parameter values** from the context menu.

### Purging items

To remove all items of specific types, select **Edit -> Purge** from the hamburger menu. The *Purge items* dialog will pop up:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/mass_remove_items_dialog.png)

Select the databases from where you want to remove the items under *Databases*, and the type of items you want to remove under *Items*. Then, press **Ok**.

### Removing alternatives and scenarios

#### From *Pivot table*

Select the **Scenario** input type (see **Using Pivot table and Frozen table**). To remove scenarios, just select the proper cells in the **scenario** header, right-click on the selection and chose **Remove** from the context menu. To remove alternatives, just edit the proper cells in the **alternative** header, right-click on the selection and chose **Remove** from the context menu.

#### From *Alternative/Scenario tree*

To remove a scenario or alternative, just select the correspoding items in *Alternative/Scenario tree*, right-click on the selection and chose **Remove** from the context menu.

### Removing tools and features

To remove a feature, tool, or method, just select the correspoding items in *Tool/Feature tree*, right-click on the selection and chose **Remove** from the context menu.

### Removing parameter value Lists

To remove a parameter value list or any of its values, just select the correspoding items in *Parameter value list*, right-click on the selection and chose **Remove** from the context menu.


## Managing data

This section describes the available tools to manage data, i.e., adding, updating or removing data at the same time.

### Managing object groups

To modify object groups, expand the corresponding item in *Object tree* to display the **members** item, right-click on the latter and select **Manage members** from the context menu. The *Manage parameter tags* dialog will pop up:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/manage_members_dialog.png)

To add new member objects, select them under *Non members*, and press the button in the middle that has a plus sign. To remove current member objects, select them under *Members*, and press the button in the middle that has a minus sign. Multiple selection works in both lists.

When you’re happy, press **Ok**.

> **Note** : Changes made using the *Manage members* dialog are not applied to the database until you press **Ok**.

### Managing relationships

Select **Edit -> Manage relationships** from the menu bar. The *Manage relationships* dialog will pop up:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/manage_relationships_dialog.png)

- To get started -> select a relationship class and a database from the combo boxes at the top.
- To add relationships -> select the member objects for each class under Available objects and press the Add relationships button at the middle of the form. The relationships will appear at the top of the table under Existing relationships.
- To add multiple relationships at the same time -> select multiple objects for one or more of the classes.

> **Tip** : To extend the selection of objects for a class, press and hold the **Ctrl** key while clicking on more items.

> **Note** : The set of relationships to add is determined by applying the *product* operation over the objects selected for each class.

To remove relationships, select the appropriate rows under *Existing relationships* and press the **Remove relationships** button on the right.

When you’re happy with your changes, press **Ok**.

> **Note** : Changes made using the *Manage relationships* dialog are not applied to the database until you press **Ok**.

## Importing and exporting data

This section describes the available tools to import and export data.

### Overwiew

Spine database editor supports importing and exporting data in three different formats: SQLite, JSON, and Excel. The SQLite import/export uses the Spine database format. The JSON and Excel import/export use a specific format described below.

> **Tip** : To create a template file with the JSON or Excel format you can simply export an existing Spine database into one of those formats.

### Excel format

The Excel format consists of one sheet per object and relationship class. Each sheet can have one of four different formats:

- Object class with scalar parameter data:
![image](https://spine-toolbox.readthedocs.io/en/latest/_images/excel_object_sheet.png)
- Object class with indexed parameter data:
![image](https://spine-toolbox.readthedocs.io/en/latest/_images/excel_object_sheet_timeseries.png)
- Relationship class with scalar parameter data:
![image](https://spine-toolbox.readthedocs.io/en/latest/_images/excel_relationship_sheet.png)
- Relationship class with indexed parameter data:
![image](https://spine-toolbox.readthedocs.io/en/latest/_images/excel_relationship_sheet_timeseries.png)
### JSON format

The JSON format consists of a single JSON object with the following `OPTIONAL` keys:

1. **object_classes**: the value of this key `MUST` be a JSON array, representing a list of object classes. Each element in this array `MUST` be itself a JSON array and `MUST` have three elements:

  - The first element MUST be a JSON string, indicating the object class name.
  - The second element MUST be either a JSON string, indicating the object class description, or null.
  - The third element MUST be either a JSON integer, indicating the object class icon code, or null.

2. **relationship_classes** : the value of this key `MUST` be a JSON array, representing a list of relationships classes. Each element in this array `MUST` be itself a JSON array and `MUST` have three elements:

  - The first element `MUST` be a JSON string, indicating the relationship class name.
  - The second element `MUST` be a JSON array, indicating the member object classes. Each element in this array `MUST` be a JSON string, indicating the object class name.
  - The third element `MUST` be either a JSON string, indicating the relationship class description, or null.

3. **parameter_value_lists**: the value of this key `MUST` be a JSON array, representing a list of parameter value lists. Each element in this array `MUST` be itself a JSON array and `MUST` have two elements:

  - The first element `MUST` be a JSON string, indicating the parameter value list name.
  - The second element `MUST` be a JSON array, indicating the values in the list. Each element in this array `MUST` be either a JSON object, string, number, or null, indicating the value.

4. **object_parameters**: the value of this key `MUST` be a JSON array, representing a list of object parameter definitions. Each element in this array `MUST` be itself a JSON array and `MUST` have five elements:

  - The first element `MUST` be a JSON string, indicating the object class name.
  - The second element `MUST` be a JSON string, indicating the parameter name.
  - The third element `MUST` be either a JSON object, string, number, or null, indicating the parameter default value.
  - The fourth element `MUST` be a JSON string, indicating the associated parameter value list, or null.
  - The last element `MUST` be either a JSON string, indicating the parameter description, or null.

5. **relationship_parameters**: the value of this key `MUST` be a JSON array, representing a list of relationship parameter definitions. Each element in this array MUST be itself a JSON array and `MUST` have five elements:

  - The first element `MUST` be a JSON string, indicating the relationship class name.
  - The second element `MUST` be a JSON string, indicating the parameter name.
  - The third element `MUST` be either a JSON object, string, number, or null, indicating the parameter default value.
  - The fourth element `MUST` be a JSON string, indicating the associated parameter value list, or null
  - The last element `MUST` be either a JSON string, indicating the parameter description, or null.

6. **objects**: the value of this key `MUST` be a JSON array, representing a list of objects. Each element in this array `MUST` be itself a JSON array and `MUST` have three elements:

  - The first element `MUST` be a JSON string, indicating the object class name.
  - The second element `MUST` be a JSON string, indicating the object name.
  - The third element `MUST` be either a JSON string, indicating the object description, or null.

7. **relationships** : the value of this key `MUST` be a JSON array, representing a list of relationships. Each element in this array `MUST` be itself a JSON array and `MUST` have two elements:

  - The first element `MUST` be a JSON string, indicating the relationship class name.
  - The second element `MUST` be a JSON array, indicating the member objects. Each element in this array `MUST` be a JSON string, indicating the object name.

8. **object_parameter_values**: the value of this key `MUST` be a JSON array, representing a list of object parameter values. Each element in this array MUST be itself a JSON array and `MUST` have four elements:

  - The first element `MUST` be a JSON string, indicating the object class name.
  - The second element `MUST` be a JSON string, indicating the object name.
  - The third element `MUST` be a JSON string, indicating the parameter name.
  - The fourth element `MUST` be either a JSON object, string, number, or null, indicating the parameter value.

9. **relationship_parameter_values**: the value of this key `MUST` be a JSON array, representing a list of relationship parameter values. Each element in this array `MUST` be itself a JSON array and `MUST` have four elements:

  - The first element `MUST` be a JSON string, indicating the relationship class name.
  - The second element `MUST` be a JSON array, indicating the relationship’s member objects. Each element in this array `MUST` be a JSON string, indicating the object name.
  - The third element `MUST` be a JSON string, indicating the parameter name.
  - The fourth element `MUST` be either a JSON object, string, number, or null, indicating the parameter value.

*Example :*

```
{
    "object_classes": [
        ["connection", "An entity where an energy transfer takes place", 280378317271233],
        ["node", "An entity where an energy balance takes place", 280740554077951],
        ["unit", "An entity where an energy conversion process takes place", 281470681805429],
    ],
    "relationship_classes": [
        ["connection__node__node", ["connection", "node", "node"] , null],
        ["unit__from_node", ["unit", "node"], null],
        ["unit__to_node", ["unit", "node"], null],
    ],
    "parameter_value_lists": [
        ["balance_type_list", ["\"balance_type_node\"", "\"balance_type_group\"", "\"balance_type_none\""]],
        ["truth_value_list", ["\"value_false\"", "\"value_true\""]],
    ],
    "object_parameters": [
        ["connection", "connection_availability_factor", 1.0, null, null],
        ["node", "balance_type", "balance_type_node", "balance_type_list", null],
    ],
    "relationship_parameters": [
        ["connection__node__node", "connection_flow_delay", {"type": "duration", "data": "0h"}, null, null],
        ["unit__from_node", "unit_capacity", null, null, null],
        ["unit__to_node", "unit_capacity", null, null, null],
    ],
    "objects": [
        ["connection", "Bastusel_to_Grytfors_disch", null],
        ["node", "Bastusel_lower", null],
        ["node", "Bastusel_upper", null],
        ["node", "Grytfors_upper", null],
        ["unit", "Bastusel_pwr_plant", null],
    ],
    "relationships": [
        ["connection__node__node", ["Bastusel_to_Grytfors_disch", "Grytfors_upper", "Bastusel_lower"]],
        ["unit__from_node", ["Bastusel_pwr_plant", "Bastusel_upper"]],
        ["unit__to_node", ["Bastusel_pwr_plant", "Bastusel_lower"]],
    ],
    "object_parameter_values": [
        ["node", "Bastusel_upper", "demand", -0.2579768519],
        ["node", "Bastusel_upper", "fix_node_state", {"type": "time_series", "data": {"2018-12-31T23:00:00": 5581.44, "2019-01-07T23:00:00": 5417.28}}],
        ["node", "Bastusel_upper", "has_state", "value_true"],
    ],
    "relationship_parameter_values": [
        ["connection__node__node", ["Bastusel_to_Grytfors_disch", "Grytfors_upper", "Bastusel_lower"], "connection_flow_delay", {"type": "duration", "data": "1h"}],
        ["unit__from_node", ["Bastusel_pwr_plant", "Bastusel_upper"], "unit_capacity", 127.5],
    ]
}
```

### Importing

To import a file, select **File –> Import** from the hamburger menu. The *Import file* dialog will pop up. Select the file type (SQLite, JSON, or Excel), enter the path of the file to import, and accept the dialog.

> **Tip** : You can undo import operations using **Edit -> Undo**.

### Exporting

#### Mass export

To export items in mass, select **File –> Export** from the hamburger menu. The *Export items* dialog will pop up:

![image](https://spine-toolbox.readthedocs.io/en/latest/_images/mass_export_items_dialog.png)

Select the databases you want to export under *Databases*, and the type of items under *Items*, then press **Ok**. The *Export file* dialog will pop up now. Select the file type (SQLite, JSON, or Excel), enter the path of the file to export, and accept the dialog.

#### Selective export

To export a specific subset of items, select the corresponding items in either *Object tree* and *Relationship tree*, right click on the selection to bring the context menu, and select **Export**.

The *Export file* dialog will pop up. Select the file type (SQLite, JSON, or Excel), enter the path of the file to export, and accept the dialog.

#### Session export

To export only uncommitted changes made in the current session, select **File –> Export session** from the hamburger menu.

The *Export file* dialog will pop up. Select the file type (SQLite, JSON, or Excel), enter the path of the file to export, and accept the dialog.

> **Note** : Export operations include all uncommitted changes.

### Accessing/using exported files

Whenever you successfully export a file, a button with the file name is created in the *Exports* bar at the bottom of the form. To open the file in your registered program, press that button. To open the containing folder, click on the arrow next to the file name and select **Open containing folder** from the popup menu.


## Committing and rolling back

> **Note** :  Changes are not immediately saved to the database(s). They need to be committed separately.

To commit your changes, select **Session -> Commit** from the hamburger menu, enter a commit message and press **Commit**. Any changes made in the current session will be saved into the database.

To undo *all* changes since the last commit, select **Session -> Rollback** from the hamburger menu.

> **Tip** : To undo/redo individual changes, use the **Undo** and **Redo** actions from the **Edit** menu.

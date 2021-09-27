# How to add a new variable to SpineOpt

This chapter covers the core steps a developer should consider, when introducing a new variable to SpineOpt.
## Possible data pre-requirements

Before creating a new variable, we first have to ask ourselves whether
- a new entity class is required i.e. do the core SpineOpt building blocks need to be extended (currently available entities are listed here for [Object Classes](@Object Classes) and [Relationships Classes](@Relationship Classes))
- a new parameter to trigger the generation of the specified variable is required, e.g. to trigger the generation of a storage-node the parameter [has\_state](@ref) was introduced. For already available parameters see [Parameters](@Parameters).

Typically, to introduce a new variable, either one (or both) data pre-requists needs to be added to the SpineOpt template (`.../src/templates/spineopt_template.json`). The relevant entries for this task are:
`"object_classes"` and `"relationship_classes"`, `"object_parameters"` and `"relationship_parameters"` and possibly `"parameter_value_lists"`.

### Adding a new entity class hosting a new variable

To add an entity to SpineOpt, we need to add the entity to the core SpineOpt classes. The recommended way to do this is through modifying the spineopt_template (.../src/templates/spineopt_template.json), if the variable should be made available for any new SpineOpt database. Modifying the spineopt_template can be realized either through SpineToolbox or through modifying the template in a text editor.

#### Adding new entities to the spineopt template

 The file `.../src/templates/spineopt_template.json` holds the SpineOpt specific data structure. The relevant entries for the task of adding a new entity are `"object_classes"` and `"relationship_classes"`. To add for example a new entity called `fish`, we would add the following line to the template (e.g. below the `"unit"` in the category `"object_classes"`):
 ```
["hippo", "A hippopotamus is a semiaquatic mammal native to sub-Saharan Africa. (https://en.wikipedia.org/wiki/Hippopotamus)", 281470698518253],
 ```
The first entry will be the name of the new entity class, the second is a description of the new entity class, the third entry is an (optional) number code, translated into an icon. (We recommend, if desired, to change the icon properties in Spinetoolbox.)

Now we can create object of class `hippo`, as soon as we load our modified SpineOpt template in a database.

#### Defining a new tempo-stoch structure for the new entity

### Adding a new parameter triggering variable generation

## Creating a variable index function

## Adding a add_variable! function

## Including everything in SpineOpt

### Adding the new functionality through SpineOpt.jl module

### Adding the new functionality through run_spineopt

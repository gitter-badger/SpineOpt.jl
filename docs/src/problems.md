# Problems

In this section, I list a few problems I ran into while using Spine Toolbox

## Design View

While using Spine Toolbox, at some point, both the *Design view* and the *Project* widgets stopped appearing and it wasn't possible anymore to see or Edit the project directly on Spine Toolbox.

![image](./pictures/design_view.png)

Even when clicking on the *Restore Dock Widget* button of the *View* section, nothing was changing.

I tried to uninstall completely Spine Toolbox and re-install it but without success.

Even when trying to install Spine Toolbox through the **.exe** file, no change was possible and the problem kept on going.

### Alternative way of running projects

In the mean time, in order to **run** the projects, I used the software **Atom**. By opening the project folder and running the project using the *run_spineopt.jl* file with the following code :

```
using SpineOpt

input = "sqlite:///$(@__DIR__)/.spinetoolbox/items/input/input.sqlite"
output = "sqlite:///$(@__DIR__)/.spinetoolbox/items/input/output.sqlite"
run_spineopt(input, output; cleanup=false, log_level=2)
```

I was able to still run the project and analyze the results through the output database.

As the *Spine DB Editor* was still accessible through *Spine Toolbox*, I was still able to do some modifications on the *input* database and then, after commiting the changes, run the project and analyze the results.

> **Remark** : Sometimes, without real explanation, the Spine DB editor wouldn't allow me to *Edit* the parameters values of my database. This was pretty inconvenient as no further analysis was able to be conducted on the project. I would click on *Edit* but the software wouldn't respond to the command.


> **Remark** : When running a project that way, the output file data overwrite the previous ones. Therefore, it is usually preferable to delete the old output file and then run the project, in order to only have the required results.

## 2 Model default structures

When building a model, one has to be careful not to define 2 default relationships as it will raise an error when running the model.

## Common source of errors

A common source of error arise for forgetting to define the relationship between the model and the temporal block and/or the stochastic structure. At least a default relationship has to be defined in order for the model to run appropriately.

At some point, I also lost quite some time because when running my program, no **output** file was generated. The problem was that no `model_report` relationship was defined. Therefore, it's important not to forget to add this relationship to the model in order to be able to access the results in the output database.

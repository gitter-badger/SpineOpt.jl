# Additional Remarks regarding the Documentation

## Introduction

A general comment that concerns as well other parts of the documentation is that there are many links to different GitHub repositories or other source of additional information. For an HTML page, this is not a real issue, but this can become problematic if it is considered to make a PDF or printable document of this Documentation. The text would then have to be adapted in order not to lose completeness of the explanations.

A quick example to highlight this is the *Installation* that is all explained in a GitHub repository, meaning that it is necessary to add the text to this documentation if a printable document is created.

## Getting Started

I added 2 sub-sections to this one :

The first one is called **Definitions** and is based on the ones given in the [Spine Toolbox documention](https://spine-toolbox.readthedocs.io/en/latest/terminology.html).

The second one is also based on this documention and I called it **Spine DB Editor**. I felt like it wasn't really practical to always have to go to this documentation in order to look for informations on how to get used to the simple things to manage the database. Maybe it is not necessary to have this section in this documentation, but it's just for the first 2 weeks at least, I spend a lot of time of the [Spine Toolbox documention](https://spine-toolbox.readthedocs.io/en/latest/spine_db_editor/index.html) in order to get used to Spine Toolbox and understand how things work.

### Installation

It is advised to *"make sure that the installed packages are in a clean Conda environment"*. But I think it could be of added value to quickly explain what a conda environment is, because it wasn't really clear for me at first and I had to ask Kristof for additional information in order to understand how all this works.

As mentioned before, all the installation process of the *Spine Toolbox* is into the *GitHub* repository. At the end, this is not a problem as the link to access the process is provided, but maybe it could be simpler to just add this process directly into the documentation here.

**Remark :** In the installation process presented in the repository of GitHub [here](https://github.com/Spine-project/Spine-Toolbox#installation), it is said that to run *Spine Toolbox*, one should only open a terminal and write
```
spinetoolbox
```
but actually, what has to be written is :
```
pipx run spinetoolbox
```
The first expression leads to an error. This maybe obvious, I don't know.. But for someone like me, who at first wasn't really familiar with the use of a terminal, etc.. it can be easy to lose plenty of time on those details.

**Note** :  Kristof showed me a complete other way of installing Spine Toolbox, when I had a bug about the *Design View* that wasn't appearing anymore. This installation process was conducted directly in the *Spine Toolbox* folder of the cloned repository of *Spine Toolbox*. I don't remember the exact sequence but as far as I remember, he told me that it was better to install Spine Tooblbox that way as we could be sure to have the latest version with the latest update. (after being sure of pulling the latest version of course)
It was also interesting as he showed me some commands (that I don't remember exactly) allowing to see the packages that are installed, as well as some others to easily remove, add, or install those packages.

Another important comment is that when I installed Spine Toolbox using the **.exe** file of Windows, I wasn't able to open my **.sqlite** files anymore. I received an error message telling me that the software couldn't support this version of databases.

### Create your own model

I thought it was maybe better to include the section *Setting up a workflow* into this section but it's just a suggestion.

### Example Models

I would suggest to add as many relevant examples as you think is necessary, because those are the ones that are the most useful for a new user to get to now how the process works. If the example is well presented and the different steps well explained, it becomes really easy to understand what it's possible to accomplish with the tool and then start implementing ones own model.

I saw that there was already an empty *Case Study A5* example with only *TO DO* written underneath, so I took the initiative to build it myself using what I've been able to find in the *SpineOpt* repository and the *Spine Toolbox* documentation, and then I added it here into the documentation.

I also found another example, much simpler, that was in *Spine Toolbox* documentation, and also decided to add it here into the documentation.

**Remark :** For the Case Study A5 example, the database that is on the SpineOpt repository isn't complete. In order for the model to work properly, a stochastic structure and a stochastic scenario have to be included.
Moreover, a few relationships have to be included as well :
- `model__report`
- `model__default_temporal_block` and/or `model__temporal_block`
- `model__default_stochastic_structure` and/or `model__stochastic_structure`

Even if I included some information on how to add advanced concepts on the Simple Example only, it can be a good idea to also show those possibilities on the example *Case Study A5*. I tried to implement it by myself, aiming for physically explainable results, but I thought that as the results I got weren't that straightforward, it was better not to include them into the documentation.

### Hybrid-car example

In the folder that I sent you, you can see the project I was working on about the Hybrid-car. It is not representative of the type of problems SpineOpt was made for, but it shows some diverse application.

### `balance_type`

Something I took for granted after having looked other examples, and because it would give me results, was that the node that is the most "ahead" has to be of `balance_type`, so that it can balance itself to follow the demand.
I mention this because I see that this concept isn't clear enough in my head in order to know what I would have to do building a model with dozens of nodes. Which ones can I assign a demand and which ones have to be of `balance_type`

## Concept Reference

This section is very clear and complete for me. I have no real comment to add regarding it.

## Mathematical Formulation

For this section, I would suggest to write the different equations in a format that is easier to read.

At the moment, the equations are written using a layout similar to the one used in *Microsoft Word*, but I think aiming for a format that would give a layout similar to what we can get using *LaTeX* would give the reader more confort in order to read and understand the different equations.

I made some research on Google to know whether it is possible to write the equations in *LaTeX* format using *Markdown*, but I didn't find a suitable solution.

### Constraints

Kristof showed that it was possible to get access to the optimization problem being solved when running the model. I think that it could be bring an added value to include that information into the documentation so that the developer can easily keep track of what he is doing and be sure that the model is doing what he expects.

The code that I was given in order to do so is the following :

```
function write_model_file(m::JuMP.Model; file_name="model")
    model_string = "$m"
    model_string = replace(model_string, s"+ " => "\n\t+ ")
    model_string = replace(model_string, s"- " => "\n\t- ")
    model_string = replace(model_string, s">= " => "\n\t\t>= ")
    model_string = replace(model_string, s"== " => "\n\t\t== ")
    model_string = replace(model_string, s"<= " => "\n\t\t<= ")
    open(joinpath(@__DIR__, "$(file_name).so_model"), "w") do file
        write(file, model_string)
    end
end
```

this code has to be added to the *run_spineopt.jl* file, and will automatically create a file called *model.so_model* containing the expression of the optimization problem being solved when running the model.

The package JuMP is required in order for the process to run. Therefore the following code needs to be added on top of the file:
```
using JuMP
```

## Advanced Concepts

/!\ also check the *Simple Model* example for implementation and discussion

I would suggest to dive deeper into the remaining advanced concepts that weren't tackled into the example model. The explanation in the documentation is good but can still be difficult to implement without an example to show how to include those concept into a model.

### Stochastic Framework

At first, it wasn't that straightforward for me to make the link between optimization problems and stochastic analysis. Therefore, I added a some paragraphs explaining a bit more how stochastic analysis are included into energy optimization problems.

### Investment

**Typos :**
- *multiplied* rather than *multuplied*
- *interpreted* rather than *intpreted*

When building an investment model, one could  be tempted to set the parameter `fix_unit_invested` in order to choose the amount of units that have to be invested in. The problem is that by doing so, the model won't take the investment strategy into account anymore as it won't be able to adapt the units to invest according the optimal power flow.
It is then preferable to aim for the `candidate_units` parameter instead, which set the amount of additional units which can be invested in.

Something interesting to add as well is the output `units_invested` to the model. It was interesting for me to be able to see directly on a graph, the way the model would recommend to invest in the different units according to different conditions.

![image](./pictures/units_invested.png)


## Library

The library isn't complete. As far as I understood, what remains is to accurately fill in the *docstring* above the different *function* etc, of the different items of the Library, and then the rest is done automatically. I was told that someone else on the project was responsible for that part, therefore my comment is only for information.

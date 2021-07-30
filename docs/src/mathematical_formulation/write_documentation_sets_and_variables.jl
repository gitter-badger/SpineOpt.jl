using CSV
using DataFrames

function write_documentation_sets_variables()
    variables = DataFrame(CSV.File("$(@__DIR__)/variables.csv"))
    variables[!,:variable_name_latex] = replace.(variables.variable_name, r"_" => "\\_")
    variables.variable_name_latex .= "``v_{" .* variables.variable_name_latex .* "} ``"
    variables.indices .= replace.(variables.indices, r"_" => "\\_")
    variable_string = "# Variables \n"
    for i in 1:size(variables, 1)
        variable_string = string(variable_string, "## `$(variables.variable_name[i])` \n\n")
        variable_string = string(variable_string, " > **Math symbol:** $(variables.variable_name_latex[i]) \n\n")
        variable_string = string(variable_string, " > **Index:** $(variables.index[i]) \n\n")
        variable_string = string(variable_string, " > **Indices function (Set):** $(variables.indices[i]) \n\n")
        variable_string = string(variable_string, "$(variables.description[i]) \n\n")
    end
    sets = dropmissing(DataFrame(CSV.File("$(@__DIR__)/sets.csv")))
    set_string = "# Sets \n"
    for i in 1:size(sets, 1)
            set_string = string(set_string, "## `$(sets.indices[i])` \n\n")
            set_string = string(set_string, " > **Index:** $(sets.index[i]) \n\n")
            set_string = string(set_string, "$(sets.Description[i]) \n\n")
    end

    io = open("$(@__DIR__)/variables.md", "w")
    write(io, variable_string)
    close(io)

    io = open("$(@__DIR__)/sets.md", "w")
    write(io, set_string)
    close(io)
end

function write_sets_latex()
    sets = dropmissing(DataFrame(CSV.File("$(@__DIR__)/sets_tex.csv")))
    set_string = "# Sets \n"
    for i in 1:size(sets, 1)
        set_string = string(set_string, "\$$(sets.index[i]) \\in $(sets.indices[i])\$ \n")
        set_string = string(set_string, "& $(sets.Description[i]) \\\\ \n\n")
    end

    io = open("$(@__DIR__)/sets.txt", "w")
    write(io, set_string)
    close(io)
end

function write_parameters_latex()
    parameters = dropmissing(DataFrame(CSV.File("$(@__DIR__)/parameters_tex.csv")))
    parameter_string = "# Parameters \n"
    for i in 1:size(parameters, 1)
        parameter_string = string(parameter_string, "\$p_{$(parameters.name[i])}\$ \n")
        parameter_string = string(parameter_string, "& $(parameters.Description[i]) \\\\ \n")
        parameter_string = string(parameter_string, "\\multicolumn{2}{ l }{ \\hspace{2pt} \\text{-Inherent Index:} \$$(parameters.inherent_index[i]) \\in $(parameters.classes[i])\$ } \\\\ \n\n")
    end

    io = open("$(@__DIR__)/parameters.txt", "w")
    write(io, parameter_string)
    close(io)
end

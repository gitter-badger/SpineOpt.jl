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
        if parameters.classes[i] == "**"
            break
        end
        parameter_string = string(parameter_string, "\$p_{$(parameters.name[i])}$(parameters.inherent_index[i])\$ \n")
        parameter_string = string(parameter_string, "& $(parameters.Description[i]) \n")
        class_type = "object"
        if occursin("\\_\\_", parameters.classes[i])
            class_type = "relationship"
        end
        parameter_string = string(parameter_string, "The parameter is defined under the SpineOpt $class_type class \\textit{$(parameters.classes[i])}. \\\\ \n\n")
    end

    io = open("$(@__DIR__)/parameters.txt", "w")
    write(io, parameter_string)
    close(io)
end

function write_variables_latex()
    variables = dropmissing(DataFrame(CSV.File("$(@__DIR__)/variables_tex.csv")))
    variables.name .= replace.(variables.name, r"_" => "\\_")
    variables.indices .= replace.(variables.indices, r"_" => "\\_")
    variables.description .= replace.(variables.description, r"``" => "\$")
    variable_string = "# Variables \n"
    for i in 1:size(variables, 1)
        variable_string = string(variable_string, "\$v_{$(variables.name[i])}$(variables.index[i])\$ \n")
        variable_string = string(variable_string, "& $(variables.description[i]) \n")
        variable_string = string(variable_string, "Its index belongs to the set \\textit{$(variables.indices[i])}. \n")
        variable_string = string(variable_string, "\\hypertarget{$(BigInt(variables.hypertarget[i]))}{} \\\\ \n\n")
    end

    io = open("$(@__DIR__)/variables.txt", "w")
    write(io, variable_string)
    close(io)
end

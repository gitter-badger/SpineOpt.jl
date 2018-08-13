function capacity(m::Model, flow,number_of_timesteps)
    @constraint(m, [u in unit(),n in node(), t=1:number_of_timesteps; !isnull(UnitCapacity(u))],
        + sum(flow[c,n, u, "out", t] for c in capa_defining_com(u) if c in output_com(u))
        + sum(flow[c,n, u, "in", t] for c in capa_defining_com(u) if c in input_com(u))
        <= AF(u) * CapToFlow(u) * UnitCapacity(u)
end

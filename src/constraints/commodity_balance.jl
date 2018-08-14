function commodity_balance(m::Model,flow, trans,number_of_timesteps,jfo)
    @constraint(m, [c in commodity(), n in CommodityAffiliation(c), t=1:number_of_timesteps; !isnull(demand(n,t))],
        + sum(flow[c, n,u, "out", t] for u in NodeUnitConnection(n))
        == demand(n, t) + sum(flow[c, n,u, "in", t] for u in NodeUnitConnection(n))
        + sum(trans[k,n,j,t] for k in connection(), j in node() if [k,n,j] in get_all_connection_node_pairs(jfo,true))
    )
    # @constraint(m, [c in commodity(), n in node(), t=1:number_of_timesteps; isnull(demand(n,t))],
    #     + sum(flow[c, n,u, "out", t] for u in NodeUnitConnection(n))
    #     == + sum(flow[c, n,u, "in", t] for u in NodeUnitConnection(n))
    #     + sum(trans[k,n,j,t] for k in connection(), j in node() if [k,n,j] in get_all_connection_node_pairs(jfo,true))
    # )
end

## helper to find all connection connected to a node
# for n in node()
#     demand(n) + sum(jfo["NodeConnectionRelationship"][n],trans) = sum(,flow)
#     jfo["NodeConnectionRelationship"][n]
# end

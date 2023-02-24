function [data_to_edge] = data_delivery_to_edge(t,M,beta,delta,mem_free,a,bandwidth_cloud)

noe = M;


cvx_begin
    variable data_to_edge(noe);
    expression bw_util(noe);
    expression bw_cost(noe);
    expression wr_cost(noe);
    expression usage_cost;

    for j = 1:noe
        bw_util(j) = data_to_edge(j)/(t * bandwidth_cloud);
        bw_cost(j) = beta*(1+bw_util(j))^2;
        wr_cost(j) = (1 - (data_to_edge(j)/mem_free(j)))*delta;
        usage_cost = usage_cost + bw_cost(j) + wr_cost(j);
    end

%   delta is the waste cost factor

    minimize usage_cost
    subject to
        for j = 1:noe
            data_to_edge(j) >= 0;
        end
        
        for j = 1:noe
            data_to_edge(j) <= a(j);
        end

        for j = 1:noe
            data_to_edge(j)<(t*bandwidth_cloud);
        end

        sum(data_to_edge) >= 0;
        

cvx_end


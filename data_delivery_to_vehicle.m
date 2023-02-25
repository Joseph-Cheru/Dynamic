function [data_to_vehicle] = data_delivery_to_vehicle(t,N,Vec_set,mem_free,mem_req,data_to_edge,num_min_edges,a,d_min);

nov = N;


cvx_begin
    variable data_to_vehicle(nov);
    expression leftover_data(nov);
    expression leftover_ratio(nov);
    expression leftover_ratio_sum;


    for i = 1:nov
        leftover_data(i) = mem_req(Vec_set(i))-data_to_vehicle(i);
        leftover_ratio(i) = leftover_data(i)/(num_min_edges(Vec_set(i)));
        leftover_ratio_sum = leftover_ratio_sum + leftover_ratio(i);
    end

    minimize leftover_ratio_sum
    % maximize sum(data_to_vehicle)
    subject to

        for i=1:nov
            data_to_vehicle(i) >= 0;
        end

        for i=1:nov
            leftover_data(i) >= 0;
        end

        for i=1:nov
            leftover_ratio(i) >= 0;
        end

        leftover_ratio_sum >= 0;
        
        for i=1:nov
            data_to_vehicle(i) <= mem_req(Vec_set(i));
            %data_to_vehicle(i) <= mem_req(i);
        end

        sum(data_to_vehicle) <= data_to_edge;

        for i=1:nov
            data_to_vehicle(i) <= d_min(Vec_set(i));
            %data_to_vehicle(i) <= d_min(i);
        end
cvx_end


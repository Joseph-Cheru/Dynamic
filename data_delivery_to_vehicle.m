function [data_to_vehicle] = data_delivery_to_vehicle(t,N,Vec_set,mem_free,mem_req,data_to_edge,num_min_edges,a,d_min);

nov = N;

cvx_pause(true);

cvx_begin
    variable data_to_vehicle(nov);
    expression leftover_data(nov);
    expression leftover_ratio(nov);
    expression leftover_ratio_sum;


    for i = 1:nov
        leftover_data(i) = mem_req(Vec_set(i))-data_to_vehicle(i);
        leftover_ratio(i) = leftover_data(i)/(num_min_edges(Vec_set(i))+1);
        leftover_ratio_sum = leftover_ratio_sum + leftover_ratio(i);
    end

    disp(leftover_ratio_sum); %testing
    disp(leftover_ratio(1)); %testing
    disp(leftover_data(1)); %testing

    minimize leftover_ratio_sum
    subject to

        for i=1:nov
            data_to_vehicle(i) >= 0;
        end

        for i=1:nov
            data_to_vehicle(i) <= mem_req(i);
        end

        sum(data_to_vehicle) <= data_to_edge;

        for i=1:nov
            data_to_vehicle(i) >= d_min(i);
        end

        sum(data_to_vehicle) <= a;

        sum(data_to_vehicle) >= 0;

cvx_end


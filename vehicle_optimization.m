function [data_to_vehicle] = vehicle_optimization(N,mem_req,data_to_edge,d_min);
disp(N);
disp(mem_req);
disp(data_to_edge);
disp(d_min);
nov = N;
cvx_begin
    variable data_to_vehicle(nov);

    maximize sum(data_to_vehicle)
     subject to

        for i=1:nov
            data_to_vehicle(i) >= 0;
        end
        for i=1:nov
            
            data_to_vehicle(i) <= mem_req(i);
        end

        sum(data_to_vehicle) <= data_to_edge;

        for i=1:nov
            
            data_to_vehicle(i) <= d_min;
        end
cvx_end
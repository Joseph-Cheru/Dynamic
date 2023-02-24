clear all;
clc;
tic;
N_edges = 4;
    %number of edges
N_vehicles = 1;
    %number of vehicles at at zeroth time slot
loc_edge = [8,11,26,29];
    %Location of the edges
mem_req = [76];
    %requested memory of all vehicles  between 60 and 80
mem_edge = [464, 427, 439, 455];
    %total memory of al edges between 400 and 500
mem_proc = [31, 66, 149, 49];
    %processing memory of all edges between 0 and 150
bandwidth_edge = [14, 12, 15, 13];
    %total bandwidth of all edges to send data to vehicles between 8 and 15
l_cov = [1.2, 0.8, 0.9, 1.1];
    %coverage length of edges        
k_final = 46;
    %last time slot
beta = 0.36;
delta = 0.36;
t =5;

adj_square_edge = [2, 7, 9, 14; 5, 10, 12, 17; 20, 25, 27, 32; 23, 28, 30, 35];

x = [3, 4, 5, 6, 6, 12, 11, 17, 23, 24, 24, 18, 17, 16, 15, 9, 9, 10, 11, 5, 4, 4, 10, 16, 22, 28, 27, 27, 21, 20, 19, 13, 7, 7, 8, 14, 13, 7, 7, 1, 2, 1, 7, 7, 13, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8];

i_velocity = [67];
i_location = [3];
destination = [8];
60.000

density_jam = 60;

bandwidth_cloud = 400;

edge_edge_min = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1; 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1; 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1; 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
 %to change

for k = 1:k_final
    %read data from file
    location =x(1:N_vehicles,k);
    Vec_set = {};
    mem_free = [];
    d_min = [];
    a = [];
    len_vec_set = [];
    mem_req_k = [];

    for j =1:N_edges
        set = [];
        d_min_j = [];
        for i = 1:N_vehicles
            for z = 1:4
                if location(i) == adj_square_edge(j,z) || location(i) == loc_edge(j)
                    set = [set i];
                end
            end
        end

        Vec_set{j} = set;
        len_vec_set = [len_vec_set length(set)];
        mem_req_j = [];

        for i = 1:N_vehicles
            f = 0;
            for m = 1:length(set)
                if i==set(m)
                    f=1;
                end
            end
            if mem_req(i) <= 0
                mem_req(i) = 0
                f = 0
            end
            if f==1
                min_j = (bandwidth_edge(j)*t)/length(set);
                d_min_j = [d_min_j min_j];
                mem_req_j = [mem_req_j mem_req(i)];
            else
                d_min_j = [d_min_j 0];
                mem_req_j = [mem_req_j 0];
            end
        end

        mem_free_j = mem_edge(j)-mem_proc(j);

        d_min = [d_min;d_min_j];

        mem_free = [mem_free mem_free_j];

        mem_req_k = [mem_req_k;mem_req_j];

        min_var = [mem_free_j,sum(mem_req_j),sum(d_min_j)];

        a_j = min(min_var);

        a = [a a_j];
    end

    disp("k");
    disp(k);
    [data_to_edge] = data_delivery_to_edge(t,N_edges,beta,delta,mem_free,a,bandwidth_cloud);
    disp(data_to_edge);
    for j=1:N_edges
        num_min_edges_j =[];
        for i=1:N_vehicles
            num_min_edegs_i = 1;
            f1 = 0;
            m =1;
            if len_vec_set(j)>0
                for m = 1:len_vec_set(j)
                    if i==Vec_set{j}(m)
                        f1=1;
                    end
                end
            end
            if f1==1
                num_min_edges_i = edge_edge_min(j,destination(i));
            else
                num_min_edegs_i = N_edges;
            end
            num_min_edges_j = [num_min_edges_j;num_min_edegs_i];
        end

        if len_vec_set(j)>0
            disp("j");
            disp(j);
            %data_to_vehicle = zeros(1,N_vehicles);
            [data_to_vehicle] = data_delivery_to_vehicle(t,N_vehicles,Vec_set{j},mem_free(j),mem_req_k(j,1:N_vehicles),data_to_edge(j),num_min_edges_j,a(j),d_min(j,1:N_vehicles));
            disp(num_min_edges_j);
            disp(data_to_vehicle);
            disp(mem_req);
            
            for i=1:N_vehicles
                if k<k_final
                    if x(i,k+1) == loc_edge(j);
                        disp("i");
                        disp(i);
                        disp(Vec_set)
                        disp(data_to_vehicle);
                        disp(mem_req(i));
                        disp("minus");
                        % if data_to_vehicle(i)>0;
                        mem_req(i) = mem_req(i) - data_to_vehicle(i);
                        % end                   
                    end
                end
            end
        end
    end
end

disp(mem_req);
total_time = toc;
disp(total_time);



tic;
N_edges = 4;
    %number of edges
N_vehicles = 1;
    %number of vehicles at at zeroth time slot
loc_edge = [7, 10, 25, 28];
    %Location of the edges
mem_req = [78];
    %requested memory of all vehicles  between 60 and 80
mem_edge = [430, 421, 412, 497];
    %total memory of al edges between 400 and 500
mem_proc = [63, 9, 29, 66];
    %processing memory of all edges between 0 and 150
bandwidth_edge = [9, 9, 12, 8];
    %total bandwidth of all edges to send data to vehicles between 8 and 15
l_cov = [0.8, 1.2, 1.3, 0.7];
    %coverage length of edges        
k_final = 40;
    %last time slot
beta = 0.36;
delta = 0.36;
t =3;

adj_square_edge = [1, 6, 8, 13; 4, 9, 11, 16; 19, 24, 26, 31; 22, 27, 29, 34];

x = [32, 33, 27, 27, 28, 29, 23, 22, 21, 21, 20, 14, 15, 16, 17, 11, 11, 10, 9, 8, 8, 2, 1, 7, 6, 0, 1, 2, 2, 3, 4, 5, 4, 5, 5, 4, 3, 2, 1, 1, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7];

i_velocity = [58];
i_location = [32];
destination = [7];


density_jam = 60;

bandwidth_cloud = 400;

edge_edge_min = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0; 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
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
                if location(i) == adj_square_edge(j,z)
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

    [data_to_edge] = data_delivery_to_edge(t,N_edges,beta,delta,mem_free,a,bandwidth_cloud);
    disp(data_to_edge);
    for j=1:N_edges
        num_min_edges_j =[];
        for i=1:N_vehicles
            num_min_edegs_i = 0;
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
                num_min_edges_i = edge_edge_min(j,destination(i))+1;
            else
                num_min_edegs_i = N_edges;
            end
            num_min_edges_j = [num_min_edges_j;num_min_edegs_i];
        end
        if len_vec_set(j)>0
            [data_to_vehicle] = data_delivery_to_vehicle(t,len_vec_set(j),Vec_set{j},mem_free(j),mem_req_k(j,1:N_vehicles),data_to_edge(j),num_min_edges_j,a(j),d_min(j,1:N_vehicles));
            disp(num_min_edges_j);
            disp(data_to_vehicle);
            disp(mem_req);
            disp("k");
            disp(k);
            for i=1:N_vehicles
                if k<k_final
                    if x(i,k+1) == loc_edge(j);
                        disp("i");
                        disp(i);
                        disp("j");
                        disp(j);
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



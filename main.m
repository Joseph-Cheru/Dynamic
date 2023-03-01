clear all;
clc;
tic;

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
                %if location(i) == adj_square_edge(j,z) || location(i) == loc_edge(j)
                if location(i) == adj_square_edge(j,z) && mem_req(i) > 1
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
                mem_req(i) = 0;
                f = 0;
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
            disp("Vehicle set");
            disp(Vec_set{j});
            [data_to_vehicle] = data_delivery_to_vehicle(t,len_vec_set(j),Vec_set{j},mem_free(j),mem_req_k(j,1:N_vehicles),data_to_edge(j),num_min_edges_j,a(j),d_min(j,1:N_vehicles));
            disp(data_to_vehicle);
            disp(mem_req);
            
            for i=1:len_vec_set(j)
                if k<k_final
                    if x(Vec_set{j}(i),k+1) == loc_edge(j)
                        disp(data_to_vehicle);
                        disp(mem_req(Vec_set{j}(i)));
                        disp("minus");
                        % if data_to_vehicle(i)>0;
                        mem_req(Vec_set{j}(i)) = mem_req(Vec_set{j}(i)) - data_to_vehicle(i);
                        % end         
                        if mem_req(Vec_set{j}(i))<1
                            mem_req(Vec_set{j}(i)) = 0;
                        end         
                    end
                end
            end
        end
    end
end
not_deli =0;
disp(mem_req);
for i=1:N_vehicles
    if mem_req(i)>1
        disp("not delivered");
        not_deli = not_deli+1;
        disp(i);
    end
end
disp("not delivered number");
disp(not_deli);
total_time = toc;
disp(total_time);
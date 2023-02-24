clear all;
t =5;
N =1;
N_edges = 4;
beta =0.36;
delta =0.36;
mem_free = [433,361,290,400];
%mem_free = [433];
a = [0,110,0,0];
%a =[60];
d_min = [0,110,0,0];
%d_min = [60];
bandwidth_cloud = 400;
[data_to_edge] = data_delivery_to_edge(t,N_edges,beta,delta,mem_free,a,bandwidth_cloud);
disp(data_to_edge);
mem_req = [100];
for j=1:N_edges
    disp("j");
    disp(j);
    % disp(mem_req(1));
    [data_to_vehicle] = vehicle_optimization(N,mem_req,data_to_edge(j),d_min(j));
    % disp(sum(data_to_vehicle));
    disp(data_to_vehicle);
    for i=1:N
        disp(mem_req(i));
        mem_req(i) = mem_req(i) - data_to_vehicle(i); 
        disp(mem_req(i));
    end
end
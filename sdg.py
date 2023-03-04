import numpy as np
import random
# from queue import PriorityQueue
# import heapdict
import heapq

side_length = 15
num_edges = 36 #49, 64, 81, 100
num_vehicles = 100# 100(36, 49), 200(36, 49, 64), 300(49, 64,81), 400(81, 100)
t = 20

def adj_square(src):
    adj = []
    if (src in corner_squares):
        if (src==1):
            adj = [src+1,src+side_length]
        elif(src==(side_length)):
            adj=[src-1,src+side_length]
        elif(src==(sq-side_length+1)):
            adj=[src-side_length,src+1]
        else:
            adj=[src-side_length,src-1]
    elif(src<side_length):
        adj=[src-1,src+1,src+side_length]
    elif(src%side_length==0):
        adj=[src-side_length,src-1,src+side_length]
    elif((src-1)%side_length==0):
        adj=[src-side_length,src+1,src+side_length]
    elif((src-(sq-side_length))>0):
        adj=[src-side_length,src-1,src+1]
    else:
        adj=[src-side_length,src-1,src+1,src+side_length]
    return adj


def calculate_distances(src):
    distances = {vertex: float('infinity') for vertex in range(1,sq+1)}
    distances[src] = 0
    ete =[]

    pq = [(0, src)]
    while len(pq) > 0:
        current_distance, current_vertex = heapq.heappop(pq)

        # Nodes can get added to the priority queue multiple times. We only
        # process a vertex the first time we remove it from the priority queue.
        if current_distance > distances[current_vertex]:
            continue

        for neighbor in adj_square(current_vertex):
            if neighbor in loc_edge:
                distance = current_distance + 1
            else:
                distance = current_distance

            # Only consider this new path if it's better than any path we've
            # already found.
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                heapq.heappush(pq, (distance, neighbor))
    for v in distances.keys():
        dist = distances[v]+1
        ete.append(dist)
    return ete

def path_calculation(i,location,velocity,path,K_final):
    d_dist = 0
    next_square = 0
    #For k=0
    dist = int(velocity*(5.0/18.0)*t)
    if (dist>250):
        l = location
        next_square = (int(random.choice(adj_square(l))))
        d_dist = (dist - 250)
    else:
        next_square = (location)
        d_dist = (dist)
    if(len(path)<=i):
        path.append([location])
    else:
        # print("len = ",len(path),"i = ",i,"path = ",path)
        path[i]=[]
        path[i].append(location)
    velocity = random.randint(20,80)
    passed_edge = set()
    #For k>0 to K_final

    for k in range (1,K_final):        
        dist = int(velocity*(5.0/18.0)*t)
        if ((dist+d_dist)>250):
            location = next_square
        if (location in loc_edge and location != path[i][-1]):
            num_edge_passed[i]+=1
            passed_edge.add(location)
        if ((dist+d_dist)>500):
            l =location
            next_possible_square =[]
            for square in (adj_square(l)):
                if square not in (path[i]):
                    next_possible_square.append(square)
            if (len(next_possible_square)==0):
                next_square =(random.choice(adj_square(l)))
            else:
                next_square =(random.choice(next_possible_square))
            while (next_square in loc_edge and next_square in path[i]):
                next_square =(random.choice(adj_square(l)))
            d_dist =(dist + d_dist - 500)
        else:
            next_square =(location)
            d_dist = dist+d_dist
        path[i].append(location)
        if (velocity!=0):
            velocity = random.randint(20,80)
    # return passed_edge

def alter_path_calculation(i,path,k_start,K_final):
    d_dist = 0
    next_square = 0
    #For k=0
    location = path[i][k_start]
    velocity = random.randint(20,80)
    dist = int(velocity*(5.0/18.0)*t)
    if (dist>250):
        l = location
        next_square = (int(random.choice(adj_square(l))))
        d_dist = (dist - 250)
    else:
        next_square = (location)
        d_dist = (dist)
    if(len(alter_path)<=i):
        alter_path.append([])
        for k in range(k_start):
            alter_path[i].append(path[i][k])
        alter_path[i].append(location)
    else:
        # print("len = ",len(path),"i = ",i,"path = ",path)
        alter_path[i]=[]
        for k in range(k_start):
            alter_path[i].append(path[i][k])
        alter_path[i].append(location)
    velocity = random.randint(20,80)
    passed_edge = set()
    #For k>0 to K_final

    for k in range (k_start,K_final):        
        dist = int(velocity*(5.0/18.0)*t)
        if ((dist+d_dist)>250):
            location = next_square
        if (location in loc_edge and location != alter_path[i][-1]):
            num_edge_passed[i]+=1
            passed_edge.add(location)
        if ((dist+d_dist)>500):
            l =location
            next_possible_square =[]
            for square in (adj_square(l)):
                if square not in (alter_path[i]):
                    next_possible_square.append(square)
            if (len(next_possible_square)==0):
                next_square =(random.choice(adj_square(l)))
            else:
                next_square =(random.choice(next_possible_square))
            while (next_square in loc_edge and next_square in alter_path[i]):
                next_square =(random.choice(adj_square(l)))
            d_dist =(dist + d_dist - 500)
        else:
            next_square =(location)
            d_dist = dist+d_dist
        alter_path[i].append(location)
        if (velocity!=0):
            velocity = random.randint(20,80)
    print("alter_path vehcile number = ",i)


sq = np.square(side_length) # total number of squares

border_squares =[]
non_border_squares =[]
corner_squares =[]
corner_squares.append(1)
corner_squares.append(side_length)
corner_squares.append(sq-side_length+1)
corner_squares.append(sq)



for n in range (1,sq+1):
    if (n<=side_length):
        border_squares.append(n)
    elif(n%side_length==0):
        border_squares.append(n)
    elif((n-1)%side_length==0):
        border_squares.append(n)
    elif((n-(sq-side_length)) >0):
        border_squares.append(n)
    else:
        non_border_squares.append(n)

loc_edge = []
mem_edge = []
mem_proc = []
bandwidth_edge = []
l_cov = []

for j in range(num_edges):
    location = (random.choice(non_border_squares))
    f=0
    while(f==0):
        if (location in loc_edge):
            location = (random.choice(non_border_squares))
        else:
            loc_edge.append(location)
            f =1

loc_edge.sort()
adj_square_edge = []
for j in range(num_edges):
    mem_edge.append(random.randint(400,500))
    mem_proc.append(random.randint(0,150))
    bandwidth_edge.append(random.randint(8,15))
    l_cov.append(random.randint(400,500)/1000.0)
    adj_square_edge.append(adj_square(loc_edge[j]))

start_loc_vehicles =[]
curr_loc = []
velocity = []
i_velocity = []
path =[]
mem_req = []
num_alter_vehicles = int(num_vehicles/10)
alter_path = []


for i in range(num_vehicles):
    start_loc_vehicles.append(random.choice(border_squares))
    curr_loc.append(start_loc_vehicles[i])
    velocity.append(random.randint(50,70))
    i_velocity.append(velocity[i])
    mem_req.append(random.randint(60,80))

k =0
K_final = 120

print("N_edges = ",num_edges,";")
print("\nN_vehicles = ",num_vehicles,";")
print("\nloc_edge = ",loc_edge,";")
print("\nmem_req = ",mem_req,";")
print("\nmem_edge = ",mem_edge,";")
print("\nmem_proc = ",mem_proc,";")
print("\nbandwidth_edge = ",bandwidth_edge,";")
print("\nl_cov = ",l_cov,";")  
print("\nk_final = ",K_final,";")
print("\nbeta = 0.36;")
print("\ndelta = 0.36;")
print("\nt = ",t,";")       
print("\nadj_square_edge = [",end="")

for j in range(num_edges-1):
    for i in range(3):
        print(adj_square_edge[j][i],",",end="")
    print(adj_square_edge[j][3],";",end="")
for i in range(3):
    print(adj_square_edge[num_edges-1][i],",",end="")
print(adj_square_edge[num_edges-1][3],"];")

print("\ndensity_jam = 60;")
print("\nbandwidth_cloud = 400;")

terminator=np.zeros(num_vehicles)
num_edge_passed=np.zeros(num_vehicles)
# passed_edge_list = []
for i in range(num_vehicles):
    # passed_edges= {}
    while (num_edge_passed[i]<18):
        num_edge_passed[i] = 0
        # passed_edges = 
        path_calculation(i,start_loc_vehicles[i],velocity[i],path,K_final)
    if i < num_alter_vehicles:
        num_edge_passed[i] = 0
        while (num_edge_passed[i]<18):
            num_edge_passed[i] = 0
            k_start = random.randint(10,K_final-20)
            alter_path_calculation(i,path,k_start,K_final)
    # passed_edge_list.append(passed_edges)
# print(min(num_edge_passed))

print("\nx = [",end='')
for i in range(num_vehicles-1):
    for k in range(K_final-1):
        print(path[i][k],",",end='')
    print(path[i][K_final-1],";",end='')
for k in range(K_final-1):
    print(path[num_vehicles-1][k],",",end='')   
print(path[num_vehicles-1][K_final-1],"];")

print("\ni_velocity = ",i_velocity,";")
print("\ni_location = ",start_loc_vehicles,";")
print("\ndestination = [",end='')
for i in range(num_vehicles-1):
    print(path[i][K_final-1],",",end='')
print(path[num_vehicles-1][K_final-1],"];")

print("\nedge_edge_min = [",end='')
edge_to_square_dist = []
for j in range(num_edges-1):
    src = loc_edge[j]
    edge_to_square_dist.append(calculate_distances(src))
    for i in range(sq-1):
        print(edge_to_square_dist[j][i],",",end='')
    print(edge_to_square_dist[j][sq-1],";",end='')
src = loc_edge[num_edges-1]
edge_to_square_dist.append(calculate_distances(src))
for i in range(sq-1):
    print(edge_to_square_dist[num_edges-1][i],",",end='')
print(edge_to_square_dist[num_edges-1][sq-1],"];")

# print(passed_edge_list)


print("\n Data for old code")

print("\nN = ",num_vehicles,";")
print("\nM = ",num_edges,";")
print("\nbeta = 0.36;")
print("\nbw_edge = 10;")
print("\nmem_edge = ",mem_edge,";")
print("\nmem_occup = ",mem_proc,";")
print("\nbandwidth = ",bandwidth_edge,";")
print("\nbw_const = [",end = '')
for j in range(num_edges-1):
    print("1,",end='')
print("1];")
print("\nl_cov = ",l_cov,";")
vel_free = []
density_jam = []
density = []
for i in range(num_edges):
    vel_free.append(random.randint(20,80))
    density_jam.append(60)
    density.append(35)
print("\nvel_free = ",vel_free,";")
print("\ndensity_jam = ",density_jam,";")
print("\ndensity = ",density,";")
print("mem_app = ",mem_req,";")

print("\nx = [",end='')
for i in range(num_alter_vehicles):
    for j in range(num_edges-1):
        if j == 0:
            print("\n[",end='')
        if loc_edge[j] in alter_path[i]:
            print("1,",end='')
        else:
            print("0,",end='')
    if loc_edge[num_edges-1] in alter_path[i]:
        print("1]",end='')
    else:
        print("0]",end='')

for i in range(num_alter_vehicles, num_vehicles):
    for j in range(num_edges-1):
        if j == 0:
            print("\n[",end='')
        if loc_edge[j] in path[i]:
            print("1,",end='')
        else:
            print("0,",end='')
    if loc_edge[num_edges-1] in path[i]:
        print("1]",end='')
    else:
        print("0]",end='')
print("]")

print("\nv2e_trvtime = [",end='')
for i in range(num_alter_vehicles):
    for j in range(num_edges-1):
        if j == 0:
            print("\n[",end='')
        if loc_edge[j] in alter_path[i]:
            time = (alter_path[i].index(loc_edge[j])*5)/3600.0
            print(time,",",end='')
        else:
            print("0,",end='')
    if loc_edge[num_edges-1] in alter_path[i]:
        time = (alter_path[i].index(loc_edge[num_edges-1])*5)/3600.0
        print(time,"]",end='')
    else:
        print("0]",end='')

for i in range(num_alter_vehicles,num_vehicles):
    for j in range(num_edges-1):
        if j == 0:
            print("\n[",end='')
        if loc_edge[j] in path[i]:
            time = (path[i].index(loc_edge[j])*5)/3600.0
            print(time,",",end='')
        else:
            print("0,",end='')
    if loc_edge[num_edges-1] in path[i]:
        time = (path[i].index(loc_edge[num_edges-1])*5)/3600.0
        print(time,"]",end='')
    else:
        print("0]",end='')
print("]")   

over_set = []                 
for j in range(num_edges):
    over_set_j = []
    for k in range(K_final):
        new_over_set = []
        for i in range(num_alter_vehicles):
            if (alter_path[i][k] == loc_edge[j]):
                new_over_set.append(i)
        for i in range(num_vehicles):
            if (path[i][k] == loc_edge[j]):
                new_over_set.append(i)
        if len(new_over_set) > 0:
            over_set_j.append(new_over_set)
    over_set.append(over_set_j)

ov_set = []
new_ov_set = []
for i in range(num_vehicles):
    new_ov_set.append(0)
ov_set.append(new_ov_set)
for j in range(num_edges):
    print(len(over_set[j]))
    for k in range(len(over_set[j])):
        new_ov_set = []
        for i in range(num_vehicles):
            if(i in over_set[j][k]):
                new_ov_set.append(1)
            else:
                new_ov_set.append(0)
        ov_set.append(new_ov_set)
print(len(ov_set))

print("\nov_sets = [",end='')
for k in range(len(ov_set)-1):
    for i in range(num_vehicles-1):
        if i == 0:
            print("\n[",end='')
        print(ov_set[k][i],",",end='')
    print(ov_set[k][num_vehicles-1],"],",end='')
for i in range(num_vehicles-1):
    if i == 0:
        print("\n[",end='')
    print(ov_set[len(ov_set)-1][i],",",end='')
print(ov_set[len(ov_set)-1][num_vehicles-1],"]",end='')
print("]")
print("];") 

len_of_sets = [0,len(over_set[0])]
for i in range (1,len(over_set)):
    len_of_sets.append(len_of_sets[i]+len(over_set[i]))
    
print("\nlen_of_sets = ",len_of_sets,";")
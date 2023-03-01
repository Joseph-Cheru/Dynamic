import numpy as np
import random
# from queue import PriorityQueue
# import heapdict
import heapq

side_length = 15
num_edges = 36
num_vehicles = 400

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
    if (dist>50):
        l = location
        next_square = (int(random.choice(adj_square(l))))
        d_dist = (dist - 50)
    else:
        next_square = (location)
        d_dist = (dist)
    if(len(path)<num_vehicles):
        path.append([location])
    else:
        path[i]=[]
        path[i].append(location)
    velocity = random.randint(50,70)

    #For k>0 to K_final

    for k in range (1,K_final):

        dist = int(velocity*(5.0/18.0)*t)
        if ((dist+d_dist)>50):
            location = next_square
        if (location in loc_edge and location != path[i][-1]):
            num_edge_passed[i]+=1
        if ((dist+d_dist)>100):
            l =location
            next_possible_square =[]
            for square in (adj_square(l)):
                if square not in (path[i]):
                    next_possible_square.append(square)
            if (len(next_possible_square)==0):
                next_square =(random.choice(adj_square(l)))
            else:
                next_square =(random.choice(next_possible_square))
            d_dist =(dist + d_dist - 100)
        else:
            next_square =(location)
            d_dist = dist+d_dist
        path[i].append(location)
        if (velocity!=0):
            velocity = random.randint(50,70)



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
    l_cov.append(random.randint(6,16)/10.0)
    adj_square_edge.append(adj_square(loc_edge[j]))

start_loc_vehicles =[]
curr_loc = []
velocity = []
i_velocity = []
path =[]
mem_req = []
num_alter_vehicles = int(num_vehicles/10)
alter_path_start = []

for i in range(num_alter_vehicles):
    alter_path_start.append(random.randint(10,40))

for i in range(num_vehicles):
    start_loc_vehicles.append(random.choice(border_squares))
    curr_loc.append(start_loc_vehicles[i])
    velocity.append(random.randint(50,70))
    i_velocity.append(velocity[i])
    mem_req.append(random.randint(60,80))

k =0
t =5
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
print("\nt = 5;")       
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

for i in range(num_vehicles):
    while (num_edge_passed[i]<18):
        num_edge_passed[i] = 0
        path_calculation(i,start_loc_vehicles[i],velocity[i],path,K_final)

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


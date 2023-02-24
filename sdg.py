import numpy as np
import random
# from queue import PriorityQueue
# import heapdict
import heapq

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


side_length = int(input("Enter side length: "))
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
print(border_squares)
print(non_border_squares)
print(corner_squares)

# num_edges = int(input("Enter number of edges: "))
num_edges = 4
loc_edge = [8,11,26,29]
mem_edge = []
mem_proc = []
bandwidth_edge = []
l_cov = []


loc_edge.sort()
adj_square_edge = []
for j in range(num_edges):
    mem_edge.append(random.randint(400,500))
    mem_proc.append(random.randint(0,150))
    bandwidth_edge.append(random.randint(8,15))
    l_cov.append(random.randint(6,16)/10.0)
    adj_square_edge.append(adj_square(loc_edge[j]))

print("Edge Locations=",loc_edge)
print("Memory of Edge=",mem_edge)
print("Processing memory of Edge=",mem_proc)
print("Bandwidth of Edge=",bandwidth_edge)
print("Coverage Length of Edge = ",l_cov)
print("Adjacent Squares of Edges = ",adj_square_edge)

num_vehicles = int(input("Enter number of vehicles: "))

start_loc_vehicles =[]

curr_loc = []
velocity = []
path =[]
mem_req = []
num_alter_vehicles = int(num_vehicles/10)
alter_path_start = []

for i in range(num_alter_vehicles):
    alter_path_start.append(random.randint(10,40))

for i in range(num_vehicles):
    start_loc_vehicles.append(random.choice(border_squares))
    velocity.append(random.randint(50,70))
    curr_loc.append(int(random.choice(border_squares)))
    mem_req.append(random.randint(60,80))
print("Start Location of Vehicles =",curr_loc)
print("Initial Velocity =",velocity)
print("Requested Memory=",mem_req)

k =0
t =5
K_final = 60

terminator=np.zeros(num_vehicles)

d_dist =[]
next_square =[]
#For k=0
for i in range(num_vehicles):
    dist = int(velocity[i]*(5.0/18.0)*t)
    if (dist>50):
        l =curr_loc[i]
        next_square.append(int(random.choice(adj_square(l))))
        d_dist.append(dist - 50)

    else:
        next_square.append(curr_loc[i])
        d_dist.append(dist)
    path.append([curr_loc[i]])
    velocity[i] = random.randint(50,70)

num_edge_passed=np.zeros(num_vehicles)

#For k>0 to K_final

for k in range (1,K_final):
    for i in range(num_vehicles):

        dist = int(velocity[i]*(5.0/18.0)*t)
        if ((dist+d_dist[i])>50):
            curr_loc[i] = next_square[i]
        if (curr_loc[i] in loc_edge):
            if (velocity[i]!=0):
                num_edge_passed[i]+=1
                if (num_edge_passed[i]>=3):
                    go = random.randint(0,1)
                    if (go==0):
                        velocity[i]=0
                        d_dist[i]=0
                        dist=0
                        print("terminated",i,k)
                        terminator[i]=curr_loc[i]

        if ((dist+d_dist[i])>100):
            l =curr_loc[i]
            next_possible_square =[]
            for square in (adj_square(l)):
                if square not in (path[i]):
                    next_possible_square.append(square)
            if (len(next_possible_square)==0):
                next_square[i]=(random.choice(adj_square(l)))
            else:
                next_square[i]=(random.choice(next_possible_square))
            d_dist[i]=(dist + d_dist[i] - 100)
        else:
            next_square[i]=(curr_loc[i])
            d_dist[i]= dist+d_dist[i]
        path[i].append(curr_loc[i])
        if (velocity[i]!=0):
            velocity[i] = random.randint(50,70)

for i in range(num_vehicles):
    if (terminator[i] not in range(1,sq+1)):
        terminator[i]=curr_loc[i]

print("Path = ",path)
print("Final Velocities = ",velocity)
print("Destination = ",terminator)
                                              

edge_to_square_dist = []
for j in range(num_edges):
    src = loc_edge[j]
    edge_to_square_dist.append(calculate_distances(src))

print("Minimum number of edges in path = ",edge_to_square_dist)

#output to csv file
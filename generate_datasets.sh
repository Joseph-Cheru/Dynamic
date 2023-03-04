# bin/bash!

# This script generates the datasets for  comparing my alogrithm with the CG Heuristic algorithm
# It generates the datasets for the following parameters:
# num_edges_list=("36" "49" "64" "81" "100")
num_edges_list=("64" "81" "100")
# num_vehicles_list=("100" "200" "300" "400")
num_vehicles_list=("100")


# It does this by executing python3 sdg.py with two command line arguments (num_edges, num_vehicles)
# The output of the python script is redirected to a file in the datasets folder
# The datasets are generated in the following format: dataset_e36_v100.txt, dataset_e49_v100.txt, etc.


# check if directory datasets exists and if not create it
if [ ! -d "datasets" ]; then
    mkdir datasets
fi

# generate datasets
for num_edges in ${num_edges_list[@]}
do
    for num_vehicles in ${num_vehicles_list[@]}
    do
        python3 sdg.py $num_edges $num_vehicles > datasets/dataset_e${num_edges}_v${num_vehicles}.txt
    done
done

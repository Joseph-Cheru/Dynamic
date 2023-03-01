clear all;
clc;
tic;

N_edges =  10 ;

N_vehicles =  100 ;

loc_edge =  [16, 24, 34, 43, 45, 52, 53, 57, 68, 84] ;

mem_req =  [60, 74, 71, 78, 80, 72, 70, 80, 63, 62, 79, 72, 77, 63, 73, 79, 69, 60, 79, 77, 68, 65, 61, 60, 79, 62, 78, 77, 60, 74, 75, 70, 61, 69, 77, 69, 74, 60, 70, 75, 62, 62, 64, 69, 72, 68, 66, 60, 69, 76, 65, 70, 76, 73, 63, 68, 65, 60, 71, 69, 75, 76, 67, 65, 64, 66, 80, 60, 71, 80, 76, 72, 69, 75, 67, 76, 74, 70, 77, 64, 65, 73, 64, 63, 73, 68, 80, 72, 68, 69, 75, 66, 70, 74, 74, 62, 62, 72, 75, 60] ;

mem_edge =  [412, 427, 409, 415, 468, 462, 432, 417, 411, 443] ;

mem_proc =  [111, 81, 42, 24, 31, 127, 128, 18, 63, 131] ;

bandwidth_edge =  [11, 10, 13, 9, 14, 11, 8, 14, 12, 12] ;

l_cov =  [1.3, 1.5, 0.7, 1.3, 1.1, 1.5, 1.3, 1.5, 1.1, 0.7] ;

k_final =  60 ;

beta = 0.36;

delta = 0.36;

t = 5;

adj_square_edge = [6 ,15 ,17 ,26 ;14 ,23 ,25 ,34 ;24 ,33 ,35 ,44 ;33 ,42 ,44 ,53 ;35 ,44 ,46 ,55 ;42 ,51 ,53 ,62 ;43 ,52 ,54 ,63 ;47 ,56 ,58 ,67 ;58 ,67 ,69 ,78 ;74 ,83 ,85 ,94 ];

density_jam = 60;

bandwidth_cloud = 400;

x = [100 ,99 ,98 ,97 ,97 ,96 ,86 ,86 ,85 ,84 ,74 ,64 ,65 ,66 ,67 ,67 ,68 ,58 ,59 ,49 ,39 ,39 ,40 ,50 ,60 ,70 ,69 ,69 ,79 ,78 ,88 ,87 ,77 ,77 ,76 ,75 ,76 ,75 ,74 ,73 ,73 ,83 ,82 ,81 ,91 ,91 ,92 ,93 ,94 ,95 ,85 ,85 ,95 ,85 ,95 ,85 ,85 ,86 ,76 ,86 ;100 ,8 ,7 ,7 ,17 ,16 ,6 ,5 ,15 ,14 ,14 ,24 ,34 ,35 ,35 ,36 ,26 ,25 ,26 ,26 ,27 ,37 ,47 ,57 ,57 ,67 ,77 ,76 ,86 ,96 ,96 ,97 ,87 ,88 ,89 ,90 ,80 ,80 ,79 ,69 ,70 ,60 ,50 ,50 ,49 ,48 ,58 ,68 ,68 ,78 ,88 ,98 ,99 ,100 ,90 ,90 ,100 ,90 ,80 ,90 ;100 ,7 ,8 ,8 ,18 ,17 ,16 ,16 ,15 ,25 ,35 ,36 ,26 ,26 ,27 ,37 ,38 ,38 ,48 ,49 ,50 ,60 ,60 ,59 ,58 ,57 ,47 ,46 ,56 ,56 ,55 ,54 ,53 ,52 ,52 ,51 ,61 ,62 ,72 ,82 ,92 ,92 ,93 ,83 ,84 ,94 ,94 ,95 ,85 ,86 ,96 ,97 ,98 ,99 ,99 ,89 ,90 ,80 ,80 ,70 ;100 ,79 ,69 ,59 ,59 ,58 ,48 ,49 ,50 ,40 ,40 ,39 ,38 ,28 ,27 ,26 ,25 ,15 ,5 ,5 ,4 ,14 ,24 ,34 ,34 ,35 ,36 ,37 ,47 ,57 ,56 ,56 ,55 ,45 ,44 ,54 ,64 ,64 ,65 ,75 ,85 ,85 ,95 ,94 ,84 ,83 ,93 ,93 ,92 ,82 ,72 ,73 ,63 ,63 ,53 ,43 ,33 ,33 ,32 ,22 ;96 ,86 ,87 ,87 ,77 ,76 ,66 ,56 ,46 ,46 ,47 ,37 ,36 ,26 ,25 ,25 ,24 ,14 ,15 ,5 ,4 ,3 ,3 ,13 ,12 ,22 ,21 ,21 ,31 ,41 ,42 ,43 ,53 ,54 ,54 ,44 ,45 ,35 ,35 ,34 ,33 ,23 ,13 ,13 ,14 ,24 ,23 ,24 ,23 ,22 ,22 ,32 ,33 ,43 ,44 ,43 ,44 ,44 ,43 ,33 ;21 ,31 ,41 ,42 ,42 ,52 ,53 ,43 ,33 ,33 ,23 ,24 ,34 ,44 ,44 ,45 ,46 ,56 ,55 ,54 ,64 ,64 ,74 ,73 ,83 ,82 ,72 ,62 ,63 ,63 ,53 ,52 ,52 ,51 ,61 ,71 ,81 ,91 ,92 ,93 ,93 ,94 ,84 ,85 ,75 ,76 ,76 ,66 ,67 ,57 ,58 ,48 ,48 ,47 ,37 ,38 ,28 ,28 ,18 ,19 ;93 ,83 ,82 ,82 ,72 ,62 ,61 ,61 ,71 ,81 ,91 ,92 ,82 ,82 ,72 ,73 ,74 ,64 ,54 ,54 ,53 ,52 ,42 ,32 ,33 ,23 ,23 ,24 ,25 ,15 ,14 ,14 ,4 ,3 ,2 ,1 ,1 ,11 ,21 ,31 ,41 ,41 ,51 ,52 ,62 ,63 ,62 ,52 ,52 ,62 ,52 ,51 ,52 ,53 ,43 ,44 ,45 ,45 ,55 ,65 ;90 ,80 ,79 ,79 ,69 ,68 ,58 ,59 ,49 ,50 ,50 ,40 ,30 ,29 ,29 ,19 ,9 ,10 ,20 ,19 ,18 ,17 ,17 ,7 ,8 ,18 ,28 ,27 ,27 ,26 ,25 ,24 ,24 ,23 ,22 ,32 ,33 ,34 ,44 ,44 ,54 ,53 ,52 ,51 ,51 ,41 ,42 ,43 ,42 ,43 ,33 ,33 ,34 ,35 ,45 ,55 ,56 ,57 ,47 ,47 ;31 ,21 ,11 ,1 ,2 ,2 ,3 ,4 ,5 ,6 ,7 ,7 ,17 ,16 ,26 ,36 ,37 ,37 ,47 ,46 ,45 ,44 ,34 ,34 ,33 ,23 ,22 ,12 ,13 ,14 ,15 ,15 ,25 ,24 ,34 ,35 ,35 ,34 ,35 ,34 ,35 ,34 ,34 ,24 ,25 ,35 ,25 ,25 ,15 ,25 ,15 ,25 ,15 ,15 ,25 ,15 ,16 ,26 ,27 ,28 ;9 ,8 ,8 ,7 ,17 ,16 ,26 ,36 ,46 ,56 ,56 ,55 ,45 ,44 ,43 ,43 ,42 ,52 ,51 ,41 ,31 ,32 ,32 ,22 ,12 ,13 ,23 ,24 ,24 ,25 ,35 ,34 ,33 ,34 ,34 ,44 ,54 ,53 ,63 ,62 ,72 ,72 ,82 ,83 ,84 ,94 ,93 ,92 ,91 ,91 ,81 ,71 ,61 ,61 ,51 ,52 ,62 ,61 ,62 ,62 ;61 ,71 ,72 ,72 ,62 ,52 ,42 ,43 ,43 ,44 ,34 ,35 ,45 ,46 ,46 ,47 ,57 ,56 ,55 ,65 ,65 ,64 ,74 ,75 ,85 ,84 ,84 ,83 ,73 ,63 ,53 ,54 ,54 ,44 ,43 ,33 ,32 ,22 ,22 ,12 ,11 ,1 ,2 ,3 ,3 ,4 ,14 ,13 ,23 ,23 ,24 ,25 ,15 ,16 ,16 ,17 ,18 ,8 ,9 ,19 ;4 ,3 ,2 ,2 ,12 ,22 ,23 ,33 ,33 ,32 ,31 ,41 ,42 ,43 ,44 ,44 ,34 ,35 ,45 ,55 ,54 ,54 ,64 ,74 ,84 ,85 ,95 ,95 ,94 ,93 ,92 ,91 ,81 ,81 ,82 ,83 ,73 ,72 ,72 ,62 ,52 ,53 ,63 ,62 ,61 ,51 ,51 ,41 ,51 ,41 ,51 ,52 ,52 ,53 ,43 ,42 ,42 ,43 ,33 ,32 ;7 ,6 ,16 ,16 ,26 ,25 ,24 ,34 ,33 ,33 ,43 ,42 ,32 ,31 ,41 ,41 ,51 ,52 ,53 ,53 ,63 ,73 ,74 ,75 ,76 ,76 ,77 ,87 ,86 ,85 ,84 ,84 ,94 ,93 ,83 ,82 ,92 ,91 ,91 ,81 ,71 ,72 ,62 ,61 ,61 ,51 ,52 ,42 ,43 ,43 ,44 ,54 ,55 ,65 ,64 ,74 ,84 ,83 ,83 ,84 ;70 ,69 ,59 ,58 ,58 ,57 ,56 ,66 ,65 ,64 ,64 ,54 ,53 ,52 ,62 ,61 ,51 ,41 ,41 ,42 ,43 ,44 ,45 ,45 ,35 ,25 ,24 ,23 ,23 ,13 ,3 ,2 ,12 ,11 ,11 ,21 ,31 ,32 ,22 ,32 ,32 ,33 ,34 ,33 ,32 ,33 ,34 ,33 ,34 ,34 ,24 ,14 ,4 ,5 ,6 ,6 ,16 ,26 ,27 ,27 ;97 ,98 ,88 ,88 ,78 ,68 ,58 ,58 ,57 ,67 ,66 ,66 ,65 ,75 ,74 ,74 ,73 ,83 ,84 ,94 ,95 ,95 ,96 ,86 ,85 ,85 ,84 ,85 ,84 ,74 ,64 ,64 ,63 ,53 ,43 ,42 ,52 ,52 ,62 ,61 ,51 ,41 ,41 ,31 ,32 ,33 ,34 ,35 ,45 ,45 ,44 ,54 ,55 ,56 ,56 ,46 ,47 ,37 ,38 ,39 ;80 ,70 ,69 ,69 ,79 ,78 ,68 ,67 ,67 ,57 ,56 ,55 ,65 ,65 ,66 ,76 ,86 ,96 ,96 ,97 ,87 ,77 ,76 ,75 ,85 ,95 ,94 ,94 ,84 ,74 ,73 ,72 ,71 ,71 ,61 ,51 ,52 ,52 ,42 ,43 ,53 ,63 ,62 ,62 ,52 ,53 ,54 ,44 ,34 ,35 ,35 ,45 ,46 ,36 ,26 ,16 ,16 ,15 ,25 ,24 ;9 ,8 ,7 ,7 ,6 ,5 ,15 ,16 ,26 ,26 ,27 ,37 ,38 ,48 ,58 ,58 ,57 ,67 ,66 ,56 ,55 ,65 ,75 ,74 ,73 ,73 ,72 ,62 ,61 ,51 ,52 ,52 ,53 ,43 ,44 ,34 ,33 ,33 ,32 ,22 ,12 ,13 ,13 ,14 ,24 ,23 ,33 ,33 ,32 ,31 ,41 ,41 ,42 ,43 ,53 ,63 ,63 ,64 ,54 ,53 ;3 ,4 ,14 ,14 ,24 ,25 ,26 ,36 ,35 ,35 ,34 ,44 ,45 ,46 ,47 ,47 ,37 ,27 ,17 ,18 ,18 ,28 ,29 ,19 ,19 ,9 ,8 ,7 ,7 ,6 ,5 ,15 ,16 ,17 ,16 ,15 ,15 ,16 ,6 ,7 ,6 ,6 ,7 ,17 ,7 ,17 ,16 ,16 ,15 ,16 ,6 ,5 ,5 ,15 ,16 ,15 ,16 ,16 ,15 ,5 ;2 ,12 ,12 ,11 ,21 ,22 ,23 ,24 ,24 ,25 ,35 ,45 ,55 ,55 ,65 ,75 ,76 ,77 ,78 ,68 ,68 ,58 ,57 ,56 ,56 ,66 ,67 ,68 ,69 ,79 ,89 ,89 ,99 ,98 ,97 ,96 ,86 ,85 ,84 ,84 ,74 ,73 ,72 ,62 ,52 ,52 ,42 ,43 ,53 ,63 ,64 ,64 ,54 ,44 ,34 ,33 ,33 ,32 ,31 ,41 ;99 ,89 ,88 ,87 ,87 ,86 ,76 ,75 ,75 ,65 ,55 ,45 ,44 ,54 ,53 ,52 ,51 ,41 ,41 ,42 ,32 ,22 ,22 ,12 ,13 ,23 ,24 ,25 ,25 ,26 ,16 ,17 ,27 ,37 ,47 ,57 ,57 ,56 ,46 ,36 ,35 ,35 ,34 ,33 ,43 ,53 ,53 ,63 ,73 ,74 ,84 ,83 ,93 ,92 ,92 ,82 ,72 ,71 ,61 ,61 ;51 ,41 ,41 ,42 ,52 ,53 ,63 ,64 ,64 ,74 ,84 ,94 ,93 ,92 ,82 ,82 ,72 ,73 ,83 ,93 ,93 ,83 ,73 ,72 ,72 ,71 ,61 ,62 ,63 ,63 ,53 ,43 ,33 ,34 ,35 ,36 ,36 ,46 ,45 ,55 ,54 ,44 ,44 ,34 ,24 ,14 ,15 ,16 ,17 ,17 ,27 ,37 ,47 ,57 ,67 ,66 ,76 ,76 ,86 ,85 ;94 ,84 ,74 ,74 ,73 ,63 ,62 ,72 ,72 ,82 ,83 ,93 ,92 ,91 ,91 ,81 ,71 ,61 ,51 ,52 ,52 ,53 ,43 ,33 ,34 ,44 ,45 ,45 ,55 ,56 ,57 ,57 ,67 ,66 ,76 ,75 ,75 ,65 ,64 ,54 ,53 ,53 ,43 ,42 ,32 ,22 ,23 ,23 ,24 ,25 ,35 ,36 ,37 ,37 ,27 ,28 ,18 ,17 ,17 ,7 ;50 ,49 ,59 ,69 ,69 ,68 ,67 ,77 ,76 ,76 ,66 ,56 ,46 ,45 ,35 ,36 ,36 ,37 ,38 ,48 ,58 ,58 ,57 ,47 ,57 ,56 ,55 ,55 ,65 ,75 ,74 ,73 ,73 ,63 ,53 ,52 ,62 ,61 ,61 ,51 ,41 ,42 ,43 ,33 ,33 ,23 ,13 ,14 ,15 ,25 ,24 ,24 ,34 ,44 ,54 ,64 ,74 ,74 ,84 ,85 ;4 ,3 ,13 ,13 ,12 ,11 ,1 ,2 ,3 ,3 ,2 ,1 ,2 ,12 ,12 ,22 ,32 ,42 ,43 ,44 ,44 ,54 ,55 ,65 ,66 ,67 ,67 ,57 ,47 ,46 ,46 ,45 ,35 ,34 ,33 ,23 ,24 ,14 ,14 ,15 ,5 ,6 ,16 ,17 ,27 ,27 ,37 ,36 ,26 ,25 ,25 ,24 ,14 ,24 ,34 ,35 ,45 ,35 ,35 ,25 ;9 ,8 ,7 ,17 ,17 ,16 ,15 ,5 ,6 ,6 ,16 ,26 ,25 ,24 ,14 ,14 ,13 ,23 ,22 ,21 ,31 ,41 ,41 ,51 ,52 ,53 ,43 ,33 ,34 ,35 ,45 ,45 ,44 ,54 ,64 ,63 ,63 ,73 ,74 ,84 ,83 ,93 ,94 ,94 ,95 ,96 ,86 ,76 ,77 ,77 ,67 ,68 ,78 ,79 ,89 ,88 ,88 ,98 ,97 ,87 ;8 ,7 ,17 ,16 ,6 ,6 ,5 ,4 ,3 ,13 ,12 ,12 ,2 ,1 ,11 ,21 ,31 ,41 ,41 ,51 ,52 ,53 ,54 ,55 ,55 ,45 ,35 ,36 ,26 ,25 ,24 ,34 ,33 ,33 ,23 ,22 ,32 ,42 ,42 ,43 ,44 ,43 ,33 ,33 ,34 ,24 ,14 ,15 ,15 ,16 ,15 ,16 ,26 ,27 ,28 ,29 ,39 ,39 ,49 ,48 ;30 ,20 ,10 ,10 ,9 ,8 ,7 ,17 ,27 ,27 ,37 ,36 ,26 ,16 ,6 ,5 ,5 ,4 ,3 ,13 ,12 ,22 ,23 ,24 ,24 ,25 ,15 ,14 ,24 ,24 ,34 ,44 ,45 ,55 ,54 ,54 ,53 ,52 ,42 ,41 ,31 ,31 ,32 ,33 ,43 ,44 ,34 ,35 ,35 ,25 ,15 ,25 ,25 ,24 ,34 ,33 ,33 ,34 ,33 ,32 ;8 ,7 ,17 ,17 ,16 ,26 ,36 ,37 ,27 ,28 ,38 ,38 ,48 ,58 ,68 ,68 ,67 ,66 ,65 ,64 ,64 ,74 ,84 ,83 ,73 ,63 ,62 ,62 ,61 ,51 ,41 ,42 ,32 ,32 ,31 ,21 ,22 ,23 ,24 ,25 ,25 ,35 ,34 ,33 ,43 ,44 ,44 ,45 ,55 ,54 ,53 ,52 ,52 ,53 ,43 ,43 ,44 ,45 ,46 ,47 ;70 ,69 ,68 ,67 ,67 ,77 ,76 ,75 ,65 ,55 ,56 ,56 ,66 ,56 ,57 ,47 ,37 ,38 ,28 ,28 ,27 ,26 ,25 ,25 ,35 ,36 ,46 ,45 ,44 ,54 ,54 ,53 ,63 ,63 ,73 ,72 ,62 ,61 ,51 ,51 ,52 ,42 ,41 ,31 ,32 ,32 ,33 ,43 ,33 ,23 ,13 ,14 ,24 ,24 ,34 ,44 ,43 ,53 ,63 ,64 ;93 ,83 ,73 ,73 ,74 ,84 ,85 ,75 ,76 ,66 ,66 ,67 ,57 ,56 ,56 ,46 ,36 ,35 ,45 ,55 ,55 ,65 ,64 ,63 ,62 ,61 ,51 ,41 ,41 ,31 ,32 ,42 ,43 ,53 ,52 ,52 ,53 ,54 ,44 ,34 ,34 ,33 ,23 ,24 ,14 ,14 ,13 ,12 ,22 ,21 ,11 ,11 ,1 ,2 ,3 ,4 ,5 ,5 ,6 ,16 ;40 ,39 ,49 ,50 ,60 ,60 ,59 ,69 ,68 ,67 ,67 ,57 ,47 ,37 ,36 ,35 ,25 ,25 ,24 ,34 ,33 ,43 ,42 ,42 ,52 ,51 ,61 ,62 ,63 ,63 ,53 ,54 ,44 ,45 ,55 ,56 ,46 ,46 ,45 ,46 ,36 ,36 ,26 ,16 ,6 ,5 ,5 ,15 ,14 ,4 ,3 ,2 ,1 ,11 ,11 ,21 ,22 ,32 ,31 ,41 ;4 ,3 ,2 ,2 ,12 ,13 ,23 ,22 ,21 ,21 ,11 ,1 ,11 ,12 ,12 ,11 ,21 ,31 ,31 ,32 ,42 ,43 ,44 ,45 ,55 ,55 ,54 ,64 ,63 ,73 ,72 ,72 ,71 ,61 ,62 ,52 ,53 ,53 ,54 ,44 ,34 ,33 ,43 ,33 ,33 ,34 ,35 ,25 ,15 ,14 ,14 ,24 ,34 ,44 ,34 ,24 ,24 ,23 ,13 ,12 ;7 ,17 ,18 ,18 ,8 ,9 ,10 ,10 ,20 ,30 ,40 ,39 ,39 ,29 ,28 ,38 ,37 ,37 ,27 ,26 ,16 ,15 ,5 ,5 ,6 ,16 ,26 ,25 ,25 ,24 ,14 ,13 ,23 ,33 ,33 ,43 ,42 ,52 ,53 ,54 ,54 ,44 ,45 ,35 ,35 ,34 ,44 ,43 ,53 ,63 ,73 ,73 ,83 ,84 ,74 ,64 ,65 ,65 ,55 ,56 ;31 ,41 ,51 ,52 ,52 ,42 ,43 ,33 ,32 ,22 ,22 ,23 ,24 ,14 ,4 ,4 ,5 ,15 ,16 ,17 ,27 ,27 ,28 ,38 ,37 ,47 ,47 ,57 ,56 ,66 ,67 ,67 ,68 ,58 ,59 ,69 ,79 ,78 ,78 ,77 ,76 ,86 ,86 ,85 ,75 ,74 ,64 ,63 ,53 ,53 ,54 ,55 ,45 ,35 ,34 ,44 ,45 ,45 ,46 ,36 ;94 ,93 ,83 ,84 ,84 ,85 ,75 ,76 ,66 ,56 ,56 ,55 ,45 ,35 ,25 ,15 ,14 ,13 ,13 ,12 ,11 ,21 ,22 ,32 ,31 ,41 ,41 ,51 ,52 ,42 ,43 ,43 ,33 ,23 ,24 ,34 ,44 ,44 ,54 ,53 ,53 ,63 ,73 ,72 ,71 ,61 ,62 ,62 ,52 ,53 ,52 ,53 ,63 ,63 ,64 ,74 ,64 ,65 ,64 ,65 ;3 ,13 ,23 ,23 ,33 ,34 ,24 ,14 ,15 ,15 ,16 ,26 ,25 ,25 ,35 ,45 ,55 ,54 ,44 ,43 ,53 ,53 ,52 ,62 ,72 ,82 ,83 ,84 ,84 ,74 ,64 ,63 ,73 ,73 ,83 ,93 ,92 ,91 ,91 ,81 ,71 ,61 ,51 ,41 ,41 ,31 ,32 ,42 ,43 ,43 ,53 ,52 ,53 ,43 ,53 ,53 ,63 ,73 ,83 ,93 ;100 ,90 ,89 ,88 ,88 ,78 ,68 ,69 ,59 ,59 ,60 ,70 ,80 ,80 ,79 ,89 ,99 ,98 ,97 ,87 ,87 ,77 ,67 ,57 ,57 ,56 ,46 ,45 ,35 ,35 ,34 ,44 ,54 ,54 ,55 ,65 ,75 ,74 ,84 ,84 ,83 ,73 ,72 ,71 ,71 ,61 ,62 ,52 ,42 ,32 ,33 ,43 ,43 ,53 ,63 ,64 ,54 ,54 ,53 ,52 ;97 ,96 ,86 ,85 ,84 ,84 ,94 ,95 ,85 ,75 ,74 ,74 ,64 ,54 ,55 ,45 ,44 ,44 ,43 ,33 ,32 ,31 ,41 ,41 ,42 ,52 ,51 ,51 ,61 ,71 ,81 ,82 ,72 ,62 ,62 ,63 ,53 ,54 ,53 ,52 ,52 ,53 ,52 ,51 ,61 ,61 ,71 ,72 ,73 ,83 ,83 ,93 ,92 ,91 ,92 ,93 ,93 ,94 ,84 ,83 ;8 ,7 ,7 ,17 ,16 ,15 ,14 ,14 ,24 ,34 ,35 ,35 ,45 ,44 ,43 ,53 ,54 ,64 ,65 ,65 ,55 ,56 ,57 ,47 ,48 ,48 ,38 ,37 ,27 ,26 ,36 ,46 ,46 ,47 ,46 ,45 ,46 ,46 ,45 ,35 ,25 ,26 ,36 ,36 ,26 ,25 ,24 ,23 ,23 ,22 ,21 ,11 ,1 ,2 ,12 ,12 ,13 ,3 ,4 ,5 ;10 ,9 ,8 ,18 ,19 ,19 ,20 ,30 ,29 ,28 ,38 ,38 ,39 ,49 ,48 ,47 ,37 ,36 ,35 ,35 ,34 ,24 ,14 ,4 ,5 ,15 ,15 ,16 ,17 ,7 ,6 ,6 ,16 ,26 ,25 ,24 ,24 ,23 ,33 ,32 ,31 ,41 ,41 ,42 ,52 ,53 ,63 ,62 ,62 ,61 ,51 ,52 ,52 ,53 ,43 ,44 ,54 ,55 ,55 ,65 ;50 ,40 ,39 ,49 ,49 ,59 ,69 ,68 ,67 ,57 ,57 ,56 ,66 ,76 ,77 ,78 ,88 ,88 ,98 ,97 ,87 ,86 ,85 ,75 ,75 ,65 ,64 ,54 ,53 ,53 ,52 ,42 ,43 ,33 ,33 ,34 ,24 ,14 ,15 ,16 ,16 ,6 ,5 ,4 ,3 ,13 ,23 ,22 ,22 ,21 ,31 ,32 ,33 ,34 ,35 ,35 ,45 ,46 ,47 ,48 ;91 ,92 ,93 ,93 ,83 ,73 ,74 ,75 ,85 ,95 ,95 ,94 ,84 ,74 ,64 ,54 ,54 ,55 ,45 ,44 ,34 ,33 ,32 ,31 ,31 ,41 ,51 ,61 ,71 ,81 ,82 ,82 ,72 ,62 ,52 ,42 ,43 ,53 ,53 ,63 ,53 ,54 ,44 ,45 ,45 ,35 ,36 ,46 ,56 ,66 ,66 ,67 ,68 ,58 ,57 ,47 ,48 ,38 ,38 ,28 ;100 ,99 ,89 ,90 ,80 ,70 ,70 ,69 ,79 ,78 ,88 ,88 ,98 ,97 ,96 ,96 ,95 ,85 ,75 ,74 ,84 ,84 ,83 ,73 ,72 ,62 ,52 ,53 ,53 ,63 ,64 ,65 ,65 ,66 ,67 ,68 ,58 ,57 ,57 ,47 ,46 ,56 ,55 ,45 ,45 ,35 ,34 ,33 ,43 ,44 ,44 ,54 ,64 ,63 ,53 ,52 ,52 ,42 ,41 ,31 ;60 ,59 ,69 ,69 ,79 ,78 ,77 ,67 ,66 ,56 ,56 ,57 ,47 ,46 ,36 ,26 ,16 ,16 ,6 ,5 ,15 ,25 ,24 ,24 ,23 ,33 ,34 ,34 ,44 ,43 ,53 ,52 ,51 ,51 ,61 ,62 ,63 ,73 ,73 ,83 ,93 ,94 ,84 ,84 ,85 ,86 ,76 ,75 ,74 ,74 ,64 ,65 ,55 ,54 ,53 ,43 ,43 ,42 ,41 ,31 ;97 ,87 ,87 ,77 ,67 ,68 ,69 ,69 ,70 ,80 ,79 ,89 ,99 ,98 ,98 ,88 ,78 ,68 ,58 ,59 ,59 ,60 ,50 ,49 ,48 ,47 ,47 ,57 ,56 ,66 ,76 ,76 ,75 ,74 ,64 ,54 ,54 ,55 ,45 ,35 ,35 ,34 ,33 ,43 ,42 ,42 ,52 ,62 ,63 ,53 ,54 ,44 ,44 ,43 ,33 ,23 ,13 ,13 ,14 ,24 ;90 ,80 ,70 ,60 ,60 ,50 ,49 ,39 ,39 ,38 ,37 ,36 ,46 ,56 ,56 ,55 ,45 ,44 ,54 ,53 ,53 ,43 ,42 ,41 ,51 ,51 ,52 ,62 ,63 ,73 ,72 ,71 ,61 ,61 ,62 ,52 ,62 ,52 ,52 ,42 ,32 ,33 ,23 ,23 ,24 ,34 ,35 ,35 ,25 ,26 ,16 ,6 ,5 ,5 ,4 ,14 ,15 ,16 ,17 ,18 ;6 ,16 ,17 ,27 ,27 ,26 ,25 ,15 ,14 ,24 ,24 ,34 ,44 ,43 ,42 ,41 ,41 ,51 ,52 ,53 ,63 ,63 ,62 ,72 ,82 ,83 ,83 ,84 ,94 ,95 ,85 ,75 ,75 ,65 ,66 ,67 ,68 ,69 ,59 ,60 ,60 ,50 ,49 ,39 ,29 ,28 ,28 ,38 ,48 ,58 ,57 ,57 ,56 ,46 ,45 ,45 ,35 ,36 ,37 ,47 ;80 ,70 ,70 ,60 ,50 ,49 ,59 ,58 ,58 ,57 ,47 ,46 ,36 ,26 ,26 ,27 ,28 ,29 ,19 ,20 ,10 ,9 ,8 ,8 ,7 ,6 ,16 ,15 ,15 ,25 ,35 ,34 ,24 ,14 ,14 ,4 ,5 ,6 ,6 ,16 ,17 ,18 ,17 ,17 ,16 ,6 ,7 ,6 ,16 ,16 ,6 ,16 ,15 ,16 ,6 ,7 ,7 ,6 ,16 ,17 ;98 ,88 ,78 ,68 ,67 ,67 ,66 ,56 ,46 ,47 ,47 ,37 ,27 ,26 ,16 ,6 ,6 ,5 ,4 ,3 ,2 ,1 ,11 ,11 ,21 ,22 ,23 ,13 ,13 ,12 ,11 ,21 ,31 ,32 ,33 ,43 ,43 ,53 ,54 ,55 ,45 ,45 ,35 ,36 ,46 ,45 ,45 ,44 ,34 ,24 ,25 ,25 ,15 ,14 ,24 ,24 ,23 ,33 ,34 ,24 ;81 ,71 ,71 ,61 ,51 ,52 ,53 ,54 ,55 ,45 ,45 ,44 ,43 ,33 ,23 ,24 ,25 ,25 ,35 ,34 ,24 ,14 ,4 ,4 ,5 ,6 ,7 ,8 ,18 ,17 ,17 ,16 ,15 ,16 ,26 ,26 ,27 ,28 ,38 ,37 ,36 ,46 ,46 ,56 ,57 ,47 ,48 ,48 ,58 ,68 ,78 ,79 ,89 ,89 ,90 ,100 ,99 ,98 ,98 ,88 ;6 ,7 ,17 ,17 ,27 ,37 ,47 ,57 ,56 ,56 ,46 ,45 ,55 ,54 ,64 ,64 ,63 ,62 ,61 ,51 ,51 ,52 ,42 ,32 ,33 ,43 ,43 ,44 ,34 ,24 ,23 ,22 ,21 ,21 ,11 ,1 ,2 ,2 ,3 ,13 ,14 ,4 ,4 ,5 ,15 ,16 ,26 ,26 ,36 ,35 ,25 ,25 ,35 ,34 ,33 ,33 ,43 ,53 ,43 ,42 ;40 ,50 ,50 ,49 ,39 ,29 ,19 ,19 ,9 ,8 ,18 ,17 ,16 ,6 ,7 ,7 ,17 ,27 ,26 ,36 ,46 ,46 ,45 ,35 ,25 ,24 ,14 ,14 ,4 ,5 ,15 ,25 ,25 ,24 ,34 ,33 ,23 ,22 ,22 ,21 ,31 ,41 ,42 ,42 ,43 ,53 ,63 ,62 ,61 ,61 ,51 ,52 ,53 ,54 ,44 ,45 ,45 ,55 ,56 ,57 ;60 ,50 ,49 ,49 ,59 ,69 ,79 ,79 ,78 ,68 ,58 ,48 ,48 ,47 ,46 ,36 ,35 ,34 ,34 ,33 ,32 ,22 ,21 ,31 ,41 ,41 ,51 ,61 ,62 ,63 ,64 ,64 ,65 ,55 ,54 ,53 ,43 ,43 ,42 ,52 ,42 ,52 ,42 ,52 ,53 ,53 ,43 ,44 ,45 ,44 ,34 ,34 ,24 ,25 ,15 ,14 ,4 ,3 ,3 ,2 ;31 ,32 ,42 ,52 ,52 ,53 ,54 ,55 ,56 ,56 ,57 ,67 ,68 ,68 ,58 ,48 ,38 ,39 ,39 ,29 ,28 ,18 ,8 ,8 ,7 ,17 ,27 ,37 ,47 ,47 ,46 ,45 ,44 ,44 ,43 ,33 ,34 ,35 ,36 ,36 ,26 ,16 ,15 ,14 ,13 ,13 ,23 ,24 ,25 ,24 ,14 ,14 ,4 ,5 ,6 ,16 ,26 ,26 ,16 ,26 ;98 ,88 ,78 ,68 ,69 ,69 ,79 ,80 ,70 ,60 ,59 ,59 ,58 ,48 ,47 ,46 ,36 ,35 ,45 ,45 ,44 ,34 ,24 ,23 ,22 ,22 ,32 ,33 ,43 ,42 ,41 ,41 ,51 ,52 ,62 ,63 ,53 ,53 ,54 ,64 ,65 ,66 ,56 ,56 ,55 ,45 ,44 ,45 ,45 ,55 ,54 ,53 ,54 ,64 ,64 ,74 ,75 ,76 ,76 ,86 ;90 ,100 ,99 ,99 ,98 ,88 ,87 ,77 ,77 ,78 ,68 ,67 ,66 ,65 ,64 ,64 ,74 ,84 ,94 ,93 ,92 ,92 ,82 ,72 ,62 ,61 ,61 ,71 ,81 ,91 ,92 ,82 ,82 ,83 ,73 ,63 ,53 ,54 ,54 ,44 ,43 ,33 ,32 ,32 ,31 ,41 ,42 ,52 ,52 ,51 ,52 ,53 ,54 ,55 ,45 ,45 ,35 ,34 ,24 ,25 ;50 ,40 ,39 ,39 ,49 ,48 ,47 ,37 ,27 ,26 ,26 ,16 ,15 ,25 ,24 ,34 ,34 ,35 ,36 ,46 ,45 ,44 ,44 ,54 ,53 ,43 ,42 ,42 ,41 ,51 ,52 ,62 ,62 ,63 ,64 ,74 ,73 ,73 ,83 ,82 ,81 ,71 ,72 ,72 ,71 ,61 ,51 ,52 ,52 ,53 ,43 ,33 ,32 ,22 ,22 ,12 ,13 ,14 ,4 ,4 ;41 ,51 ,52 ,52 ,42 ,32 ,33 ,23 ,13 ,13 ,14 ,4 ,3 ,2 ,12 ,12 ,11 ,1 ,11 ,21 ,22 ,22 ,32 ,31 ,21 ,31 ,32 ,22 ,23 ,24 ,34 ,34 ,35 ,45 ,46 ,36 ,36 ,26 ,16 ,15 ,15 ,25 ,24 ,23 ,24 ,25 ,25 ,24 ,14 ,24 ,25 ,24 ,24 ,23 ,22 ,21 ,31 ,41 ,41 ,51 ;8 ,18 ,17 ,17 ,16 ,6 ,5 ,4 ,4 ,14 ,13 ,23 ,33 ,34 ,24 ,24 ,25 ,15 ,16 ,16 ,26 ,27 ,37 ,36 ,36 ,35 ,45 ,46 ,46 ,47 ,48 ,49 ,59 ,60 ,70 ,69 ,69 ,68 ,58 ,57 ,56 ,55 ,55 ,54 ,44 ,43 ,43 ,42 ,52 ,53 ,63 ,64 ,74 ,75 ,75 ,65 ,66 ,67 ,77 ,77 ;40 ,39 ,49 ,49 ,50 ,60 ,59 ,59 ,69 ,79 ,80 ,90 ,90 ,89 ,88 ,78 ,77 ,77 ,67 ,68 ,58 ,57 ,56 ,56 ,55 ,45 ,35 ,34 ,34 ,24 ,23 ,13 ,12 ,22 ,32 ,33 ,43 ,43 ,42 ,41 ,51 ,52 ,62 ,62 ,72 ,82 ,83 ,73 ,73 ,74 ,75 ,65 ,64 ,54 ,54 ,53 ,63 ,53 ,53 ,52 ;95 ,85 ,85 ,86 ,76 ,75 ,75 ,74 ,64 ,54 ,53 ,52 ,42 ,42 ,43 ,33 ,23 ,22 ,21 ,31 ,31 ,41 ,51 ,61 ,71 ,71 ,72 ,73 ,63 ,62 ,52 ,52 ,62 ,52 ,51 ,61 ,62 ,52 ,52 ,53 ,43 ,44 ,45 ,55 ,56 ,56 ,66 ,67 ,57 ,47 ,48 ,48 ,49 ,59 ,69 ,70 ,70 ,60 ,50 ,40 ;3 ,13 ,23 ,33 ,33 ,43 ,53 ,54 ,44 ,44 ,34 ,35 ,25 ,25 ,24 ,14 ,4 ,5 ,5 ,6 ,16 ,15 ,14 ,13 ,12 ,12 ,11 ,21 ,22 ,32 ,31 ,41 ,42 ,42 ,52 ,62 ,61 ,51 ,41 ,41 ,42 ,32 ,42 ,32 ,32 ,33 ,43 ,44 ,45 ,45 ,46 ,56 ,57 ,58 ,68 ,67 ,67 ,77 ,87 ,88 ;7 ,8 ,9 ,9 ,19 ,29 ,39 ,40 ,50 ,50 ,49 ,59 ,58 ,48 ,48 ,38 ,37 ,36 ,46 ,56 ,66 ,67 ,67 ,57 ,47 ,46 ,45 ,45 ,55 ,54 ,64 ,74 ,74 ,84 ,83 ,73 ,72 ,72 ,71 ,61 ,51 ,41 ,42 ,42 ,52 ,53 ,63 ,63 ,62 ,52 ,51 ,52 ,53 ,53 ,43 ,44 ,34 ,24 ,24 ,14 ;60 ,59 ,69 ,79 ,78 ,78 ,68 ,58 ,48 ,47 ,57 ,57 ,67 ,66 ,65 ,75 ,75 ,76 ,86 ,96 ,95 ,95 ,94 ,84 ,74 ,64 ,63 ,63 ,62 ,52 ,53 ,43 ,42 ,42 ,32 ,33 ,34 ,24 ,25 ,25 ,26 ,16 ,6 ,5 ,5 ,15 ,14 ,13 ,3 ,2 ,12 ,12 ,22 ,23 ,33 ,43 ,44 ,44 ,54 ,55 ;30 ,40 ,50 ,60 ,60 ,59 ,58 ,48 ,47 ,37 ,37 ,36 ,35 ,45 ,45 ,55 ,65 ,75 ,74 ,74 ,64 ,63 ,62 ,52 ,51 ,51 ,41 ,42 ,32 ,33 ,43 ,53 ,53 ,54 ,44 ,34 ,24 ,23 ,23 ,22 ,21 ,31 ,41 ,42 ,42 ,43 ,33 ,43 ,44 ,44 ,43 ,44 ,34 ,34 ,35 ,25 ,26 ,27 ,27 ,28 ;30 ,20 ,19 ,18 ,18 ,17 ,27 ,26 ,36 ,46 ,45 ,45 ,44 ,34 ,24 ,24 ,23 ,13 ,3 ,4 ,5 ,5 ,6 ,16 ,15 ,25 ,25 ,35 ,34 ,33 ,43 ,42 ,41 ,41 ,51 ,52 ,53 ,54 ,54 ,64 ,63 ,73 ,74 ,74 ,75 ,65 ,55 ,55 ,56 ,57 ,67 ,68 ,68 ,69 ,79 ,78 ,88 ,88 ,89 ,90 ;70 ,60 ,59 ,59 ,69 ,68 ,67 ,57 ,57 ,56 ,55 ,65 ,75 ,85 ,85 ,84 ,74 ,73 ,72 ,82 ,92 ,92 ,91 ,81 ,71 ,61 ,51 ,41 ,42 ,32 ,32 ,22 ,23 ,13 ,3 ,3 ,4 ,14 ,15 ,16 ,16 ,26 ,36 ,46 ,45 ,35 ,35 ,34 ,33 ,43 ,53 ,53 ,52 ,62 ,63 ,64 ,54 ,54 ,44 ,43 ;6 ,16 ,26 ,25 ,25 ,35 ,45 ,55 ,54 ,54 ,53 ,43 ,42 ,52 ,52 ,62 ,61 ,51 ,51 ,41 ,31 ,32 ,33 ,34 ,34 ,24 ,23 ,13 ,3 ,3 ,4 ,14 ,15 ,5 ,5 ,4 ,3 ,2 ,1 ,1 ,11 ,12 ,22 ,21 ,21 ,31 ,32 ,33 ,43 ,44 ,44 ,45 ,46 ,56 ,56 ,57 ,67 ,77 ,78 ,88 ;10 ,20 ,20 ,30 ,40 ,39 ,38 ,38 ,37 ,36 ,46 ,45 ,45 ,35 ,34 ,33 ,43 ,53 ,53 ,54 ,44 ,45 ,45 ,55 ,56 ,57 ,58 ,48 ,48 ,49 ,50 ,60 ,70 ,69 ,69 ,59 ,58 ,68 ,67 ,67 ,77 ,87 ,88 ,89 ,89 ,79 ,78 ,68 ,69 ,68 ,58 ,58 ,59 ,69 ,68 ,58 ,68 ,69 ,59 ,59 ;81 ,71 ,72 ,82 ,82 ,83 ,73 ,63 ,62 ,62 ,61 ,51 ,52 ,53 ,53 ,43 ,44 ,34 ,35 ,35 ,45 ,46 ,56 ,66 ,67 ,67 ,57 ,47 ,48 ,49 ,49 ,39 ,29 ,28 ,18 ,18 ,19 ,9 ,8 ,7 ,6 ,6 ,16 ,26 ,36 ,36 ,37 ,27 ,17 ,7 ,17 ,17 ,16 ,15 ,14 ,24 ,24 ,25 ,35 ,34 ;98 ,97 ,87 ,87 ,77 ,67 ,68 ,58 ,57 ,47 ,47 ,46 ,45 ,55 ,56 ,66 ,66 ,65 ,64 ,63 ,62 ,72 ,82 ,92 ,92 ,91 ,81 ,71 ,61 ,51 ,51 ,41 ,42 ,52 ,53 ,43 ,33 ,32 ,32 ,22 ,23 ,24 ,25 ,25 ,26 ,36 ,35 ,34 ,34 ,44 ,54 ,55 ,45 ,44 ,44 ,54 ,55 ,45 ,55 ,54 ;5 ,6 ,16 ,17 ,17 ,7 ,8 ,18 ,19 ,9 ,9 ,10 ,20 ,30 ,40 ,50 ,49 ,49 ,39 ,29 ,28 ,38 ,38 ,48 ,58 ,68 ,68 ,67 ,57 ,47 ,37 ,27 ,27 ,26 ,36 ,35 ,25 ,24 ,23 ,33 ,33 ,32 ,42 ,43 ,44 ,45 ,55 ,55 ,56 ,46 ,45 ,35 ,35 ,34 ,35 ,45 ,35 ,34 ,34 ,44 ;7 ,17 ,16 ,16 ,6 ,5 ,4 ,3 ,2 ,2 ,12 ,13 ,14 ,24 ,23 ,23 ,22 ,32 ,31 ,41 ,42 ,42 ,52 ,62 ,63 ,64 ,54 ,53 ,53 ,43 ,44 ,45 ,35 ,34 ,34 ,33 ,43 ,44 ,34 ,24 ,25 ,26 ,26 ,27 ,28 ,38 ,37 ,37 ,47 ,48 ,58 ,58 ,59 ,49 ,39 ,29 ,29 ,30 ,20 ,19 ;21 ,31 ,32 ,32 ,33 ,23 ,13 ,12 ,2 ,2 ,3 ,4 ,5 ,6 ,16 ,16 ,15 ,14 ,24 ,34 ,35 ,35 ,25 ,26 ,36 ,46 ,47 ,57 ,57 ,58 ,68 ,67 ,66 ,65 ,65 ,75 ,74 ,73 ,83 ,83 ,82 ,72 ,62 ,52 ,53 ,43 ,44 ,44 ,54 ,55 ,45 ,44 ,44 ,34 ,35 ,34 ,24 ,34 ,34 ,33 ;2 ,1 ,11 ,12 ,12 ,22 ,21 ,31 ,32 ,42 ,41 ,41 ,51 ,52 ,62 ,61 ,71 ,71 ,72 ,82 ,83 ,84 ,84 ,74 ,75 ,65 ,66 ,76 ,77 ,77 ,67 ,57 ,56 ,56 ,46 ,45 ,35 ,34 ,24 ,24 ,23 ,33 ,43 ,53 ,63 ,64 ,64 ,54 ,44 ,34 ,33 ,33 ,43 ,44 ,54 ,55 ,54 ,54 ,55 ,56 ;40 ,39 ,29 ,28 ,27 ,37 ,37 ,47 ,46 ,45 ,55 ,55 ,54 ,64 ,63 ,53 ,43 ,43 ,33 ,23 ,22 ,32 ,31 ,31 ,41 ,42 ,52 ,51 ,51 ,61 ,62 ,72 ,71 ,81 ,81 ,82 ,83 ,84 ,84 ,74 ,73 ,72 ,62 ,52 ,52 ,62 ,63 ,53 ,53 ,52 ,42 ,52 ,53 ,63 ,63 ,73 ,83 ,93 ,92 ,91 ;92 ,91 ,81 ,71 ,71 ,61 ,51 ,41 ,31 ,21 ,22 ,23 ,24 ,24 ,34 ,35 ,45 ,44 ,44 ,54 ,53 ,52 ,62 ,63 ,73 ,73 ,72 ,82 ,83 ,93 ,93 ,94 ,95 ,96 ,86 ,85 ,85 ,84 ,74 ,75 ,76 ,66 ,66 ,67 ,68 ,58 ,57 ,56 ,55 ,65 ,64 ,64 ,54 ,44 ,43 ,43 ,42 ,32 ,33 ,43 ;100 ,99 ,98 ,97 ,97 ,87 ,77 ,78 ,78 ,68 ,58 ,48 ,48 ,38 ,37 ,27 ,26 ,16 ,6 ,6 ,5 ,4 ,14 ,24 ,24 ,34 ,35 ,45 ,45 ,44 ,43 ,42 ,32 ,32 ,33 ,23 ,22 ,12 ,11 ,11 ,1 ,2 ,3 ,13 ,23 ,24 ,25 ,15 ,15 ,14 ,24 ,23 ,33 ,33 ,34 ,24 ,25 ,26 ,36 ,36 ;97 ,98 ,88 ,88 ,78 ,77 ,76 ,76 ,86 ,96 ,95 ,85 ,75 ,75 ,74 ,73 ,63 ,63 ,53 ,43 ,42 ,32 ,33 ,33 ,34 ,35 ,36 ,26 ,27 ,17 ,17 ,16 ,15 ,5 ,4 ,14 ,14 ,13 ,23 ,24 ,25 ,24 ,24 ,34 ,44 ,45 ,55 ,54 ,64 ,65 ,65 ,66 ,56 ,46 ,47 ,57 ,57 ,58 ,68 ,67 ;11 ,21 ,31 ,32 ,32 ,42 ,41 ,51 ,61 ,61 ,71 ,72 ,82 ,83 ,73 ,73 ,63 ,64 ,74 ,74 ,75 ,85 ,95 ,94 ,94 ,84 ,74 ,64 ,65 ,65 ,55 ,45 ,44 ,43 ,43 ,53 ,52 ,62 ,52 ,52 ,42 ,41 ,42 ,52 ,53 ,53 ,54 ,53 ,54 ,44 ,34 ,34 ,24 ,25 ,35 ,36 ,46 ,47 ,37 ,37 ;95 ,94 ,84 ,85 ,85 ,86 ,76 ,66 ,65 ,65 ,75 ,74 ,73 ,72 ,71 ,71 ,81 ,91 ,92 ,92 ,82 ,83 ,93 ,83 ,84 ,94 ,94 ,84 ,85 ,84 ,94 ,94 ,93 ,94 ,84 ,84 ,74 ,64 ,63 ,62 ,61 ,51 ,51 ,41 ,31 ,32 ,33 ,34 ,34 ,44 ,54 ,53 ,43 ,43 ,42 ,52 ,51 ,52 ,62 ,72 ;100 ,99 ,98 ,88 ,88 ,78 ,68 ,67 ,57 ,57 ,58 ,48 ,47 ,37 ,27 ,26 ,26 ,25 ,24 ,23 ,23 ,33 ,34 ,35 ,36 ,46 ,46 ,45 ,55 ,56 ,66 ,76 ,86 ,86 ,87 ,97 ,96 ,95 ,94 ,94 ,84 ,85 ,75 ,65 ,64 ,64 ,54 ,53 ,43 ,44 ,45 ,35 ,35 ,25 ,15 ,16 ,16 ,17 ,7 ,8 ;51 ,52 ,62 ,63 ,63 ,73 ,74 ,64 ,65 ,65 ,55 ,56 ,57 ,57 ,47 ,46 ,36 ,26 ,25 ,35 ,34 ,34 ,33 ,23 ,13 ,12 ,22 ,22 ,32 ,31 ,41 ,42 ,43 ,43 ,44 ,54 ,53 ,43 ,43 ,44 ,45 ,44 ,43 ,42 ,43 ,43 ,33 ,34 ,24 ,14 ,14 ,4 ,5 ,15 ,16 ,16 ,17 ,18 ,28 ,29 ;93 ,92 ,82 ,82 ,83 ,73 ,74 ,75 ,85 ,85 ,95 ,94 ,84 ,94 ,84 ,84 ,83 ,84 ,83 ,83 ,73 ,63 ,53 ,43 ,43 ,42 ,52 ,51 ,61 ,71 ,72 ,72 ,62 ,52 ,53 ,54 ,44 ,44 ,45 ,46 ,56 ,55 ,55 ,65 ,66 ,67 ,57 ,57 ,58 ,48 ,47 ,47 ,37 ,36 ,35 ,34 ,24 ,23 ,22 ,22 ;61 ,62 ,52 ,51 ,51 ,41 ,31 ,21 ,22 ,12 ,11 ,1 ,1 ,2 ,3 ,13 ,23 ,23 ,33 ,43 ,53 ,54 ,55 ,65 ,65 ,66 ,67 ,57 ,47 ,47 ,46 ,36 ,26 ,16 ,16 ,6 ,5 ,15 ,25 ,24 ,24 ,14 ,4 ,14 ,24 ,24 ,34 ,35 ,45 ,44 ,44 ,45 ,35 ,25 ,25 ,24 ,25 ,15 ,16 ,17 ;90 ,80 ,70 ,69 ,79 ,78 ,78 ,77 ,87 ,86 ,86 ,85 ,75 ,65 ,64 ,54 ,54 ,53 ,52 ,62 ,63 ,63 ,73 ,83 ,84 ,74 ,74 ,75 ,76 ,66 ,67 ,68 ,68 ,58 ,59 ,49 ,48 ,48 ,47 ,57 ,56 ,55 ,45 ,45 ,44 ,43 ,33 ,23 ,24 ,24 ,34 ,35 ,36 ,46 ,45 ,45 ,44 ,54 ,53 ,53 ;31 ,41 ,51 ,51 ,52 ,42 ,32 ,22 ,21 ,11 ,11 ,12 ,13 ,14 ,15 ,5 ,6 ,6 ,16 ,26 ,25 ,35 ,35 ,45 ,44 ,43 ,33 ,33 ,34 ,24 ,23 ,23 ,33 ,23 ,22 ,32 ,42 ,42 ,32 ,42 ,32 ,42 ,43 ,53 ,53 ,54 ,55 ,65 ,66 ,56 ,57 ,57 ,67 ,77 ,76 ,76 ,75 ,74 ,84 ,83 ;98 ,97 ,96 ,86 ,86 ,87 ,77 ,67 ,68 ,68 ,69 ,59 ,58 ,57 ,56 ,56 ,55 ,45 ,35 ,34 ,34 ,44 ,54 ,53 ,53 ,43 ,33 ,32 ,31 ,21 ,22 ,22 ,23 ,13 ,3 ,2 ,2 ,12 ,11 ,1 ,2 ,2 ,3 ,4 ,5 ,15 ,25 ,25 ,24 ,14 ,13 ,14 ,13 ,13 ,14 ,24 ,24 ,14 ,24 ,34 ;94 ,93 ,83 ,83 ,73 ,72 ,62 ,62 ,61 ,51 ,41 ,42 ,32 ,31 ,31 ,21 ,22 ,12 ,13 ,23 ,23 ,33 ,34 ,35 ,36 ,46 ,46 ,56 ,57 ,58 ,68 ,78 ,78 ,88 ,87 ,97 ,96 ,96 ,95 ,85 ,84 ,74 ,74 ,75 ,65 ,55 ,45 ,45 ,44 ,54 ,53 ,43 ,43 ,53 ,52 ,53 ,63 ,64 ,64 ,54 ;41 ,51 ,52 ,52 ,42 ,32 ,33 ,34 ,35 ,25 ,25 ,26 ,36 ,46 ,47 ,48 ,48 ,38 ,37 ,27 ,17 ,17 ,7 ,6 ,16 ,15 ,5 ,4 ,4 ,14 ,13 ,23 ,24 ,24 ,25 ,24 ,14 ,24 ,34 ,34 ,44 ,45 ,55 ,56 ,57 ,67 ,67 ,77 ,76 ,86 ,96 ,95 ,95 ,85 ,75 ,65 ,64 ,54 ,53 ,53 ;80 ,90 ,89 ,99 ,99 ,100 ,90 ,89 ,79 ,79 ,78 ,68 ,67 ,67 ,57 ,56 ,55 ,45 ,45 ,44 ,54 ,64 ,63 ,53 ,53 ,43 ,42 ,52 ,51 ,51 ,41 ,31 ,21 ,22 ,22 ,23 ,24 ,25 ,26 ,36 ,36 ,35 ,34 ,33 ,32 ,42 ,43 ,44 ,44 ,45 ,46 ,47 ,47 ,48 ,38 ,28 ,28 ,27 ,17 ,18 ;96 ,95 ,85 ,86 ,86 ,87 ,77 ,78 ,68 ,68 ,69 ,79 ,80 ,70 ,70 ,60 ,59 ,49 ,39 ,38 ,38 ,48 ,47 ,37 ,27 ,26 ,26 ,16 ,15 ,14 ,14 ,24 ,23 ,13 ,12 ,12 ,22 ,21 ,31 ,32 ,32 ,33 ,43 ,42 ,52 ,53 ,54 ,54 ,44 ,45 ,35 ,25 ,24 ,24 ,34 ,44 ,43 ,33 ,23 ,22 ;30 ,29 ,28 ,18 ,8 ,8 ,7 ,6 ,16 ,26 ,25 ,24 ,34 ,34 ,35 ,45 ,44 ,43 ,42 ,32 ,32 ,22 ,23 ,33 ,32 ,32 ,31 ,41 ,51 ,61 ,62 ,62 ,72 ,73 ,83 ,84 ,84 ,94 ,95 ,85 ,75 ,76 ,76 ,66 ,65 ,64 ,54 ,54 ,53 ,52 ,42 ,52 ,51 ,51 ,52 ,42 ,43 ,43 ,33 ,23 ;100 ,99 ,98 ,88 ,88 ,78 ,77 ,67 ,68 ,68 ,69 ,59 ,60 ,50 ,50 ,49 ,48 ,38 ,37 ,47 ,47 ,46 ,56 ,57 ,58 ,57 ,58 ,58 ,57 ,47 ,37 ,27 ,26 ,36 ,36 ,35 ,45 ,44 ,43 ,53 ,53 ,52 ,42 ,32 ,33 ,33 ,34 ,24 ,23 ,23 ,22 ,12 ,13 ,13 ,3 ,4 ,5 ,15 ,15 ,16 ;92 ,93 ,94 ,95 ,85 ,75 ,75 ,76 ,77 ,67 ,68 ,68 ,58 ,57 ,47 ,37 ,37 ,27 ,17 ,7 ,6 ,16 ,15 ,15 ,5 ,4 ,14 ,13 ,12 ,2 ,2 ,1 ,11 ,21 ,21 ,22 ,23 ,24 ,34 ,44 ,44 ,43 ,33 ,32 ,32 ,42 ,52 ,53 ,63 ,73 ,73 ,83 ,84 ,74 ,74 ,64 ,54 ,55 ,45 ,45 ;96 ,95 ,94 ,94 ,93 ,92 ,91 ,81 ,81 ,82 ,72 ,73 ,74 ,84 ,84 ,85 ,75 ,75 ,65 ,64 ,63 ,53 ,52 ,62 ,62 ,61 ,51 ,41 ,31 ,31 ,32 ,42 ,43 ,33 ,34 ,34 ,24 ,25 ,35 ,36 ,46 ,56 ,55 ,45 ,45 ,44 ,54 ,55 ,45 ,35 ,34 ,34 ,44 ,45 ,55 ,45 ,45 ,55 ,45 ,46 ;80 ,70 ,60 ,60 ,50 ,40 ,30 ,30 ,20 ,10 ,9 ,8 ,7 ,6 ,6 ,16 ,15 ,14 ,24 ,23 ,23 ,33 ,32 ,22 ,12 ,2 ,2 ,1 ,11 ,21 ,31 ,41 ,41 ,42 ,52 ,53 ,43 ,44 ,45 ,45 ,35 ,34 ,33 ,33 ,43 ,33 ,43 ,42 ,43 ,43 ,33 ,43 ,53 ,53 ,54 ,64 ,65 ,55 ,56 ,66 ;1 ,11 ,12 ,13 ,3 ,2 ,2 ,12 ,22 ,21 ,21 ,31 ,41 ,51 ,52 ,52 ,62 ,63 ,73 ,73 ,74 ,75 ,85 ,84 ,94 ,93 ,93 ,92 ,91 ,81 ,82 ,83 ,84 ,84 ,74 ,64 ,54 ,53 ,43 ,43 ,44 ,45 ,35 ,25 ,25 ,26 ,16 ,6 ,5 ,5 ,15 ,14 ,24 ,23 ,33 ,34 ,34 ,24 ,14 ,4 ;91 ,81 ,71 ,71 ,61 ,62 ,52 ,42 ,42 ,41 ,51 ,52 ,53 ,54 ,54 ,64 ,63 ,73 ,83 ,83 ,84 ,94 ,93 ,92 ,92 ,82 ,72 ,62 ,72 ,72 ,62 ,52 ,62 ,72 ,72 ,71 ,61 ,62 ,72 ,73 ,74 ,74 ,75 ,65 ,55 ,56 ,57 ,57 ,47 ,46 ,36 ,35 ,45 ,45 ,44 ,34 ,33 ,43 ,53 ,43 ;92 ,91 ,81 ,82 ,82 ,83 ,73 ,63 ,62 ,62 ,72 ,71 ,61 ,51 ,52 ,42 ,32 ,32 ,31 ,21 ,11 ,1 ,2 ,12 ,12 ,22 ,23 ,24 ,24 ,25 ,35 ,34 ,34 ,44 ,45 ,55 ,54 ,53 ,53 ,43 ,33 ,43 ,53 ,52 ,62 ,62 ,61 ,62 ,61 ,71 ,71 ,61 ,51 ,41 ,42 ,42 ,43 ,44 ,54 ,64 ];

i_velocity =  [58, 52, 54, 57, 61, 70, 57, 61, 62, 51, 54, 62, 66, 63, 60, 58, 57, 58, 55, 67, 54, 57, 67, 67, 66, 56, 69, 59, 69, 66, 64, 57, 50, 65, 54, 52, 61, 63, 50, 57, 51, 51, 68, 63, 51, 66, 68, 50, 63, 50, 57, 58, 60, 55, 70, 54, 68, 54, 60, 53, 53, 63, 54, 65, 66, 64, 54, 66, 53, 65, 51, 53, 70, 55, 57, 68, 63, 63, 61, 65, 63, 60, 63, 55, 56, 70, 58, 69, 51, 55, 65, 69, 58, 59, 65, 59, 51, 59, 56, 68] ;

i_location =  [100, 7, 6, 80, 96, 21, 93, 90, 31, 9, 61, 4, 7, 70, 97, 80, 9, 3, 2, 99, 51, 94, 50, 4, 9, 8, 30, 8, 70, 93, 40, 4, 7, 31, 94, 3, 100, 97, 8, 10, 50, 91, 100, 60, 97, 90, 6, 80, 98, 81, 6, 40, 60, 31, 98, 90, 50, 41, 8, 40, 95, 3, 7, 60, 30, 30, 70, 6, 10, 81, 98, 5, 7, 21, 2, 40, 92, 100, 97, 11, 95, 100, 51, 93, 61, 90, 31, 98, 94, 41, 80, 96, 30, 100, 92, 96, 80, 1, 91, 92] ;

destination = [86 ,90 ,70 ,22 ,33 ,19 ,65 ,47 ,28 ,62 ,19 ,32 ,84 ,27 ,39 ,24 ,53 ,5 ,41 ,61 ,85 ,7 ,85 ,25 ,87 ,48 ,32 ,47 ,64 ,16 ,41 ,12 ,56 ,36 ,65 ,93 ,52 ,83 ,5 ,65 ,48 ,28 ,31 ,31 ,24 ,18 ,47 ,17 ,24 ,88 ,42 ,57 ,2 ,26 ,86 ,25 ,4 ,51 ,77 ,52 ,40 ,88 ,14 ,55 ,28 ,90 ,43 ,88 ,59 ,34 ,54 ,44 ,19 ,33 ,56 ,91 ,43 ,36 ,67 ,37 ,72 ,8 ,29 ,22 ,17 ,53 ,83 ,34 ,54 ,53 ,18 ,22 ,23 ,16 ,45 ,46 ,66 ,4 ,43 ,64 ];

edge_edge_min = [1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,2 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ;1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,2 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ;1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,2 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ;1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,2 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ;1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,2 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ;1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ;1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ;1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ;1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,2 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ;1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,2 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,2 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ];





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


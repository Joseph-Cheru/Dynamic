function [bw_cost,mem] = data_delivery_opt_bwcost(ov_sets,len_of_sets,N,M,beta,bw_edge,mem_edge,mem_occup,mem_app,x,v2e_trvtime,vel_free,bandwidth,density_jam,density,bw_const,l_cov)

nov = N;
noe = M;

cvx_begin
    variable mem(nov,noe);
    
    expression mem_int(noe);
    expression bytes_received_min(nov,noe);
    expression bw_util(noe);
    expression bw_cost;
    expression mem_accum_vehicle(nov);
    expression mem_accum_edge(noe);
    
    %expression temp_sum(len_of_sets(noe+1));
    
    expression temp_sum(sum(len_of_sets));
    expression temp_bw_util(len_of_sets(noe+1));
    
    for j = 1:noe
        for i = 1:nov
            mem_int(j) = mem_int(j) + mem(i,j);
            bytes_received_min(i,j) = x(i,j) * bandwidth(j)/(density_jam(j)*(vel_free(j)/3600)*(1-(density(j)/density_jam(j))));
        end
    end
    
    for j = 1:noe
        bw_util(j) = (((mem_int(j)*(vel_free(j)/3600)*(1-(density(j)/density_jam(j))))/l_cov(j))+bw_const(j))/bandwidth(j);    
        bw_cost = bw_cost + beta*(1+bw_util(j))^2;
    end
    
    for i = 1:nov
        for j = 1:noe
            mem_accum_vehicle(i) = mem_accum_vehicle(i) + mem(i,j)*x(i,j);
        end
    end


    for j = 1:noe
        for k = len_of_sets(j)+1:len_of_sets(j+1)
        %for k = 1:len_of_sets(j)
            for i = 1:nov
                %disp("k");
                %disp(k);
                %disp("i");
                %disp(i);
                %disp(ov_sets(k,i));
                temp_sum(k) = temp_sum(k) + mem(i,j)*ov_sets(k,i);
                

            end
        end
    end
    
    minimize bw_cost
    subject to
        for i = 1:nov
            mem_accum_vehicle(i) == mem_app(i);
        end
        for i = 1:nov
            for j = 1:noe
                if (x(i,j) == 1)
                    mem(i,j) >= 0;
                end
            end
        end
        for i = 1:nov
            for j = 1:noe
                if (x(i,j) == 1)
                    mem(i,j) <= mem_app(i);
                end
            end
        end
        for i = 1:nov
            for j = 1:noe
                if (x(i,j) == 0)
                    mem(i,j) == 0;
                end
            end
        end

        for j = 1:noe
            for k = len_of_sets(j)+1:len_of_sets(j+1)
                temp_sum(k) <= mem_edge(j) - mem_occup(j);
            end        
        end

        for i = 1:nov
            for j = 1:noe
                bytes_received_min(i,j) >= mem(i,j);
            end
        end
cvx_end
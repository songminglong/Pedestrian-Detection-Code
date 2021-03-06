function NMSwindows = NMS(windows,results,sss)
if(size(windows,1)>1)
    scale = windows{1}(1,1).scale/windows{2}(1,1).scale;
else
    scale = windows{1}(1,1).scale;
end

NMSwindows = [];
for index = 1:size(results,1)
    [rows, columns] = size(results{index});
    for i = 1:rows
        for j = 1:columns
            if(results{index}(i,j)>0) 
                i1 = floor(scale*i); i2 = floor(scale*scale*i);
                j1 = floor(scale*j); j2 = floor(scale*scale*j);
                imax = min(i+2,size(results{index},1));
                jmax = min(j+2,size(results{index},2));
                r = reshape(results{index}(i:imax,j:jmax),1,[]);
                w = reshape(windows{index}(i:imax,j:jmax),1,[]);
                results{index}(i:imax,j:jmax) = -1;
                
                if (index+1)<=size(results,1)
                    i1min = max(i1-1,1);
                    j1min = max(j1-1,1);
                    i1max = min(i1+2, size(results{index+1},1));
                    j1max = min(j1+2, size(results{index+1},2));
                    
                    r1 = reshape(results{index+1}(i1min:i1max,j1min:j1max),1,[]);
                    w1 = reshape(windows{index+1}(i1min:i1max,j1min:j1max),1,[]);
                    r = [r r1];
                    w = [w w1];
                    results{index+1}(i1min:i1max,j1min:j1max) = -1;
                end
                
                if (index+2)<=size(results,1)
                    i2min = max(i2-1,1);
                    j2min = max(j2-1,1);
                    i2max = min(i2+2, size(results{index+2},1));
                    j2max = min(j2+2, size(results{index+2},2));
                    
                    r2 = reshape(results{index+2}(i2min:i2max,j2min:j2max),1,[]);
                    w2 = reshape(windows{index+2}(i2min:i2max,j2min:j2max),1,[]);
                    r = [r r2];
                    w = [w w2];
                    results{index+2}(i2min:i2max,j2min:j2max) = -1;
                end
                num = length(find(r>0));
                
                % SINGLE SCALE SUPPRESSION
                if (sss && num == 1)
                    continue
                end
                
                w_mean = Mean(w(find(r>0)),num);
                NMSwindows = [NMSwindows w_mean];
            end
        end
    end
end
function T = removeTableRows(FOI, T, RemoveInfo)
%%
for i = 1:length(RemoveInfo)
    RemoveFOI = RemoveInfo(i).FOI;
    RemoveField = RemoveInfo(i).Field;
    RemoveValues = RemoveInfo(i).Values;
    %%
    if isempty(RemoveValues)
        continue
    end
    %%
    if strcmp(FOI, RemoveFOI)
        Flag = 1;
        while Flag
            for k = 1:length(RemoveValues)
                for j = 1:height(T)
                    if table2array(T(j,RemoveField)) == RemoveValues(k)
                        T = T([1:j-1 j+1:end],:);
                        if strcmp(RemoveFOI, 'Edges')
                            break
                        else
                            Flag =0;
                            break
                        end
                    elseif j == height(T)
                        Flag =0;
                    end
                end
            end
        end
    end
end
end
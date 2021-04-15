function W = weightDegree(ID1, ID2)
%% Get the relative weight between two characters
WeightPool = [1 3 5 7 9 11 13];

temp = round((ID1 - ID2)*100)/10;
for i = 1:length(WeightPool)
    if temp == 0
        W = WeightPool(1);
        break
    else
    if temp >= 0
        if i == round(temp)
            W = WeightPool(i+1);
            break
        end
    else
        if i == round(-temp)
            W = 1/WeightPool(i+1);
            break
        end
    end
    end
end
end
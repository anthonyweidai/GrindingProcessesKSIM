function bubbles = montecarloUpdate(bubbles, blockbound, blockflag1_map, x_blocknum, y_blocknum)
%% update bubbles's postion by monte carlo algorithm and block area idea
% these blocks are located in boundaries
blocknum = x_blocknum * y_blocknum;
Vx1 = 1:x_blocknum:blocknum-x_blocknum+1; % left |
Vx2 = x_blocknum:x_blocknum:blocknum; % right |
Vy1 = 1:1:x_blocknum; % down -
Vy2 = blocknum-x_blocknum+1:1:blocknum; % up -

% distance to boundary ceil
dismax = 2*ceil(max(bubbles.radius)*100)/100;

Ntotal = length(bubbles.radius);
numcount = 0;
%% montecar update
while(Ntotal>=1e-7)
    for nblock = 1:numel(blockflag1_map)
        boundflag = 0;
        posx = (blockbound(nblock,2)-blockbound(nblock,1))*rand() + blockbound(nblock,1);
        posy = (blockbound(nblock,4)-blockbound(nblock,3))*rand() + blockbound(nblock,3);
        blockflag1 = nblock;
        %% set the second block
        if posx<=(blockbound(nblock,2)+blockbound(nblock,1))/2
            if posy<=(blockbound(nblock,4)+blockbound(nblock,3))/2
                blockflag2 = 1;
                boundflag((abs(posx-blockbound(nblock,1))<=dismax)||...
                    (abs(posy-blockbound(nblock,3))<=dismax)) = 1;
            else
                blockflag2 = 3;
                boundflag((abs(posx-blockbound(nblock,1))<=dismax)||...
                    (abs(posy-blockbound(nblock,4))<=dismax)) = 1;
            end
        else
            if posy<=(blockbound(nblock,4)+blockbound(nblock,3))/2
                blockflag2 = 2;
                boundflag((abs(posx-blockbound(nblock,2))<=dismax)||...
                    (abs(posy-blockbound(nblock,3))<=dismax)) = 1;
            else
                blockflag2 = 4;
                boundflag((abs(posx-blockbound(nblock,2))<=dismax)||...
                    (abs(posy-blockbound(nblock,4))<=dismax)) = 1;
            end
        end
        %% overlap invalidation
        forflag1 = 0;
        if numcount >= 1e-7
            xthld1 = 0;
            xthld2 = 0;
            ythld1 = 0;
            ythld2 = 0;
            if ismember(nblock,Vx1)
                xthld1 = 1;
            elseif ismember(nblock,Vx2)
                xthld2 = 1;
            elseif ismember(nblock,Vy1)
                ythld1 = 1;
            elseif ismember(nblock,Vy2)
                ythld2 = 1;
            end
            for k = 1:numcount
                % invalidate overplap within the same block
                if bubbles.blockflag1(k) == blockflag1
                    distance1 = sqrt((bubbles.pos(k,1)-posx)^2 + (bubbles.pos(k,2)-posy)^2);
                    if distance1 < (bubbles.radius(k)+bubbles.radius(numcount+1))
                        forflag1 = 1;
                        break
                    end
                end
                % invalidate overplap compared to the adjacent blocks
                if (xthld1 == 1|| xthld2 == 1) && (ythld1 == 1 || ythld2 == 1)
                    continue
                elseif boundflag == 1
                    Thred = [xthld1,xthld2,ythld1,ythld2];
                    judgeblock = ajacentInvalidation(k,numcount,bubbles,blockflag1,blockflag2,Thred,posx,posy,x_blocknum);
                    if judgeblock == 0
                        forflag1 = 1;
                        break
                    end
                end
            end
        end
        %% without overlap
        if forflag1 == 0
            numcount = numcount + 1;
            Ntotal = Ntotal - 1;
            bubbles.pos(numcount,1) = posx;
            bubbles.pos(numcount,2) = posy;
            bubbles.blockflag1(numcount) = blockflag1;
            bubbles.blockflag2(numcount) = blockflag2;
        end
        if Ntotal <= 1e-7
            break
        end
    end
end
end
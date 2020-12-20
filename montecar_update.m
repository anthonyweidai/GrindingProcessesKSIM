function bubbles = montecar_update(bubbles,blockbound)
%% update bubbles's postion by monte carlo algorithm and block area idea
blockflag1_map = reshape(1:40,[4,10]); % block = 40; block = floor(sqrt(num));
% block boundary number
Vx1 = 1:4:37;
Vx2 = 4:4:40;
Vy1 = 1:1:4;
Vy2 = 37:1:40;
% distance to boundary ceil
dismax = 2*ceil(max(bubbles.Tradius)*100)/100;

Ntotal = length(bubbles.Tradius);
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
        forflag2 = 0;
        if bubbles.numcount >= 1e-7
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
            Thred = [xthld1,xthld2,ythld1,ythld2];
            for k = 1:bubbles.numcount
                % invalidate overplap within the same block
                if bubbles.blockflag1(k) == blockflag1
                    distance1 = sqrt((bubbles.pos(k,1)-posx)^2 + (bubbles.pos(k,2)-posy)^2);
                    if distance1 < (bubbles.Tradius(k)+bubbles.Tradius(bubbles.numcount+1))
                        forflag2 = 1;
                        break
                    end
                end
                % invalidate overplap compared to the adjacent blocks
                if (xthld1 == 1|| xthld2 == 1) && (ythld1 == 1 || ythld2 == 1)
                    continue
                elseif boundflag == 1
                    judgeblock = ajacent4inval(k,bubbles,blockflag1,blockflag2,Thred,posx,posy);
                    if judgeblock == 0
                        forflag2 = 1;
                        break
                    end
                end
            end
        end
        %% without overlap
        if forflag2 == 0
            bubbles.numcount = bubbles.numcount + 1;
            Ntotal = Ntotal - 1;
            bubbles.pos(bubbles.numcount,1) = posx;
            bubbles.pos(bubbles.numcount,2) = posy;
            bubbles.blockflag1(bubbles.numcount) = blockflag1;
            bubbles.blockflag2(bubbles.numcount) = blockflag2;
        end
        if Ntotal <= 1e-7
            break
        end
    end
end
end



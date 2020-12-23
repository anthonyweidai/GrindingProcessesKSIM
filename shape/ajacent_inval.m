function judgeblock = ajacent_inval(k,numcount,bubbles,blockflag1,blockflag2,Thred,posx,posy,x_blocknum)
%% invalidate bubble overlap within four ajacent small blocks
judgeblock = 1;
temp = 0;
if blockflag2 == 1
    if bubbles.blockflag1(k) == blockflag1 - x_blocknum
        if Thred(3) ~= 1 && (bubbles.blockflag2(k) == 3||bubbles.blockflag2(k) == 4)
            temp = 1;
        end
    elseif bubbles.blockflag1(k) == blockflag1 - 1
        if Thred(1) ~= 1 &&(bubbles.blockflag2(k) == 2||bubbles.blockflag2(k) == 4)
            temp = 1;
        end
    elseif bubbles.blockflag1(k) == blockflag1 - x_blocknum - 1
        if (Thred(1) ~= 1||Thred(3) ~=1) && bubbles.blockflag2(k) == 4
            temp = 1;
        end
    end
elseif blockflag2 == 2
    if bubbles.blockflag1(k) == blockflag1 - x_blocknum
        if Thred(3) ~= 1 &&(bubbles.blockflag2(k) == 3||bubbles.blockflag2(k) == 4)
            temp = 1;
        end
    elseif bubbles.blockflag1(k) == blockflag1 + 1
        if Thred(2) ~= 1 &&(bubbles.blockflag2(k) == 1||bubbles.blockflag2(k) == 3)
            temp = 1;
        end
    elseif bubbles.blockflag1(k) == blockflag1 - x_blocknum + 1
        if (Thred(1) ~= 2||Thred(3) ~=1)&&bubbles.blockflag2(k) == 3
            temp = 1;
        end
    end
elseif blockflag2 == 3
    if bubbles.blockflag1(k) == blockflag1 - 1
        if Thred(1) ~= 1 &&(bubbles.blockflag2(k) == 2||bubbles.blockflag2(k) == 4)
            temp = 1;
        end
    elseif bubbles.blockflag1(k) == blockflag1 + x_blocknum
        if Thred(4) ~= 1 &&(bubbles.blockflag2(k) == 1||bubbles.blockflag2(k) == 2)
            temp = 1;
        end
    elseif bubbles.blockflag1(k) == blockflag1 + x_blocknum - 1
        if (Thred(1) ~= 1||Thred(4) ~=1) && bubbles.blockflag2(k) == 2
            temp = 1;
        end
    end
elseif blockflag2 == 4
    if bubbles.blockflag1(k) == blockflag1 + 1
        if Thred(2) ~= 1 &&(bubbles.blockflag2(k) == 1||bubbles.blockflag2(k) == 3)
            temp = 1;
        end
    elseif bubbles.blockflag1(k) == blockflag1 + x_blocknum
        if Thred(4) ~= 1 &&(bubbles.blockflag2(k) == 1||bubbles.blockflag2(k) == 2)
            temp = 1;
        end
    elseif bubbles.blockflag1(k) == blockflag1 + x_blocknum + 1
        if (Thred(2) ~= 1||Thred(4) ~=1) && bubbles.blockflag2(k) == 1
            temp = 1;
        end
    end
end
%% only temp == 1, do multiplication, in order to enhance system performance
if temp == 1
    distance2 = sqrt((bubbles.pos(k,1)-posx)^2 + (bubbles.pos(k,2)-posy)^2);
    judgeblock(distance2 < (bubbles.radius(k) + bubbles.radius(numcount+1))) = 0;
end
end
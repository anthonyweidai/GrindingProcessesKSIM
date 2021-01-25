function [A_t,A_n]=COF_CAL(h_ori_grit,dp,h_0)%h_0, ,h_grit,grit_outline
%% res, hmax,
res=.1;miu_r=0;threshold=.01;miu_pu=0;g_res=.2;
testmode=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
miu_r_d=miu_r;
h_grit=-h_ori_grit+dp;
w_grit=length(h_grit);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grit_outline=min(h_grit);%-round(grit_outline,2);
%%please ensure that h_0 is <0 and grit_outline is also<0
%single
%h_0=0*grit_outline;%round(h_0,2);
h_res= h_0 - (h_0>grit_outline).*(h_0-grit_outline).*(1-miu_r_d);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if sum(h_res)==0
    A_t=0;
    A_n=0;
    return
end
grit_outline=min(grit_outline,0);
h_pileup=h_0+(h_0>grit_outline).*(h_0-grit_outline).*miu_pu;
h_max=max((h_0>grit_outline).*(h_0-grit_outline));

g_max=min(grit_outline);

draw_x=1:w_grit;
mark_A_n=0*h_grit;
S_tf=0;
S_tb=0;
A_t=0;
A_n=0;
pu=0;
leftover=0;


%%
for h_i=0:-res:g_max-res
    tbound=[];
    bbound=[];
    
    h_cu=(h_0>=h_i);
    grit_outline_cu=(grit_outline<h_i);
    h_res_cu=(h_res>=h_i);
    h_grit_SUM_cu=sum(h_grit<h_i);
    h_grit_cu=(h_grit<h_i);
    lbound=find(grit_outline_cu,1,'first');
    rbound=find(grit_outline_cu,1,'last');
    for i=1:length(grit_outline)
        tbound_temp=find(h_grit_cu(:,i)>0,1,'first');
        if isempty(tbound_temp)
            tbound_temp=0;
        else
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            mark_A_n(tbound_temp,i)=1;
        end
        tbound=[tbound tbound_temp];
        
        bbound_temp=find(h_grit_cu(:,i)>0,1,'last');
        if isempty(bbound_temp) || h_res_cu(i)==0
            bbound_temp=0;
        else
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            mark_A_n(bbound_temp,i)=1;
        end
        bbound=[bbound bbound_temp];
        if i==lbound
            mark_lb=find(h_grit_cu(:,i)>0);
        end
        if i==rbound
            mark_rb=find(h_grit_cu(:,i)>0);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%
    if ~isempty(lbound)
        if length(lbound)>0
            mark_A_n(mark_lb,lbound)=1;
        end
    end
    if ~isempty(rbound)
        if length(rbound)>0
            mark_A_n(mark_rb,rbound)=1;
        end
    end
    %     S_tf=S_tf+length(tbound)-length(bbound);
    %     S_tb=S_tb+sum(h_res_cu.*grit_outline_cu);
    %     bounding=[tbound>0;bbound>0;(tbound>0)-(bbound>0)]';
    A_t=A_t+sum((tbound>0)-(bbound>0));%S_tf-S_tb;
    if bbound==0
        if pu==1
        else
            A_t=A_t+sum(tbound>0)*(-g_max)*(miu_pu/res);
            pu=1;
        end
    end
    
    if   double(h_i)==double(g_max)+double(res)
        leftover=0;
    end
    if sum(h_grit_cu,'all')==0
        mark_A_n=~~(mark_A_n+leftover);
    end
    leftover=h_grit_cu;
    
end

%%deal with empty spaces

for ii=1:length(grit_outline)
    check_mark=mark_A_n(:,ii);
    if sum(check_mark) ~= 0
        mark_A_n(find(check_mark,1,'first'):find(check_mark,1,'last'),ii)=1;
    end
end
if testmode ==1
    figure;
    subplot(1,2,1);
    surf(draw_x,draw_x,double(mark_A_n),'Linestyle','none');
    subplot(1,2,2);
    surf(draw_x,draw_x,double(h_grit<0),'Linestyle','none');
end


A_t=A_t*g_res*res;
A_n=sum(mark_A_n,'all')*g_res*g_res;

if testmode==3
    figure
    plot(1:length(grit_outline),h_0,'k-',1:length(grit_outline),h_res,'r-',1:length(grit_outline),h_pileup,'b-');
    title([num2str(h_max) ' | ' num2str(A_n) ' | ' num2str(A_t)]);
end

if testmode == 2
    figure
    subplot(1,2,1);
    surf(1:length(grit_outline),1:length(grit_outline),h_grit,'Linestyle','none');
    subplot(1,2,2);
    surf(1:length(grit_outline),1:length(grit_outline),h_grit.*mark_A_n,'Linestyle','none');
    % subplot(2,2,3);
    % plot(1:length(grit_outline),grit_outline,'k-',1:length(grit_outline),h_res,'r-');
    disp('over');
end

end

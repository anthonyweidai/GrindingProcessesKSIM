% legend
allChildren = get(gca, 'Children');                % list of all objects on axes
displayNames = get(allChildren, 'DisplayName');    % list of all legend display names
% Remove object associated with "data1" in legend
% % delete(allChildren(strcmp(displayNames, 'data1')))
for i = 1:length(displayNames)
    Name = char(displayNames(i));
    %     if ~(strcmp(Name, 'P_i-有序')||strcmp(Name, 'P_i-无序'))
    if ~strcmp(Name, 'P_c')
        delete(allChildren(i));
    end
end


% a = readtable('M:\GrdData\Default\CY1tgw60kd0Sgap0.5Rgap1w7FT0RAM0Rarea0.7Ssg0Hsg0Rsg0vw200000-uct.csv');
% b = table2array(a);
% y = b(:);
% y1 = y(find(y>=1e-7));
% figure
% % histogram(y1);
% boxplot(y1)
% y2 = rmoutliers(y1);
% figure
% % histogram(y2);
% boxplot(y2);

% syms t w;
% ut=sym('heaviside(t+0.5)-heaviside(t-0.5)');
% fw=fourier(ut);
% % remove repeating data
% a = randi(10,[1,20]);
% [b,m1,n1] = unique(a,'first');
% [c1,d1] =sort(m1);
% b = b(d1);

% % diff shape barchart and color
% % x = ['1', '3', '55t'];
% xName = {'Small','Medium','Large'};
% x = categorical(xName);
% x = reordercats(x,xName);
% vals = [2 3 6; 11 23 26];
% hb = bar(x,vals);
% hb(1).FaceColor = 'r';
% hb(2).FaceColor = 'b';
% hb(3).FaceColor = 'm';

% % surf 3d active edges
% dt = delaunayTriangulation(x,y) ;
% tri = dt.ConnectivityList ;
% xi = dt.Points(:,1) ;
% yi = dt.Points(:,2) ;
% F = scatteredInterpolant(x,y,z);
% zi = F(xi,yi) ;
% trisurf(tri,xi,yi,zi)
% view(2)
% shading interp

% x = linspace(0,25);
% y = sin(x/2);
% yyaxis left
% plot(x,y);
%
% r = x.^2/2;
% yyaxis right
% plot(x,r);

% % box plot color
% data = rand(100, 4);
% x = 1:4;
% colors = [1 0 0];
% boxplot(data, x, 'Notch', 'on');
% h = findobj(gca,'Tag','Box');
% for j=1:length(h)
%     patch(get(h(j),'XData'),get(h(j),'YData'),'c','FaceAlpha',.5);
% end
% hold on
% data = rand(100, 4) + 0.1;
% x = 1:4;
% colors = rand(4, 3);
% boxplot(data, x, 'Notch', 'on');
% h = findobj(gca,'Tag','Box');
% for j=1:length(h)/2
%     patch(get(h(j),'XData'),get(h(j),'YData'),'m','FaceAlpha',.5);
% end

% % delete element from vector
% set(0,'defaultfigurecolor',[1 1 1])
% % rng default  % For reproducibility
% % x1 = normrnd(5,1,100,1);
% % x2 = normrnd(6,1,100,1);
% FilePath = 'M:\GrdData\Default';
% FileName1 = [FilePath '\CY7w7FT0RAM1Rarea0.7Ssg0Hsg0Rsg0vw200000-uct.csv'];
% FileName2 = [FilePath '\CY7tgw60kd0Sgap0.5Rgap1w7FT0RAM1Rarea0.7Ssg0Hsg0Rsg0vw200000-uct.csv'];
%
% UCTInfo = readtable(FileName1);
% UCTArray1 = table2array(UCTInfo);
% UCTInfo = readtable(FileName2);
% UCTArray2 = table2array(UCTInfo);
%
% UCTArray1 = UCTArray1(:);
% UCTArray1(UCTArray1<=1e-5) = [];
% % UCTArray1 = UCTArray1(UCTArray1>=1e-5);
% UCTArray2 = UCTArray2(:);
% UCTArray2(UCTArray2<=1e-5) = [];
%
% x = [UCTArray1;UCTArray2];
%
% g1 = repmat({'First'},length(UCTArray1),1);
% g2 = repmat({'Second'},length(UCTArray2),1);
%
% g = [g1;g2];
%
% figure
% boxplot(x, g, 'Notch', 'on')
% title('Compare Random Data from Different Distributions')


% a = [1 3 2 4; 7 3 4 5];
% sortrows(a,4)
% A = randn(10,1);
% size(A,2)

% A = randn(10,1);
% B = randn(10,1);
% C = [A B];
% R1 = corrcoef(A,B);
% R2 = corrcoef(C);

% for i = 1:0
%     a = 1
% end

% a.a = 1:3;
% a.b = 1:3;
% b.b = 2:3;
% b.a = 2;
% T = [a b];
% length(T)

% figure
% x = -pi:pi;
% y1 = sin(x);
% % legend('y1')
% plot(x,y1,'r-');
% hold on
% y2 = cos(x);
% % legend('y2')
% plot(x,y2,'b--');
% hold on
% y3 = 2*cos(x);
% plot(x,y3,'y--');
% % legend('y3')
% legend('y1','y2','y3')
% % xlabel('\sigma_{max}')
% % xName = '\theta_d/^o';
% % xName = 'Rarea^,';
% xName = 'Ra\mum';
% xlabel(xName)

% for i = 1:5
% figure(i);
% end
% close gcf

% rpm = 3000;               %wheel spinning speed, round/min
% ds = 30e3;   %diameter of a grd wheel, um
% vs = floor(ds*pi*rpm/60);        %grd wheel line speed, um/s
%
% WorkpieceLength = 1000;
% WorkpieceWidth = WorkpieceLength/2;     % max(grits.posx);
% WheelLength = 20*WorkpieceLength;       % 40 times Wheel Diameter to Width
% WheelWidth = WorkpieceWidth;
% ds1 = WheelLength/pi; %diameter of a grd wheel, um
% vs1 = floor(WheelLength*rpm/60);  %grd wheel line speed, um/s

% t.a = 1;
% FOI = 'b';
% t.(FOI) = 2;
% x = -pi:pi;
% y = sin (x);
% plot(x,y)
% savefig('M:/aa.fig')

% if UT_mode == 1
%     if shape == 1 || shape == 2
%         %% CBN
%         H = 45e-3; %Pa, 45GPa=45e-3N/um^2
%         E = 865e-3;
%         v = 0.12;
%         % A. Falin et al., 2017, doi: 10.1038/ncomms15815.
%         % M. P. D’Evelyn and T. Taniguchi, 1999, doi: 10.1016/s0925-9635(99)00077-1.
%         % Y. Tian et al., 2013, doi: 10.1038/nature11728.
%     elseif shape == 3
%         %% Synthetic Diamond
%         H = 90e-3;
%         E = 752e-3;
%         v = 0.034;
%         % M. Mohr et al., 2014, doi: 10.1063/1.4896729.
%         % M. D. Drory, R. H. Dauskardt, 1995, doi: 10.1063/1.360060.
%         % S. Dub et al., 2017, doi: 10.3390/cryst7120369.
%     end
% end

% function test2
% b = 3;
% a = b - 1;
% end

% t = struct2table(station)
% writetable(t, 'station.xlsx');

% C = {"the" "end"};
% C = cat(2,premise,C);

% num = 1500;
% tic
% f(1:num) = parallel.FevalFuture;
% for idx = 1:num
% f(idx) = parfeval(@magic,1,idx);
% end
%
% magicResults = cell(1,num);
% for idx = 1:num
% [completedIdx,value] = fetchNext(f);
% magicResults{completedIdx} = value;
% % fprintf('Got result with index: %d.\n', completedIdx);
% end
% toc

% tic
% magicResults = cell(1,num);
% for idx = 1:num
%     magicResults{idx} = magic(idx);
% end
% toc


% clc;
% pause on
% tic;
% % parpool(2);
% f1 = parfeval(@Function_I, 1);
% f2 = parfeval(@Function_II, 1);
% function1=Function_I(5);
% function2=Function_I(4);
% % function3=Function_II(4);
% % delete(gcp('nocreate'));
% function func1 = Function_I(a)
%
%         disp('Starting function 1:');
%         startF1=toc
% %             a=5;
%             b=6;
%             func1=a*b;
%             pause(0.1);
%         disp('End function 1:');
%         EndF1=toc
%
% end
% function func2 = Function_II(a)
%
%         disp('Starting function 2:');
%         StartF2=toc
% %         a=4;
%         b=6;
%         func2=a*b;
%         pause(0.1);
%         disp('End function 2:');
%         EndF2=toc
% end



% N=10^7; a=rand(1,N); b=gpuArray(a);
% tic
% % for k=1:300    %这个for循环在cpu中进行，不并行
% %     fft(a+k);
% % end
% % toc%--------------
% tic
% parfor k=1:300 %把for换成parfor
%     fft(a+k);   %parfor循环仍在cpu中进行，会并行。
% end
% toc%--------------
% tic
% for k=1:300    %这个for循环在gpu中进行，高度并行。
%     fft(b+k);   %矩阵b保存在显存中。
% end
% toc
% xy = -2.5 + 5*gallery('uniformdata',[200 2],0);
% x = xy(:,1);
% y = xy(:,2);
% v = x.*exp(-x.^2-y.^2);
%
% [xq,yq] = meshgrid(-2:.2:2, -2:.2:2);
% vq = griddata(x,y,v,xq,yq);
%
% % mesh(xq,yq,vq)
% subplot(2,2,1);
% plot3(xq,yq,vq,'o')
% subplot(2,2,3);
% plot3(x,y,v,'.',xq,yq,vq,'o'), grid on
% xlim([-2.7 2.7])
% ylim([-2.7 2.7])
%
%
% F = scatteredInterpolant(x,y,v);
% tq = linspace(3/4*pi+0.2,2*pi-0.2,40)';
% xq = [2.8*cos(tq); 1.7*cos(tq); cos(tq)];
% yq = [2.8*sin(tq); 1.7*sin(tq); sin(tq)];
% vq = F(xq,yq);
%
% subplot(2,2,2);
% plot3(xq,yq,vq,'o')
% subplot(2,2,4);
% plot3(x,y,v,'.',xq,yq,vq,'o'), grid on
% title('Linear Interpolation')
% xlabel('x'), ylabel('y'), zlabel('Values')
% legend('Sample data','Interpolated query data','Location','Best')

% set(0,'defaultfigurecolor',[1 1 1])
% x = 0:pi;
% y = sin(x);
% figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
% plot(x,y);
% savefig([num2str(1) '-report.fig']);
% % openfig('1-report.fig','visible')
% %
% GrdProcess3(30,4,1,2,3,0,2,0.2)

% t1.a = 1;
% t1.b = 2;
% % premise = [1 t1]
% % t1.a
% t1.c(~isfield(t1,'c'))=3;
% cell2mat(struct2cell(t1))

% num = 1250;
% block = floor(sqrt(num)); % can be qualify
% area = 1000*500/block;
% numpfcal = num*block + num/block*num;
% numpfcal2 = num*(num+1)/2;

% N = 999999;
% K = 1:ceil(sqrt(N));
% D = K(rem(N,K)==0);
% D = [D sort(N./D)];

% P1 = [1,-1,3];
% P2 = [2,3,4];
% P3 = [-5,6,7];
% normal = cross(P1-P2, P1-P3);

% d.a = 3;
% d.b = 4;
% c = 3;
% clear d.a
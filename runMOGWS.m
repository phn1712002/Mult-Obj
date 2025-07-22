% clear
% close all
% clc
% %% All Lib
% addpath('algorithms');
% addpath('utils');
% addpath('measurements');
% addpath('problems');
% 
% %% Khai báo hàm mục tiêu
% % fobj  - Thông tin của hàm
% % nVar  - Số lượng chiều của hàm c
% % lb,ub - Điều kiện biên
% problem = myFitness();
% fobj = @(x) problem.calculation(x);
% f_evaluate = @(x, y) problem.evaluate(x, y);
% is_maximization_or_minization = problem.is_maximization_or_minization;
% nVar = problem.nVar;
% lb = problem.LB;	
% ub = problem.UB;
% 
% %% Đầu vào cho MO-GWS
% %Pop_num        - Số lượng bầy 
% %MaxIt          - Số lượng vòng lặp
% %Archive_size   - Số lượng kho lưu trữ
% Pop_num = 50;
% options.L0 = 5;
% options.r0 = 3;
% options.rho = 0.4;
% options.y = 0.6;
% options.B = 0.08;
% options.s = 0.6;
% options.rs = 10;
% options.nt = 10;               
% MaxIt = 100;  					
% Archive_size = 50;   			
% 
% %% Các thông số này được lấy mặc định từ code MO-PSO
% alpha = 0.1;  		% Grid Inflation Parameter
% nGrid = 7;   		% Number of Grids per each Dimension
% beta = 2;     		% Leader Selection Pressure Parameter
% gamma = 2;    		% Extra (to be deleted) Repository Member Selection Pressure
% 
% %% Run
% eva_curve = MOGWS (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,options,MaxIt,Archive_size,alpha,nGrid,beta,gamma,f_evaluate);
% problem.plot_eva(eva_curve);
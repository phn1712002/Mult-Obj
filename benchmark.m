clear
close all
clc

%% Khai báo hàm mục tiêu
% fobj  - Thông tin của hàm
% nVar  - Số lượng chiều của hàm c
% lb,ub - Điều kiện biên
% is_maximization_or_minization - Max = true, min = false
nVar = 4;
is_maximization_or_minization = false;
problem = ZDTProblems('ZDT1', nVar, is_maximization_or_minization);
fobj = @(x) problem.calculation(x);
f_evaluate = @(x, y) problem.evaluate(x, y);
lb = problem.LB;	
ub = problem.UB;

%% Đầu vào cho MO-MGO
%SearchAgents_num - Số lượng bầy sói
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
SearchAgents_num = 50;		
MaxIt = 100;  					
Archive_size = 100;   			

%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Grid Inflation Parameter
nGrid = 10;   		% Number of Grids per each Dimension
beta = 4;     		% Leader Selection Pressure Parameter
gamma = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
eva_curve = MOMGO (fobj,is_maximization_or_minization,nVar,lb,ub,SearchAgents_num,MaxIt,Archive_size,alpha,nGrid,beta,gamma,f_evaluate);
problem.plot_eva(eva_curve);
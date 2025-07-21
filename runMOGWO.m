clear
close all
clc
%% All Lib
addpath('algorithms');
addpath('utils');
addpath('measurement');
addpath('problems');

%% Khai báo hàm mục tiêu
% fobj  - Thông tin của hàm
% nVar  - Số lượng chiều của hàm c
% lb,ub - Điều kiện biên
problem = myFitness();
fobj = @(x) problem.calculation(x);
f_evaluate = @(x, y) problem.evaluate(x, y);
is_maximization_or_minization = problem.is_maximization_or_minization;
nVar = problem.nVar;
lb = problem.LB;	
ub = problem.UB;

%% Đầu vào cho MO-GWO
%GreyWolves_num - Số lượng bầy sói
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
GreyWolves_num = 100;		
MaxIt = 100;  					
Archive_size = 50;   			

%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Grid Inflation Parameter
nGrid = 10;   		% Number of Grids per each Dimension
beta = 4;     		% Leader Selection Pressure Parameter
gamma = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
eva_curve = MOGWO (fobj,is_maximization_or_minization,nVar,lb,ub,GreyWolves_num,MaxIt,Archive_size,alpha,nGrid,beta,gamma,f_evaluate);
problem.plot_eva(eva_curve);





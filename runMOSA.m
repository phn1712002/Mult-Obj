clear
close all
clc
%% All Lib
addpath('algorithms');
addpath('utils');
addpath('measurements');
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
Lb = problem.LB;	
Ub = problem.UB;

%% Đầu vào cho MO-MOSA
%MaxIt      - Maximum Number of Iterations
%MaxSubIt   - Maximum Number of Sub-iterations
%T0         - Initial Temp.
%alpha_rate      - Temp. Reduction Rate
nSol = 50;
MaxIt = 250;      
MaxSubIt = 15;    
T0 = 25;      
alpha_rate = 0.9;     
Archive_size = 100;       

%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
beta = 0.1;     		% Leader Selection Pressure Parameter
gamma = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
eva_curve = MOSA(fobj,is_maximization_or_minization,nVar,Lb,Ub,nSol,MaxIt,MaxSubIt,T0,alpha_rate,Archive_size,alpha,nGrid,beta,gamma,f_evaluate)
problem.plot_eva(eva_curve);
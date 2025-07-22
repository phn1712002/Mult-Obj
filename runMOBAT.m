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
lb = problem.LB;	
ub = problem.UB;

%% Đầu vào cho MO-BAT
%Pop_num        - Số lượng bầy 
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
%Fmax           - Maximum frequency
%Fmin           - Minimum frequency
%alpha          - Constant for loudness update
%gamma          - Constant for emission rate update
%ro             - Initial pulse emission rate
Pop_num = 50;
Fmax=2;                 
Fmin=0;                 
alpha=0.5;              
gamma=0.5;              
ro=0.001;              
MaxIt = 100;  					
Archive_size = 100;   			

%% Các thông số này được lấy mặc định từ code MO-PSO
alphaF = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
betaF = 2;     		% Leader Selection Pressure Parameter
gammaF = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
eva_curve = MOBAT (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,Fmax,Fmin,alpha,gamma,ro,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate);
problem.plot_eva(eva_curve);
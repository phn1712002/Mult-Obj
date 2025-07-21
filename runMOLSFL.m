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

%% Đầu vào cho MO-LSFL
nPopMemeplex = 10;   % Memeplex Size
nMemeplex = 5;       % Number of Memeplexes
% FLA Parameters
alpha = 3;  
beta = 5;
sigma = 2;
%
MaxIt = 100;        % Số lượng vòng lặp					
Archive_size = 50;  % Số lượng kho lưu trữ		

%% Các thông số này được lấy mặc định từ code MO-PSO
alphaF = 0.1;  		% Grid Inflation Parameter
nGrid = 10;   		% Number of Grids per each Dimension
betaF = 4;     		% Leader Selection Pressure Parameter
gammaF = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
eva_curve = MOLSFL(fobj,is_maximization_or_minization,nVar,lb,ub,nPopMemeplex,nMemeplex,alpha,beta,sigma,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate);
problem.plot_eva(eva_curve);




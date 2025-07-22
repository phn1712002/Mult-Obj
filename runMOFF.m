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

%% Đầu vào cho MO-FF
%Pop_num        - Số lượng bầy 
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
Pop_num = 50;
gamma = 1;          % Light Absorption Coefficient
beta0 = 2;          % Attraction Coefficient Base Value
alpha = 0.2;        % Mutation Coefficient
alpha_damp = 0.98;  % Mutation Coefficient Damping Ratio
delta = 0.05;       % Uniform Mutation Range
m = 2;
MaxIt = 100;  					
Archive_size = 100;   			

%% Các thông số này được lấy mặc định từ code MO-PSO
alphaF = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
betaF = 2;     		% Leader Selection Pressure Parameter
gammaF = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
eva_curve = MOFF (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,gamma,beta0,alpha,alpha_damp,delta,m,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate);
problem.plot_eva(eva_curve);
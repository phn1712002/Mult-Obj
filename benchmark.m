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
% is_maximization_or_minization - Max = true, min = false
nVar = 4;
is_maximization_or_minization = false;
problem = ZDTProblems('ZDT1', nVar, is_maximization_or_minization);
fobj = @(x) problem.calculation(x);
f_evaluate = @(x, y) problem.evaluate(x, y);
lb = problem.LB;	
ub = problem.UB;

%% Đầu vào cho MO-BFO
%Pop_num        - Số lượng bầy 
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữS
Pop_num = 50;
Ns = 20;
C = 0.01;
Ped = 0.9;
Nr = 30;    
Nc = 30;
MaxIt = 100;  					
Archive_size = 100;   			

%% Các thông số này được lấy mặc định từ code MO-PSO
alphaF = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
betaF = 2;     		% Leader Selection Pressure Parameter
gammaF = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
eva_curve = MOBFO (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,Ns,C,Ped,Nr,Nc,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate);
problem.plot_eva(eva_curve);
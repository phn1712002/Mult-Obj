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

%% Đầu vào cho MO-DOA
%Pop_num        - Số lượng bầy 
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
Pop_num = 50;
P = 0.5;                % Hunting or Scavenger?  rate.  See section 3.0.4, P and Q parameters analysis
Q = 0.7;                % Group attack or persecution?
MaxIt = 100;  					
Archive_size = 100;   			

%% Các thông số này được lấy mặc định từ code MO-PSO
alphaF = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
betaF = 2;     		% Leader Selection Pressure Parameter
gammaF = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
eva_curve = MODOA (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,P,Q,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate);
problem.plot_eva(eva_curve);
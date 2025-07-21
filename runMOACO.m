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

%% Đầu vào cho MO-ACO
%Ants_num       - Số lượng bầy kiến
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
%q              - Hệ số cường độ % (Áp lực chọn lọc)
%zeta           - Tỷ lệ độ lệch-khoảng cách %
zeta = 1e-5;
q = 0.5;
n_Sample = 50;
Ants_num = 100;               
MaxIt = 100;  					
Archive_size = 50;   			


%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
beta = 2;     		% Leader Selection Pressure Parameter
gamma = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
eva_curve = MOACO(fobj,is_maximization_or_minization,nVar,lb,ub,Ants_num,n_Sample,q,zeta,MaxIt,Archive_size,alpha,nGrid,beta,gamma,f_evaluate);
problem.plot_eva(eva_curve);

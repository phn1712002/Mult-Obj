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

%% Đầu vào cho MO-MOPSO
%Pop_num                - Số lượng bầy chim
%MaxIt                  - Số lượng vòng lặp
%Archive_size           - Số lượng kho lưu trữ
% Weight                - Trọng lượng quán tính
% Weightdamp            - Tỷ lệ giảm xóc theo quán tính
% personalCoefficient   - Hệ số học tập cá nhân
% globalCoefficient     - Hệ số học tập toàn cầu
% mutationRate          - Tỷ lệ đột biến
Pop_num = 50;                         
MaxIt = 100;                           
Archive_size = 50;                    
Weight = 0.5;
Weightdamp = 0.99;
Personal_Coefficient = 1;
Global_Coefficient = 2;
Mutation_Rate = 0.1;
%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
beta = 2;     		% Leader Selection Pressure Parameter
gamma = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
eva_curve = MOPSO (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,MaxIt,Weight,Weightdamp,Personal_Coefficient,Global_Coefficient,Mutation_Rate,Archive_size,alpha,nGrid,beta,gamma,f_evaluate);
problem.plot_eva(eva_curve);
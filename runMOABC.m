clear
close all
clc

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

%% Đầu vào cho MO-ABC
%Bees_num       - Số lượng bầy ong
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
%Limit_Trial    - Giới hạn thử nghiệm thức ăn
Bees_num = 5;                         
MaxIt = 100;                           
Archive_size = 50;                    
Limit_Trial = 100;                        

%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Grid Inflation Parameter
nGrid = 7;   		% Number of Grids per each Dimension
beta = 2;     		% Leader Selection Pressure Parameter
gamma = 2;    		% Extra (to be deleted) Repository Member Selection Pressure

%% Run
eva_curve = MOABC (fobj,is_maximization_or_minization,nVar,lb,ub,Bees_num,Limit_Trial,MaxIt,Archive_size,alpha,nGrid,beta,gamma,f_evaluate);
problem.plot_eva(eva_curve);
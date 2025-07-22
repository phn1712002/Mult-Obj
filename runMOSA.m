clear
close all
clc
%% Bổ sung các thư viện
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
f_callbacks = @(x, y) problem.callbacks(x, y);
is_maximization_or_minization = problem.is_maximization_or_minization;
nVar = problem.nVar;
Lb = problem.LB;	
Ub = problem.UB;

%% Đầu vào cho MO-MOSA
%nSol           - Số lượng bầy 
%MaxIt          - Số lần lặp tối đa
%MaxSubIt       - Số lượng tối đa các lần lặp lại phụ
%T0             - Temp ban đầu.
%alpha_rate     - Hệ số Temp. Tỷ lệ giảm
nSol = 50;
MaxIt = 250;      
MaxSubIt = 15;    
T0 = 25;      
alpha_rate = 0.9;     
Archive_size = 100;       

%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Tham số lạm phát lưới
nGrid = 7;   		% Số lượng lưới cho mỗi chiều
beta = 0.1;     		% Tham số áp suất lựa chọn của người dẫn đầu
gamma = 2;    		% Áp lực lựa chọn thành viên kho lưu trữ bổ sung (sẽ bị xóa)

%% Run
callback_outputs = MOSA(fobj,is_maximization_or_minization,nVar,Lb,Ub,nSol,MaxIt,MaxSubIt,T0,alpha_rate,Archive_size,alpha,nGrid,beta,gamma,f_callbacks)
problem.plot_callbacks(callback_outputs);
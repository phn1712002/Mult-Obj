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
lb = problem.LB;	
ub = problem.UB;

%% Đầu vào cho MO-GWO
%GreyWolves_num - Số lượng bầy sói
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
GreyWolves_num = 100;		
MaxIt = 100;  					
Archive_size = 50;   			

%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Tham số lạm phát lưới
nGrid = 10;   		% Số lượng lưới cho mỗi chiều
beta = 4;     		% Tham số áp suất lựa chọn của người dẫn đầu
gamma = 2;    		% Áp lực lựa chọn thành viên kho lưu trữ bổ sung (sẽ bị xóa)

%% Run
callback_outputs = MOGWO (fobj,is_maximization_or_minization,nVar,lb,ub,GreyWolves_num,MaxIt,Archive_size,alpha,nGrid,beta,gamma,f_callbacks);
problem.plot_callbacks(callback_outputs);





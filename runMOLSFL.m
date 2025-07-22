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
lb = problem.lb;	
ub = problem.ub;

%% Đầu vào cho MO-LSFL
%nPopMemeplex   - Kích thước Memeplex
%nMemeplex      - Số lượng Memeplex
%alpha        
%beta 
%sigma 
%MaxIt          - Số lượng vòng lặp					
%Archive_size   - Số lượng kho lưu trữ	
nPopMemeplex = 10;   
nMemeplex = 5;       
alpha = 3;  
beta = 5;
sigma = 2;
MaxIt = 100;        			
Archive_size = 50;  

%% Các thông số này được lấy mặc định từ code MO-PSO
alphaF = 0.1;  		% Tham số lạm phát lưới
nGrid = 10;   		% Số lượng lưới cho mỗi chiều
betaF = 4;     		% Tham số áp suất lựa chọn của người dẫn đầu
gammaF = 2;    		% Áp lực lựa chọn thành viên kho lưu trữ bổ sung (sẽ bị xóa)

%% Run
callback_outputs = MOLSFL(fobj,is_maximization_or_minization,nVar,lb,ub,nPopMemeplex,nMemeplex,alpha,beta,sigma,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks);
problem.plot_callbacks(callback_outputs);




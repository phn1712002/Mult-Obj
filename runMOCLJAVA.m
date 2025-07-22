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
f_evaluate = @(x, y) problem.evaluate(x, y);
is_maximization_or_minization = problem.is_maximization_or_minization;
nVar = problem.nVar;
lb = problem.LB;	
ub = problem.UB;

%% Đầu vào cho MO-CLJAVA
%Pop_num        - Số lượng 
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
Pop_num = 50;                         
MaxIt = 100;                           
Archive_size = 100;                                          

%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Tham số lạm phát lưới
nGrid = 7;   		% Số lượng lưới cho mỗi chiều
beta = 2;     		% Tham số áp suất lựa chọn của người dẫn đầu
gamma = 2;    		% Áp lực lựa chọn thành viên kho lưu trữ bổ sung (sẽ bị xóa)

%% Run
eva_curve = MOCLJAVA (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,MaxIt,Archive_size,alpha,nGrid,beta,gamma,f_evaluate);
problem.plot_eva(eva_curve);

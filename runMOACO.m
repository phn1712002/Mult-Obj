clear
close all
clc
%% Bổ sung các thư viện
basePath = fileparts(mfilename('fullpath'));
addpath(basePath);
addpath(fullfile(basePath, 'algorithms'));
addpath(fullfile(basePath, 'utils'));
addpath(fullfile(basePath, 'measurements'));
addpath(fullfile(basePath, 'problems'));

%% Khai báo hàm mục tiêu
% fobj  - Thông tin của hàm
% nVar  - Số lượng chiều của hàm c
% lb, ub - Điều kiện biên
problem = myFitness();
fobj = @(x) problem.calculation(x);
f_callbacks = @(x, y) problem.callbacks(x, y);
is_maximization_or_minization = problem.is_maximization_or_minization;
nVar = problem.nVar;
lb = problem.lb;	
ub = problem.ub;

%% Đầu vào cho MO-ACO
%Ants_num       - Số lượng bầy kiến
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
%q              - Hệ số cường độ % (Áp lực chọn lọc)
%zeta           - Tỷ lệ độ lệch - khoảng cách %
zeta = 1e-5;
q = 0.5;
n_Sample = 50;
Ants_num = 100;               
MaxIt = 100;  					
Archive_size = 50;   			


%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Tham số lạm phát lưới
nGrid = 7;   		% Số lượng lưới cho mỗi chiều
beta = 2;     		% Tham số áp suất lựa chọn của người dẫn đầu
gamma = 2;    		% Áp lực lựa chọn thành viên kho lưu trữ bổ sung (sẽ bị xóa)

%% Run
callback_outputs = MOACO(fobj,is_maximization_or_minization,nVar,lb,ub,Ants_num,n_Sample,q,zeta,MaxIt,Archive_size,alpha,nGrid,beta,gamma,f_callbacks);
problem.plot_callbacks(callback_outputs);
save;

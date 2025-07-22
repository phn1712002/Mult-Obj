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
% lb,ub - Điều kiện biên
problem = myFitness();
fobj = @(x) problem.calculation(x);
f_callbacks = @(x, y) problem.callbacks(x, y);
is_maximization_or_minization = problem.is_maximization_or_minization;
nVar = problem.nVar;
lb = problem.lb;	
ub = problem.ub;

%% Đầu vào cho MO-BAT
%Pop_num        - Số lượng bầy 
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
%Fmax           - Tần số tối đa
%Fmin           - Tần số tối thiểuiểu
%alpha          - Hằng số để cập nhật độ lớn
%gamma          - Hằng số cập nhật phát xung
%ro             - Tốc độ phát xung ban đầu
Pop_num = 50;
Fmax=2;                 
Fmin=0;                 
alpha=0.5;              
gamma=0.5;              
ro=0.001;              
MaxIt = 100;  					
Archive_size = 100;   			

%% Các thông số này được lấy mặc định từ code MO-PSO
alphaF = 0.1;  		% Tham số lạm phát lưới
nGrid = 7;   		% Số lượng lưới cho mỗi chiều
betaF = 2;     		% Tham số áp suất lựa chọn của người dẫn đầu
gammaF = 2;    		% Áp lực lựa chọn thành viên kho lưu trữ bổ sung (sẽ bị xóa)

%% Run
callback_outputs = MOBAT (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,Fmax,Fmin,alpha,gamma,ro,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks);
problem.plot_callbacks(callback_outputs);
save;
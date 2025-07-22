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

%% Đầu vào cho MO-FF
%Pop_num        - Số lượng bầy 
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
%amma           - Hệ số hấp thụ ánh sáng
%beta0          - Giá trị cơ sở hệ số hấp dẫn
%alpha          - Hệ số đột biến
%alpha_damp     - Hệ số đột biến Tỷ lệ giảm chấn
%delta          - Phạm vi đột biến đồng nhất
Pop_num = 50;
gamma = 1;          
beta0 = 2;          
alpha = 0.2;        
alpha_damp = 0.98;  
delta = 0.05;       
m = 2;
MaxIt = 100;  					
Archive_size = 100;   			

%% Các thông số này được lấy mặc định từ code MO-PSO
alphaF = 0.1;  		% Tham số lạm phát lưới
nGrid = 7;   		% Số lượng lưới cho mỗi chiều
betaF = 2;     		% Tham số áp suất lựa chọn của người dẫn đầu
gammaF = 2;    		% Áp lực lựa chọn thành viên kho lưu trữ bổ sung (sẽ bị xóa)

%% Run
callback_outputs = MOFF (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,gamma,beta0,alpha,alpha_damp,delta,m,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks);
problem.plot_callbacks(callback_outputs);
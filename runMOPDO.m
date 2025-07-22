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

%% Đầu vào cho MO-MOPDO
%X_num          - Số lượng quần thể
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
%rho            - Giải thích cho sự khác biệt PD của từng cá nhân
%epsPD          - Báo động nguồn thực phẩm
X_num = 50;          
rho = 0.5;
epsPD = 0.1;                
MaxIt = 100;                           
Archive_size = 100;        

%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Tham số lạm phát lưới
nGrid = 7;   		% Số lượng lưới cho mỗi chiều
beta = 0.1;     		% Tham số áp suất lựa chọn của người dẫn đầu
gamma = 2;    		% Áp lực lựa chọn thành viên kho lưu trữ bổ sung (sẽ bị xóa)

%% Run
callback_outputs = MOPDO (fobj,is_maximization_or_minization,nVar,lb,ub,X_num,rho,epsPD,MaxIt,Archive_size,alpha,nGrid,beta,gamma,f_callbacks);
problem.plot_callbacks(callback_outputs);
save;
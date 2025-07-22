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

%% Đầu vào cho MO-DOA
%Pop_num        - Số lượng bầy 
%MaxIt          - Số lượng vòng lặp
%Archive_size   - Số lượng kho lưu trữ
%P = 0.5;       - Tỷ lệ săn bắt hay ăn xác thối? Xem phần 3.0.4, Phân tích các tham số P và Q
%Q = 0.7;       - Tấn công nhóm hay đàn áp?
Pop_num = 50;
P = 0.5;                
Q = 0.7;              
MaxIt = 100;  					
Archive_size = 100;   			

%% Các thông số này được lấy mặc định từ code MO-PSO
alphaF = 0.1;  		% Tham số lạm phát lưới
nGrid = 7;   		% Số lượng lưới cho mỗi chiều
betaF = 2;     		% Tham số áp suất lựa chọn của người dẫn đầu
gammaF = 2;    		% Áp lực lựa chọn thành viên kho lưu trữ bổ sung (sẽ bị xóa)

%% Run
callback_outputs = MODOA (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,P,Q,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks);
problem.plot_callbacks(callback_outputs);
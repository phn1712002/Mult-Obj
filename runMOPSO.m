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

%% Đầu vào cho MO-MOPSO
%Pop_num                - Số lượng bầy chim
%MaxIt                  - Số lượng vòng lặp
%Archive_size           - Số lượng kho lưu trữ
% Weight                - Trọng lượng quán tính
% Weightdamp            - Tỷ lệ giảm xóc theo quán tính
% personalCoefficient   - Hệ số học tập cá nhân
% globalCoefficient     - Hệ số học tập toàn cầu
% mutationRate          - Tỷ lệ đột biến
Pop_num = 50;                         
MaxIt = 100;                           
Archive_size = 50;                    
Weight = 0.5;
Weightdamp = 0.99;
Personal_Coefficient = 1;
Global_Coefficient = 2;
Mutation_Rate = 0.1;
%% Các thông số này được lấy mặc định từ code MO-PSO
alpha = 0.1;  		% Tham số lạm phát lưới
nGrid = 7;   		% Số lượng lưới cho mỗi chiều
beta = 2;     		% Tham số áp suất lựa chọn của người dẫn đầu
gamma = 2;    		% Áp lực lựa chọn thành viên kho lưu trữ bổ sung (sẽ bị xóa)

%% Run
callback_outputs = MOPSO (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,MaxIt,Weight,Weightdamp,Personal_Coefficient,Global_Coefficient,Mutation_Rate,Archive_size,alpha,nGrid,beta,gamma,f_callbacks);
problem.plot_callbacks(callback_outputs);
save;
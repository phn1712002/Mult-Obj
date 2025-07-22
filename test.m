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
% lb,ub - Điều kiện biên
problem = myNet();
fobj = @(x) problem.calculation(x);
f_callbacks = @(x, y) problem.callbacks(x, y);
nVar = problem.nVar;
lb = problem.lb;	
ub = problem.ub;
is_maximization_or_minization = problem.is_maximization_or_minization;

% Copy từ run{Name}.m

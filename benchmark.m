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
nVar = 10;
problem = ZDTProblems('ZDT1', nVar);
fobj = @(x) problem.calculation(x);
f_callbacks = @(x, y) problem.callbacks(x, y);
lb = problem.lb;	
ub = problem.ub;
is_maximization_or_minization = problem.is_maximization_or_minization;

% Copy từ run{Name}.m

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
% is_maximization_or_minization - Max = true, min = false
nVar = 4;
is_maximization_or_minization = false;
problem = ZDTProblems('ZDT1', nVar, is_maximization_or_minization);
fobj = @(x) problem.calculation(x);
f_callbacks = @(x, y) problem.callbacks(x, y);
lb = problem.LB;	
ub = problem.UB;
classdef ZDTProblems
    properties
        name        % Tên hàm ('ZDT1', 'ZDT2', 'ZDT5')
        nVar        % Số biến đầu vào
        nObj        % Số đầu ra (2, 3, hoặc 4)
        lb          % Giới hạn dưới của biến đầu vào
        ub          % Giới hạn trên của biến đầu vào
        true_pareto % Pareto front thực sự (dùng tính IGD/GD/HV)
        is_maximization_or_minization % Lựa chọn giá trị tìm max hoặc min (max - true và min - false
    end
    
    methods
        function obj = ZDTProblems(problem_name, nVar, is_maximization_or_minization)
            % Constructor: Khởi tạo bài toán ZDT
            obj.name = problem_name;
            obj.nVar = nVar;
            obj.is_maximization_or_minization = is_maximization_or_minization;
         
            switch problem_name
                case 'ZDT1'
                    obj.nObj = 2;
                    obj.lb = zeros(1, nVar);
                    obj.ub = ones(1, nVar);
                    
                    % Pareto front thực sự (100 điểm)
                    f1 = linspace(0, 1, 100)';
                    f2 = 1 - sqrt(f1);
                    obj.true_pareto = [f1, f2];
                    
                case 'ZDT2'
                    obj.nObj = 3;
                    obj.lb = zeros(1, nVar);
                    obj.ub = ones(1, nVar);

                    % Pareto front thực sự (100 điểm)
                    f1 = linspace(0, 1, 100)';
                    f2 = 1 - f1.^2;
                    f3 = 1 - f1.^3;
                    obj.true_pareto = [f1, f2, f3];
                    
                case 'ZDT5'
                    obj.nObj = 4;
                    obj.lb = zeros(1, nVar);
                    obj.ub = ones(1, nVar);
                    
                    % Pareto front thực sự (100 điểm)
                    f1 = linspace(0, 1, 100)';
                    f2 = 1 - sqrt(f1);
                    f3 = 1 - f1.^2;
                    f4 = 1 - f1.^3;
                    obj.true_pareto = [f1, f2, f3, f4];
            end
            obj.true_pareto = obj.true_pareto;
        end
        
        function y = calculation(obj, x)    
            if size(x, 2) ~= obj.nVar
                error('Số biến đầu vào không khớp!');
            end
            
            switch obj.name
                case 'ZDT1'
                    f1 = x(:, 1);
                    g = 1 + 9 * sum(x(:, 2:end), 2) / (obj.nVar - 1);
                    f2 = g .* (1 - sqrt(f1 ./ g));
                    y = [f1, f2];
                    
                case 'ZDT2'
                    f1 = x(:, 1);
                    g = 1 + 9 * sum(x(:, 2:end), 2) / (obj.nVar - 1);
                    f2 = g .* (1 - (f1 ./ g).^2);
                    f3 = g .* (1 - (f1 ./ g).^3); % Thêm mục tiêu thứ 3
                    y = [f1, f2, f3];
                    
                case 'ZDT5'
                    f1 = x(:, 1);
                    g = 1 + 9 * sum(x(:, 2:end), 2) / (obj.nVar - 1);
                    f2 = g .* (1 - sqrt(f1 ./ g));
                    f3 = g .* (1 - (f1 ./ g).^2); % Thêm mục tiêu
                    f4 = g .* (1 - (f1 ./ g).^3); % Thêm mục tiêu
                    y = [f1, f2, f3, f4];
            end
            
            % Nếu là bài toán MAXIMIZATION, đảo dấu
            if obj.is_maximization_or_minization
                y = -y;
            end
        end
        
        function  eva_out = callbacks(obj, practice_x, practice_y)
            % Calculate current GD and HV values
            current_gd = calculateGD(practice_y, obj.true_pareto);
            current_hv = calculateHV(practice_y, obj.true_pareto);
            
            % Theo dõi F theo total min của F_n
            total = sum(practice_y, 2);
            [~, IndexMin] = min(total);
            f_monitor = practice_y(IndexMin, :);

            eva_out = [current_gd, current_hv, f_monitor];
        end

        function plot_callbacks(obj, callback_outputs)
            % Update GD plot
            gd_curve = callback_outputs(:,1);
            figure('Name', 'Generational Distance Value Progress');
            plot(gd_curve, 'b-o', 'LineWidth', 2);
            xlabel('Iteration');
            ylabel('GD Value');
            title('Generational Distance Progress');
            grid on;
            
            % Update HV plot
            hv_curve = callback_outputs(:,2);
            figure('Name', 'Hypervolume Value Progress');
            plot(hv_curve, 'r-o', 'LineWidth', 2);
            xlabel('Iteration');
            ylabel('HV Value');
            title('Hypervolume Progress');
            grid on;
            
            drawnow;

            % Update F plot
            f_monitor = callback_outputs(:,end-1:end);
            figure('Name', 'Monitor value F in loop');
            
            label = [];
            for i=1:size(f_monitor, 2)
                text = strcat('F', num2str(i));
                label = [label; text];
                plot(f_monitor(:,i), 'LineWidth', 2);
                hold on;
            end
            legend(label);
            xlabel('Iteration');
            ylabel('Value F');
            title('Monitor value F in loop');
            grid on;
        end
    end
end


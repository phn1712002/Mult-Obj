classdef myFitness
    properties
        nVar        % Số biến đầu vào
        nObj        % Số đầu ra (2, 3, hoặc 4)
        lb          % Giới hạn dưới của biến đầu vào
        ub          % Giới hạn trên của biến đầu vào
        true_pareto % Pareto front thực sự (dùng tính IGD/GD/HV)
        is_maximization_or_minization % Lựa chọn giá trị tìm max hoặc min (max - true và min - false)
    end
    methods
        function obj = myFitness()
            obj.nObj = 3;
            obj.nVar = 3;
            obj.lb = [22, 100, 0.3];
            obj.ub = [26, 140, 0.5];
            obj.is_maximization_or_minization = false;
        end

        function y = calculation(obj, x) % Đầu vào đầu ra là dạng hàng m x 1
            
            f1 = -326.86-27.29*x(1)-13.65*x(3)-25.44*x(1)*x(2);
            f2 = -269.45+23.03*x(1)+13.9*x(2)-17.98*x(3);
            f3 = -2.12+0.3245*x(1)+0.1873*x(2)+0.11*x(1)*x(2)+0.1028*x(1)*x(3)+0.3821*x(2).^2+0.1529*x(3).^2-0.5222*x(1)*x(2).^2;
        
            y = [f1, f2, f3];
            % Nếu là bài toán MAXIMIZATION, đảo dấu
            if obj.is_maximization_or_minization
                y = -y;
            end
        end

        function  output = callbacks(obj, practice_x, practice_y)
            % Theo dõi F theo total min của F_n
            total = sum(practice_y, 2);
            [~, IndexMin] = min(total);
            f_monitor = practice_y(IndexMin, :);

            output = f_monitor;
        end 

        function plot_callbacks(obj, callback_outputs)
            % Update F plot
            f_monitor = callback_outputs(:,1:end);
            nPlots = size(f_monitor, 2);
            
            for i=1:nPlots
                figure('Name', ['Monitor F' num2str(i) ' in loop']);
                plot(f_monitor(:,i), 'LineWidth', 2);
                title(['F' num2str(i)]);
                xlabel('Iteration');
                ylabel('Value F');
                grid on;
                drawnow;
            end
        end
        
    end
end

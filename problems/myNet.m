classdef myNet
    properties
        name        % Tên file
        net       	% net
        nVar        % Số biến đầu vào
        nObj        % Số đầu ra (2, 3, hoặc 4)
        lb          % Giới hạn dưới của biến đầu vào
        ub          % Giới hạn trên của biến đầu vào
        true_pareto % Pareto front thực sự (dùng tính IGD/GD/HV)
        is_maximization_or_minization % Lựa chọn giá trị tìm max hoặc min (max - true và min - false)
    end
    methods
        function obj = myNet()
            obj.name = 'problems/model_Y5_Y8.mat';
            loadedVars = load(obj.name);

            if isfield(loadedVars, 'net')
                obj.net = loadedVars.net;
            else
                error('Loaded file does not contain required "net" variable');
            end

            obj.nObj = obj.net.outputs{end}.size;
            obj.nVar = obj.net.inputs{1}.size;
            obj.lb = [0 0 0 0];
            obj.ub = [1 1 1 1];
            obj.is_maximization_or_minization = false;
        end

        function y = calculation(obj, x) % Đầu vào đầu ra là dạng hàng m x 1  
            y = obj.net(x')';
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

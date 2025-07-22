function plotChart(Archive, n, n_dims, size_ponit, is_maximization_or_minization)


    if is_maximization_or_minization
         Archive_costs=-GetCosts(Archive);
         n_costs=-GetCosts(n);
    else
         Archive_costs=GetCosts(Archive);
         n_costs=GetCosts(n);
    end

    % Vẽ đồ thị động
    persistent figHandle1;
    persistent figHandle2;
    persistent figHandle3;
    persistent figHandle4;
    
    figHandle1= checkfigHandle(figHandle1, 'Pareto Front');
    figHandle2 = checkfigHandle(figHandle2, 'Pareto Front 2');
    figHandle3 = checkfigHandle(figHandle3, 'Pareto Front 3');
    figHandle4= checkfigHandle(figHandle4, 'Pareto Front4');
    

    hold off
    if(n_dims == 2)
        y1_n = n_costs(1, :);
        y2_n = n_costs(2, :);
        y1_ar = Archive_costs(1, :);
        y2_ar = Archive_costs(2, :);
        figure(figHandle1);
        plot2D(y1_n, y2_n, y1_ar, y2_ar, size_ponit, 'f1', 'f2', 'Pareto Front');
    end
    
    if(n_dims == 3)
        y1_n = n_costs(1, :);
        y2_n = n_costs(2, :);
        y3_n = n_costs(3, :);

        y1_ar = Archive_costs(1, :);
        y2_ar = Archive_costs(2, :);
        y3_ar = Archive_costs(3, :);

        figure(figHandle1);
        plot3D(y1_n, y2_n, y3_n, y1_ar, y2_ar, y3_ar, size_ponit, 'f1', 'f2', 'f3', 'Pareto Front 3D')
        
        figure(figHandle2);
        plot2D(y1_n, y2_n, y1_ar, y2_ar, size_ponit, 'f1', 'f2', 'Pareto Front f1 vs f2');
        
        figure(figHandle3);
        plot2D(y1_n, y3_n, y1_ar, y3_ar, size_ponit, 'f1', 'f3', 'Pareto Front f1 vs f3');
        
        figure(figHandle4);
        plot2D(y2_n, y3_n, y2_ar, y3_ar, size_ponit, 'f2', 'f3', 'Pareto Front f2 vs f3');

    end
    drawnow
end

function plot2D(y1_n, y2_n, y1_ar, y2_ar, size_ponit, x_label, y_label, title_plot)
    scatter(y1_n, y2_n, size_ponit*3, 'r', 'filled');
    hold on 
    scatter(y1_ar, y2_ar, size_ponit, 'b', 'filled');
    xlabel(x_label); ylabel(y_label);
    title(title_plot);
    grid on
end

function plot3D(y1_n, y2_n, y3_n, y1_ar, y2_ar, y3_ar, size_ponit, x_label, y_label, z_label, title_plot)
    scatter3(y1_n, y2_n, y3_n, size_ponit*3, 'r', 'filled');
    hold on
    scatter3(y1_ar, y2_ar, y3_ar, size_ponit, 'b', 'filled');
    xlabel(x_label); ylabel(y_label); zlabel(z_label);
    title(title_plot);
     grid on
end

function figHandle = checkfigHandle(figHandle, name_fig)
    if isempty(figHandle) || ~isvalid(figHandle)
        figHandle = figure('Name', name_fig);
    end
end
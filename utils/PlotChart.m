function PlotChart(Archive, n, n_dims, size_ponit, is_maximization_or_minization)


    if is_maximization_or_minization
         Archive_costs=-GetCosts(Archive);
         n_costs=-GetCosts(n);
    else
         Archive_costs=GetCosts(Archive);
         n_costs=GetCosts(n);
    end

    % Vẽ đồ thị động
    persistent figHandle;
    if isempty(figHandle) || ~isvalid(figHandle)
        figHandle = figure('Name', 'Pareto Front Progress');
    else
        figure(figHandle);
    end

    hold off
    if(n_dims == 2)
        y1 = n_costs(1, :);
        y2 = n_costs(2, :);
        scatter(y1, y2, size_ponit*3, 'r', 'filled');
        hold on 
        y1 = Archive_costs(1, :);
        y2 = Archive_costs(2, :);
        scatter(y1, y2, size_ponit, 'b', 'filled');
        drawnow
        xlabel('Object 1'); ylabel('Object 2');
        title('Pareto Front');
    end
    
    if(n_dims == 3)
        y1 = n_costs(1, :); 
        y2 = n_costs(2, :);
        y3 = n_costs(3, :);
        scatter3(y1, y2, y3, size_ponit*3, 'r', 'filled');
        hold on
        y1 = Archive_costs(1, :); 
        y2 = Archive_costs(2, :);
        y3 = Archive_costs(3, :);
        scatter3(y1, y2, y3, size_ponit, 'b', 'filled');
        xlabel('Object 1'); ylabel('Object 2'); zlabel('Object 3');
        title('Pareto Front');
    end
    grid on
    drawnow
end

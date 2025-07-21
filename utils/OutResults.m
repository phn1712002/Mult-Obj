function OutResults(Archive, is_maximization_or_minization)
    if is_maximization_or_minization
         Archive_costs=-GetCosts(Archive);
    else
         Archive_costs=GetCosts(Archive);
    end

    Archive_posi=GetPosition(Archive);
    index_X = size(Archive_posi, 1); % Số lượng X (X1, X2, ..., Xi)
    index_Y = size(Archive_costs, 1); % Số lượng Y (Y1, Y2, ..., Yk)
    
    disp("Optimal_solution X[1:" + num2str(index_X) + "]")
    disp(num2str(Archive_posi'));
    disp("")
    disp("Optimal_cost Y[1:" + num2str(index_Y) + "]");
    disp(num2str(Archive_costs'));
    
    % Tạo danh sách cột
    columnNames = cell(1, index_X + index_Y); % Khởi tạo danh sách rỗng

    % Thêm các cột X1 đến Xi
    for idx = 1:index_X
        columnNames{idx} = ['X', num2str(idx)];
    end

    % Thêm các cột Y1 đến Yk
    for idx = 1:index_Y
        columnNames{index_X + idx} = ['Y', num2str(idx)];
    end
    
    % Sao lưu file excel
    data_excel_ouput =  [Archive_posi', Archive_costs'];
    table_excel_output = array2table(data_excel_ouput, 'VariableNames', columnNames);
    SaveTableToExcel(table_excel_output, "Optimal.xlsx"); 
end
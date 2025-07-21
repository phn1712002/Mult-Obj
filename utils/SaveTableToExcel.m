function SaveTableToExcel(inputTable, outputPath)
    % Hàm lưu table vào file Excel
    %
    % inputTable: Dữ liệu dạng table cần lưu
    % outputPath: Đường dẫn file Excel để lưu (bao gồm tên file và đuôi .xlsx)
    
    % Kiểm tra xem đầu vào có phải là table không
    if ~istable(inputTable)
        error('Đầu vào không phải là table.');
    end
    
    % Kiểm tra xem đường dẫn có đuôi .xlsx không
    [~, ~, ext] = fileparts(outputPath);
    if ~strcmp(ext, '.xlsx')
        error('File output phải có đuôi .xlsx');
    end
    
    % Lưu table vào file Excel
    try
        writetable(inputTable, outputPath);
        disp(['Table đã được lưu thành công vào: ', outputPath]);
    catch ME
        disp('Đã xảy ra lỗi khi lưu table:');
        disp(ME.message);
    end
end

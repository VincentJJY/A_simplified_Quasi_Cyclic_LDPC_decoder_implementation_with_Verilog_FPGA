% 打开文件写入
fileID = fopen('vnpu_test_vectors.txt', 'w');

% 设置变量名称列表
var_names = {'I1', 'I2', 'I3', 'I4', 'Z'};

% 生成32组，每组6行（其中5行数据，最后一行为延迟）
num_groups = 32;
num_lines_per_group = 6;

for group = 1:num_groups
    % 每组内生成随机的二进制数
    for line = 1:num_lines_per_group-1
        % 生成随机的16位二进制数
        random_binary = randi([0, 1], 1, 16);
        binary_str = sprintf('%d', random_binary);
        
        % 写入文件
        fprintf(fileID, '%s = 16''b%s; \n', var_names{line}, binary_str);
    end
    
    % 添加延迟行
    fprintf(fileID, '#20;\n\n');
end

% 关闭文件
fclose(fileID);

disp('cnpu_test_vectors.txt 文件已生成。');

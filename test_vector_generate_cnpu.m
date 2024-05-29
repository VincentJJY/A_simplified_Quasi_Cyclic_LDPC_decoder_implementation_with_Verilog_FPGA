% 打开文件写入
fileID = fopen('cnpu_test.txt', 'w');

% 设置变量名前缀
var_prefix = 'Lcn_';

% 生成32组信号，每组32行
num_groups = 32;
num_lines_per_group = 32;

for group = 1:num_groups
    % 写入文件每组的头部
    fprintf(fileID, '#20;\n', group);
    
    for line = 0:num_lines_per_group-1
        % 生成随机的16位二进制数
        random_binary = randi([0, 1], 1, 16);
        binary_str = sprintf('%d', random_binary);
        
        % 写入文件
        fprintf(fileID, '%s%d = 16''b%s;\n', var_prefix, line, binary_str);
    end
    
    % 添加分组间的空行
    fprintf(fileID, '\n');
end

% 关闭文件
fclose(fileID);

disp('cnpu_test.txt 文件已生成。');

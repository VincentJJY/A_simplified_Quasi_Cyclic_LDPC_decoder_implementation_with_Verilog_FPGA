% 定义采样范围为0到1的65536个均匀采样点
% Define 65536 uniformly sampled points in the range 0 to 1
samples = linspace(0, 1, 65536);

% 计算输入x，范围从0到65535，对应16位无符号整数
% Calculate input x, range from 0 to 65535, corresponding to 16-bit unsigned integer
x = samples * 65535;

% 初始化 y
% Initialize y
y = zeros(size(samples));

% 使用给定公式计算y
% Calculate y using the given formula
%计算 y = -log(tanh(x/2))，并根据 x 的正负处理符号
% Calculate phi(x) = -log(tanh(x/2)) and handle sign based on x
for i = 1:length(samples)
    if samples(i) > 0
        y = -log(tanh(samples(i)/2));
    else
        y = log(tanh(abs(samples(i))/2));  % 对于 x < 0 去掉负号
    end
end

% 绘制函数图像
% Plot the function
figure;
plot(samples, y);
title('y = -log(tanh(x/2))');
xlabel('x ');
ylabel('y');
grid on;

% 检查并处理复数和无穷大值
% Check and handle complex and infinite values
y = abs(y); % 取模 % Take absolute value to remove imaginary part
y(isinf(y)) = 0; % 将无穷大值替换为0 % Replace infinite values with 0

% 计算所有y值的平均值
% Calculate the average value of all y values
y_mean = mean(y);

% 将每个y值除以平均值，然后乘以2^7
% Divide each y value by the mean and then multiply by 2^7
y_normalized = (y / y_mean) * (2^7);

% 将结果转换为二进制表示，截取低7位
% Convert the result to binary and take the lower 7 bits
y_binary7 = arrayfun(@(num) dec2bin(mod(round(num), 128), 7), y_normalized, 'UniformOutput', false);

% 在7位二进制字符串前面补充9个零，转换为16位二进制补码
% Pad 7-bit binary strings with 9 zeros to convert to 16-bit two's complement
pad7to16 = @(bin7) ['000000000', bin7];
y_twoscomp16 = cellfun(pad7to16, y_binary7, 'UniformOutput', false);

% 将x值转换为16位无符号二进制表示
% Convert x values to 16-bit unsigned binary representation
x_binary16 = arrayfun(@(num) dec2bin(num, 16), round(x), 'UniformOutput', false);

% 打开文件以写入输出
% Open a file to write the output
fileID = fopen('out_b.txt', 'w');

% 写入结果
% Write the results
for i = 1:length(x)
    fprintf(fileID, '16''b%s : phi_x = 16''b%s;\n', x_binary16{i}, y_twoscomp16{i});
end

% 关闭文件
% Close the file
fclose(fileID);
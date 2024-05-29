% 定义6位二进制补码的取值范围
% Define the range of 6-bit two's complement values
x = [-32:-1 0 1:31];

% 使用给定公式计算y
% Calculate y using the given formula
y = -log(tanh(abs(x/2)));

% 检查并处理复数和无穷大值
% Check and handle complex and infinite values
y = abs(y); % 取模 % Take absolute value to remove imaginary part
y(isinf(y)) = 0; % 将无穷大值替换为0 % Replace infinite values with 0

% 绘制函数图像
% Plot the function
figure;
plot(x, y);
title('y = -log(tanh(x/2))');
xlabel('x ');
ylabel('y');
grid on;

% 函数将十进制数转换为6位二进制补码
% Function to convert decimal to 6-bit two's complement binary
dec2twoscomp6 = @(num) dec2bin(mod(num, 64), 6);

% 非均匀量化的策略
% Non-uniform quantization strategy:
%  - 对于不同范围的y值使用不同的量化精度
%  - Use different quantization precision for different ranges of y values
%  - 0 ≤ y < 3: 使用6:4量化方案，表示4位精度
%  - 0 ≤ y < 3: Use 6:4 quantization scheme, representing 4-bit precision
%  - 3 ≤ y < 4.875: 使用6:3量化方案，表示3位精度
%  - 3 ≤ y < 4.875: Use 6:3 quantization scheme, representing 3-bit precision
%  - y ≥ 4.875: 值为0
%  - y ≥ 4.875: Value is 0

% 定义非均匀量化函数
% Define the non-uniform quantization function
nonUniformQuantize = @(y) ...
    (y < 3) .* round(y * (2^4)) + ...   % 6:4量化方案 % 6:4 quantization scheme
    (y >= 3 & y < 4.875) .* round(y * (2^3));  % 6:3量化方案 % 6:3 quantization scheme

% 应用非均匀量化到y值
% Apply non-uniform quantization to y values
y_quantized = nonUniformQuantize(y);

% 将量化后的值转换为6位二进制源码
% Convert quantized values to 6-bit binary code
y_binary6 = arrayfun(@(num) dec2bin(mod(num, 64), 6), y_quantized, 'UniformOutput', false);

% 将6位二进制源码转换为6位二进制补码
% Convert 6-bit binary code to 6-bit two's complement
binary2twoscomp = @(bin) dec2bin(mod(bin2dec(bin) - 32, 64), 6);

y_twoscomp6 = cellfun(binary2twoscomp, y_binary6, 'UniformOutput', false);

% 创建数组以存储6位二进制补码值
% Create arrays to store the 6-bit two's complement binary values
x_twoscomp6 = arrayfun(@(num) dec2twoscomp6(num), x, 'UniformOutput', false);

% 显示结果
% Display the results
for i = 1:length(x)
    fprintf('x = %6s, y = %10.6f, quantized y = %3d, y (6-bit binary) = %6s, y (6-bit two''s complement) = %6s\n', ...
        x_twoscomp6{i}, y(i), y_quantized(i), y_binary6{i}, y_twoscomp6{i});
end

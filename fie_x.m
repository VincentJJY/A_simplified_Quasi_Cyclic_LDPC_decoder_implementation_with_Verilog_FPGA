% Define the range of 8-bit two's complement values
x = [-128:-1 1:127];

% Calculate y using the given formula
y = -log(tanh(x/2));

% Plot the function
figure;
plot(x, y);
title('y = -log(tanh(x/2))');
xlabel('x (8-bit two''s complement)');
ylabel('y');
grid on;

% Function to convert decimal to 8-bit two's complement binary
dec2twoscomp8 = @(num) dec2bin(typecast(int8(num), 'uint8'), 8);

% Function to convert decimal to 16-bit two's complement binary
dec2twoscomp16 = @(num) dec2bin(typecast(int16(num), 'uint16'), 16);

% Create arrays to store the 8-bit and 16-bit two's complement binary values
x_twoscomp8 = arrayfun(dec2twoscomp8, x, 'UniformOutput', false);
x_twoscomp16 = arrayfun(dec2twoscomp16, x, 'UniformOutput', false);

% Display the results
for i = 1:length(x)
    fprintf('x = %8s, y = %10.6f, 16-bit two''s complement = %s\n', x_twoscomp8{i}, y(i), x_twoscomp16{i});
end


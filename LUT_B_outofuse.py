import numpy as np
import matplotlib.pyplot as plt

def phi(x):
    if x == 0:
        return float('inf')  # 避免 log(0) 的计算
    return -np.log(np.tanh(x / 2))

def phi_prime(x):
    abs_x = abs(x)
    phi_val = phi(abs_x)
    if np.isinf(phi_val):
        phi_val = 32767  # 16位二进制补码的最大正值
    if x < 0:
        return -phi_val
    else:
        return phi_val

# 计算-127到127的phi_prime值，并转换为16位二进制补码
x_values = np.arange(-128, 128)
phi_prime_values = [phi_prime(x) for x in x_values]
phi_prime_scaled = [int(val * (2**10)) for val in phi_prime_values]
phi_prime_bin = [np.binary_repr(val if val >= 0 else (1 << 16) + val, width=16) for val in phi_prime_scaled]

for i, val in enumerate(phi_prime_bin):
    print(f"8'd{i-128}: phi_prime_x = 16'b{val};")

# 绘制phi_prime函数的曲线图
plt.plot(x_values, phi_prime_values, label="phi'(x)")
plt.xlabel("x")
plt.ylabel("phi'(x)")
plt.title("phi'(x) vs x")
plt.legend()
plt.grid(True)
plt.show()
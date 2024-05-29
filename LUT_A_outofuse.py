import numpy as np

def phi(x):
    tanh_x_over_2 = np.tanh(x / 2)
    if tanh_x_over_2 == 0:
        return np.inf  # or return a large finite number if infinity is not desired
    return -np.log(tanh_x_over_2)

# Compute phi values from 0 to 255 and convert to 16-bit signed binary representation
phi_values = []
for x in range(256):
    value = phi(x)
    if np.isinf(value):
        phi_values.append(0)  # Handle infinity case, here returning 0 for simplicity
    else:
        phi_values.append(int(value * (2**10)))

phi_bin = [np.binary_repr(val, width=16) if val >= 0 else np.binary_repr((1 << 16) + val, width=16) for val in phi_values]

for i, val in enumerate(phi_bin):
    print(f"8'd{i}: phi_x = 16'b{val};")
#!/usr/bin/env python
# coding: utf-8

# In[4]:


import pandas as pd
from SALib.analyze import sobol
import numpy as np
import itertools

# Load parameter values and model output
param_values_path = '/g/data/vw43/cm9768/HPsim/Final/param_values_all_Final.csv'
param_values = pd.read_csv(param_values_path)

csv_file_path = '/g/data/vw43/cm9768/HPsim/Final/PSoup_Output.csv'
data = pd.read_csv(csv_file_path)
Y = data['Model_Output'].values  # Convert to a NumPy array

# Define the problem dictionary
problem = {
    'num_vars': len(param_values.columns),
    'names': param_values.columns.tolist(),
    'bounds': [[0, 3]] * len(param_values.columns)  # Adjust bounds as needed
}

# Perform Sobol analysis
sobol_indices = sobol.analyze(problem, Y, parallel = True, n_processors = 8, num_resamples=1000)

# Create DataFrame for first- and total-order indices
param_names = param_values.columns.tolist()
df_first_total = pd.DataFrame({
    'Parameter': param_names,
    'First-order Sobol index': sobol_indices['S1'],
    'Total-order Sobol index': sobol_indices['ST']
})

# Save first- and total-order indices to CSV
df_first_total.to_csv('/g/data/vw43/cm9768/HPsim/Final/sobol_indices_first_total.csv', index=False)

# Create DataFrame for second-order indices
S2_matrix = sobol_indices['S2']
# Create pairs for each combination of parameters
pairs = list(itertools.product(param_names, repeat=2))
df_second_order = pd.DataFrame(pairs, columns=['Parameter 1', 'Parameter 2'])
df_second_order['Second-order Sobol index'] = S2_matrix.flatten()

# Save second-order indices to CSV
df_second_order.to_csv('/g/data/vw43/cm9768/HPsim/Final/sobol_indices_second_order.csv', index=False)


import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

base_path = r"C:\Users\garba\OneDrive\桌面\大四下\人類訊號處理"

df5  = pd.read_csv(f"{base_path}\\workload_5d_sub040.csv",  encoding='latin1', header=0)
df9  = pd.read_csv(f"{base_path}\\workload_9d_sub040.csv",  encoding='latin1', header=0)
df13 = pd.read_csv(f"{base_path}\\workload_13d_sub040.csv", encoding='latin1', header=0)

def split_conditions(df):
    id_col  = df.iloc[:, 0] 
    val_col = df.iloc[:, 1] 
    memory  = val_col[id_col.str.startswith('6')].values.astype(float)
    control = val_col[id_col.str.startswith('5')].values.astype(float)
    return memory, control

mem5,  ctrl5  = split_conditions(df5)
mem9,  ctrl9  = split_conditions(df9)
mem13, ctrl13 = split_conditions(df13)

# Grouped Bar Chart 
fig, ax = plt.subplots(figsize=(8, 5))

labels     = ['5 digits', '9 digits', '13 digits']
mem_means  = [mem5.mean(),  mem9.mean(),  mem13.mean()]
ctrl_means = [ctrl5.mean(), ctrl9.mean(), ctrl13.mean()]
mem_sems   = [mem5.std()/np.sqrt(len(mem5)),   mem9.std()/np.sqrt(len(mem9)),   mem13.std()/np.sqrt(len(mem13))]
ctrl_sems  = [ctrl5.std()/np.sqrt(len(ctrl5)), ctrl9.std()/np.sqrt(len(ctrl9)), ctrl13.std()/np.sqrt(len(ctrl13))]

x = np.arange(len(labels))
w = 0.35

ax.bar(x - w/2, mem_means,  w, yerr=mem_sems,  capsize=5, label='Memory',  color='steelblue',  alpha=0.85)
ax.bar(x + w/2, ctrl_means, w, yerr=ctrl_sems, capsize=5, label='Control', color='lightcoral', alpha=0.85)

ax.set_xlabel('Cognitive Load Condition', fontsize=12)
ax.set_ylabel('Mean Frontal Theta/Alpha Ratio (Workload Index)', fontsize=12)
ax.set_title('Frontal Theta/Alpha Ratio across Cognitive Load Conditions\n(Sub-040)', fontsize=13)
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend()
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
plt.tight_layout()
plt.savefig(f"{base_path}\\fig1_bar_chart.png", dpi=150)
plt.show()

# Line Plot（trial-by-trial
fig, axes = plt.subplots(1, 3, figsize=(14, 4), sharey=True)

for ax, mem, ctrl, label in zip(axes,
                                 [mem5,  mem9,  mem13],
                                 [ctrl5, ctrl9, ctrl13],
                                 ['5 digits', '9 digits', '13 digits']):
    ax.plot(range(len(mem)),  mem,  'o-',  color='steelblue',  label='Memory',  markersize=4)
    ax.plot(range(len(ctrl)), ctrl, 's--', color='lightcoral', label='Control', markersize=4)
    ax.axhline(mem.mean(),  color='steelblue',  linestyle=':', linewidth=1.2)
    ax.axhline(ctrl.mean(), color='lightcoral', linestyle=':', linewidth=1.2)
    ax.set_title(label, fontsize=12)
    ax.set_xlabel('Trial Index', fontsize=10)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

axes[0].set_ylabel('Frontal Theta/Alpha Ratio', fontsize=11)
axes[1].legend(loc='upper right', fontsize=9)
fig.suptitle('Trial-by-Trial Frontal Theta/Alpha Ratio (Sub-040)', fontsize=13, y=1.02)
plt.tight_layout()
plt.savefig(f"{base_path}\\fig2_line_plot.png", dpi=150, bbox_inches='tight')
plt.show()
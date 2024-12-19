
import argparse
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

sns.set_theme(style='ticks', rc={
    'figure.figsize': (8, 4),  # figure size in inches
    'axes.labelsize': 16,           # font size of the x and y labels
    'xtick.labelsize': 16,          # font size of the tick labels
    'ytick.labelsize': 16,          # font size of the tick labels
    'legend.fontsize': 16,          # font size of the legend
    "axes.spines.right": False, 
    "axes.spines.top": False})


# read in input with args
parser = argparse.ArgumentParser(description='Create a heatmap of the comparison of the two mapping methods')

parser.add_argument('input', type=str, help='Input file with the comparison of the two mapping methods')

args = parser.parse_args()


# read in the input file
input_file = args.input
data = pd.read_csv(input_file, delimiter='\t')

print(data.head())
# count the frequencies of the different value combinations of mapping_category_competetive and mapping_category_seperate 
# split the data into correct and incorrect mappings
data_incorrect = data[data['mapping_location_seperate'] != data['mapping_location_competetive']]
data_correct = data[data['mapping_location_seperate'] == data['mapping_location_competetive']]

heatmap_data_correct = data_correct.groupby(['mapping_category_competetive', 'mapping_category_seperate']).size().unstack(fill_value=0)
# divide each count my row number of data

#heatmap_data_correct = heatmap_data_correct/len(data)


heatmap_data_incorrect = data_incorrect.groupby(['mapping_category_competetive', 'mapping_category_seperate']).size().unstack(fill_value=0)
# turn absolute counts into relative counts
#heatmap_data_incorrect = heatmap_data_incorrect/len(data)

print(heatmap_data_incorrect )

print(heatmap_data_correct )



fig, ax = plt.subplots(1, 2, figsize=(15, 5))

sns.heatmap(heatmap_data_correct, annot=True, fmt='d', ax=ax[0])
ax[0].set_title('Correct mappings')
ax[0].set_xlabel('Mapping category seperate')
ax[0].set_ylabel('Mapping category competetive')
# plot the other heatmap
sns.heatmap(heatmap_data_incorrect, annot=True,  fmt='d', ax=ax[1], )
ax[1].set_title('Incorrect mappings')
ax[1].set_xlabel('Mapping category seperate')
ax[1].set_ylabel('Mapping category competetive')


plt.tight_layout()
plt.savefig(f"correct_mappings_heatmap.png", dpi=300, bbox_inches='tight', transparent=True)

# save the heatmap
#plt.savefig('correct_mappings_heatmap.png', )
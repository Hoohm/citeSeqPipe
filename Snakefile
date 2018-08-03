import pandas as pd
import os
import re

# Load configuration file
configfile: "config.yaml"

# Get sample names from samples.csv
samples = pd.read_table("samples.csv", header=0, sep=',', index_col=0)


# Constraint sample names wildcards
wildcard_constraints:
    sample="({})".format("|".join(samples.index))


rule all:
    input:
        #mapping
        expand('data/{sample}_results.csv', sample=samples.index),
        'test_py.txt',
        'test_R.txt'
        
        
        
rule map:
    input:  
        expand('data/{sample}_results.csv', sample=samples.index)
        
        
include: "rules/map.smk"

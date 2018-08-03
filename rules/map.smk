ruleorder: CITE_count_whitelist > CITE_count

rule CITE_count:
	input:
		R1='data/{sample}_R1.fastq.gz',
		R2='data/{sample}_R2.fastq.gz',
		TAG_ref=config['TAG_file']
	params:
		expected_cells=lambda wildcards: samples.loc[samples.index, 'expected_cells'],
		BC_start=config['cell-barcode']['start'],
		BC_end=config['cell-barcode']['end'],
		UMI_start=config['UMI-barcode']['start'],
		UMI_end=config['UMI-barcode']['end'],
		max_TAG_barcode_distance=config['max_TAG_barcode_distance'],
		TAG_regex=config['TAG_regex']
	output:
		counts='data/{sample}_results.csv'
	conda:
		'../envs/CITE.yaml'
	script:
		"../scripts/CITE-seq-count.py"

rule CITE_count_whitelist:
	input:
		R1='data/{sample}_R1.fastq.gz',
		R2='data/{sample}_R2.fastq.gz',
		TAG_ref=config['TAG_file'],
		cell_whitelist='barcodes.csv'
	params:
		BC_start=config['cell-barcode']['start'],
		BC_end=config['cell-barcode']['end'],
		UMI_start=config['UMI-barcode']['start'],
		UMI_end=config['UMI-barcode']['end'],
		max_TAG_barcode_distance=config['max_TAG_barcode_distance'],
		TAG_regex=config['TAG_regex']
	output:
		counts='data/{sample}_results.csv'
	conda:
		'../envs/CITE.yaml'
	script:
		"../scripts/CITE-seq-count.py -wl {input.cell_whitelist} -o results.tsv -R1 {input.R1} -R2 {input.R2} -t {input.TAG_ref} -cbf {params.BC_start} -cbl {params.BC_end} -umif {params.UMI_start} -umil {params.UMI_end} -hd {params.max_TAG_barcode_distance} -tr {params.TAG_regex}"

rule test_py:
	input:
		R1='data/test_R1.fastq.gz'
	output:
		'test_py.txt'
	script:
		'../scripts/test.py'

rule test_R:
	input:
		R1='data/test_R1.fastq.gz'
	output:
		'test_R.txt'
	script:
		'../scripts/test.R'
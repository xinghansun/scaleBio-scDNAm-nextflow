### HPC ENV ###
conda deactivate
module load nextflow/24.04.4 singularity/3.8.2

### CONFIGS ###
BATCH=20240905_LH00130_0079_A22NYLJLT3_Gaiti_Pai

INPUT_DIR=/.mounts/labs/pailab/private/projects/MB_scDNAme/processed_input/scaleBio_pilot/${BATCH}
OUTPUT_DIR=/.mounts/labs/pailab/private/projects/MB_scDNAme/output/scaleBio_pilot/${BATCH}/ScaleMethyl_output

EMAIL=xsun@oicr.on.ca

SCALEMETHYL_DIR=/.mounts/labs/pailab/private/xsun/Github/MB_ITH/scDNAm/scaleBio/processingRaw/Tools/ScaleMethyl-main/
CONFIG_FILE=/.mounts/labs/pailab/private/xsun/Github/MB_ITH/scDNAm/scaleBio/processingRaw/config/oicr_hpc.config
PARAMS_FILE=/.mounts/labs/pailab/private/xsun/Github/MB_ITH/scDNAm/scaleBio/processingRaw/Tools/ScaleMethyl-main/docs/examples/runParams.yml
GENOME_JSON=/.mounts/labs/pailab/private/xsun/Database/scaleMethyl/reference/genome.json
SAMPLE_CSV=/.mounts/labs/pailab/private/projects/MB_scDNAme/input/scaleBio_pilot/sample/20240905_LH00130_0079_A22NYLJLT3_Gaiti_Pai/ScaleMethyl-small-kit-2_samples.csv

### VALIDATE FILE ###
num_R1=$(ls ${INPUT_DIR}/ScaleMethyl-small-kit-2_*_R1_*.fastq.gz 2>/dev/null | wc -l)
num_I1=$(ls ${INPUT_DIR}/ScaleMethyl-small-kit-2_*_I1_*.fastq.gz 2>/dev/null | wc -l)
num_R2=$(ls ${INPUT_DIR}/ScaleMethyl-small-kit-2_*_R2_*.fastq.gz 2>/dev/null | wc -l)
num_I2=$(ls ${INPUT_DIR}/ScaleMethyl-small-kit-2_*_I2_*.fastq.gz 2>/dev/null | wc -l)

### Create DIR for nextflow ###
if [ "$num_R1" -ne "$num_I1" ] || [ "$num_R2" -ne "$num_I2" ]; then
    echo "--- Number of INDEX and SEQUENCE fastq files do not match!"
    exit 1
else
    mkdir -p ${OUTPUT_DIR}
    cd ${OUTPUT_DIR}

    qsub -P pailab -V -cwd -b y -N scalemb -M ${EMAIL} -m ea \
    	-l h_rt=5:0:0:0,h_vmem=1G -pe smp 4 \
    	nextflow run ${SCALEMETHYL_DIR} \
    	-profile singularity \
    	-c ${CONFIG_FILE} \
    	-params-file ${PARAMS_FILE} \
    	--genome ${GENOME_JSON} \
    	--fastqDir ${INPUT_DIR} \
    	--samples ${SAMPLE_CSV} \
    	--outDir ${OUTPUT_DIR}
fi










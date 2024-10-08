### CONFIGS ###
BATCH=20240905_LH00130_0079_A22NYLJLT3_Gaiti_Pai

INPUT_DIR=/.mounts/labs/pailab/private/projects/MB_scDNAme/input/scaleBio_pilot/raw/${BATCH}
OUTPUT_DIR=/.mounts/labs/pailab/private/projects/MB_scDNAme/processed_input/scaleBio_pilot/${BATCH}

### MAIN ###
## COPY FASTQ ##
mkdir -p ${OUTPUT_DIR}
cp ${INPUT_DIR}/ScaleMethyl-small-kit-2_*_R{1,2}_*.fastq.gz ${OUTPUT_DIR}

## EXTRACT INDEX ##
ls ${OUTPUT_DIR}/ScaleMethyl-small-kit-2_*_R1_*.fastq.gz | while read file; do
	echo "--- Generating INDEX file for ${file}."
	python3 ../Tools/ScaleUtilities-main/makeIndexFqs.py ${file} --outDir ${OUTPUT_DIR}
done

echo "--- Finished ---"
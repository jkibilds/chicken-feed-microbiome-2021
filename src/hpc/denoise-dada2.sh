#!/bin/bash
#PBS -N denoise-dada2
#PBS -l walltime=5:00:00
#PBS -l nodes=1:ppn=4,pmem=5GB
#PBS -l feature=dell
#PBS -W x=naccesspolicy:UNIQUEUSER
#PBS -q batch
#PBS -j oe

module load anaconda
source activate qiime2-2020.11

# Input parameters:
TRUNC_F=281 #determined from Q-score distribution after trimming
TRUNC_R=203 #determined from Q-score distribution after trimming
# Input files:
PROJDIR=$HOME/projects/scratch/vistas
READS=$PROJDIR/results/read-prep/reads_trimmed.qza
# Scratch paths:
SCRATCH=/scratch/$PBS_JOBID
INPUT_DIR_SC=$SCRATCH/inputs
OUTDIR_SC=$SCRATCH/denoise-outputs
# Outputs:
OUTDIR=$PROJDIR/results/read-prep/dada2

echo "making scratch directory..."
mkdir -p $INPUT_DIR_SC
cp $READS $INPUT_DIR_SC
#mkdir -p $OUTDIR_SC #DADA2 doesn't like pre-made output directories

# Denoise with DADA2
qiime dada2 denoise-paired \
    --i-demultiplexed-seqs $INPUT_DIR_SC/reads_trimmed.qza \
    --p-trunc-len-f $TRUNC_F \
    --p-trunc-len-r $TRUNC_R \
    --p-max-ee-f 2 \
    --p-max-ee-r 3 \
    --p-n-threads $PBS_NP \
    --output-dir $OUTDIR_SC

qiime metadata tabulate  --m-input-file $OUTDIR_SC/denoising_stats.qza --o-visualization $OUTDIR_SC/denoising_stats.qzv

qiime feature-table summarize --i-table $OUTDIR_SC/table.qza --o-visualization $OUTDIR_SC/summary.qzv

mkdir -p $OUTDIR
cp -r $OUTDIR_SC/* $OUTDIR
rm -rf $SCRATCH

echo -n "This job was executed on RTU HPC node "
head -n 1 $PBS_NODEFILE #so that I know in which node to investigate and clean up /scratch if something goes wrong

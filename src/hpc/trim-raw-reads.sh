#!/bin/bash
#PBS -N trim-raw-reads-K
#PBS -l walltime=2:00:00
#PBS -l nodes=1:ppn=3,pmem=5GB
#PBS -l feature=dell
#PBS -W x=naccesspolicy:UNIQUEUSER
#PBS -q batch
#PBS -j oe

module load anaconda
source activate qiime2-2020.11

# Input parameters:
FPRIMER="CCTACGGGNGGCWGCAG"
RPRIMER="GACTACHVGGGTATCTAATCC"
# Input files:
PROJDIR=$HOME/projects/scratch/vistas
READS=$PROJDIR/data/raw/*.fastq.gz
# Scratch paths:
SCRATCH=/scratch/$PBS_JOBID
INPUT_DIR_SC=$SCRATCH/inputs
OUTDIR_SC=$SCRATCH/prep-reads-outputs
# Outputs:
OUTDIR=$PROJDIR/results/read-prep

echo "making scratch directory..."
mkdir -p $INPUT_DIR_SC
cp $READS $INPUT_DIR_SC
mkdir -p $OUTDIR_SC

# Import reads:
qiime tools import \
   --type SampleData[PairedEndSequencesWithQuality] \
   --input-path $INPUT_DIR_SC \
   --output-path $OUTDIR_SC/reads.qza \
   --input-format CasavaOneEightSingleLanePerSampleDirFmt

# Trim adapters/primers:
qiime cutadapt trim-paired \
  --i-demultiplexed-sequences $OUTDIR_SC/reads.qza \
  --p-cores $PBS_NP \
  --p-front-f $FPRIMER \
  --p-front-r $RPRIMER \
  --p-discard-untrimmed \
  --p-no-indels \
  --o-trimmed-sequences $OUTDIR_SC/reads_trimmed.qza

# Make a quality summary of reads after primer trimming:
qiime demux summarize \
   --i-data $OUTDIR_SC/reads_trimmed.qza \
   --o-visualization $OUTDIR_SC/reads_trimmed_summary.qzv

mkdir -p $OUTDIR
cp -r $OUTDIR_SC/* $OUTDIR
rm -rf $SCRATCH

echo -n "This job was executed on RTU HPC node "
head -n 1 $PBS_NODEFILE #so that I know in which node to investigate and clean up /scratch if something goes wrong

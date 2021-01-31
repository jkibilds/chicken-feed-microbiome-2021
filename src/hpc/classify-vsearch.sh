#!/bin/bash
#PBS -N classify-vsearch
#PBS -l walltime=16:00:00
#PBS -l nodes=1:ppn=6,pmem=4GB
#PBS -l feature=dell
#PBS -W x=naccesspolicy:UNIQUEUSER
#PBS -q batch
#PBS -j oe

# classify denoised reads using VSEARCH (with default settings)

module load anaconda
source activate qiime2-2020.11

# Input files:
PROJDIR=$HOME/projects/scratch/vistas
INREADS=$PROJDIR/results/read-prep/dada2/representative_sequences.qza
REFSEQ=$HOME/projects/gut/data/silva_138_NR99_untouched/silva-138-99-seqs.qza
REFTAX=$HOME/projects/gut/data/silva_138_NR99_untouched/silva-138-99-tax.qza
FEATURES=$PROJDIR/results/read-prep/dada2/table.qza
# Scratch paths:
SCRATCH=/scratch/$PBS_JOBID
INPUT_DIR_SC=$SCRATCH/inputs
SCR_READS=$INPUT_DIR_SC/rep_seqs.qza
SCR_REFSEQ=$INPUT_DIR_SC/refseq.qza
SCR_REFTAX=$INPUT_DIR_SC/reftax.qza
SCR_FTAB=$INPUT_DIR_SC/ftab.qza
OUTDIR_SC=$SCRATCH/classification-outputs
# Outputs:
OUTDIR=$PROJDIR/results/taxonomy-vsearch

echo "making scratch directory..."
mkdir -p $INPUT_DIR_SC
cp $INREADS $SCR_READS
cp $REFSEQ $SCR_REFSEQ
cp $REFTAX $SCR_REFTAX
cp $FEATURES $SCR_FTAB
mkdir -p $OUTDIR_SC

qiime feature-classifier classify-consensus-vsearch \
  --i-query $SCR_READS \
  --i-reference-reads $SCR_REFSEQ \
  --i-reference-taxonomy $SCR_REFTAX \
  --p-threads $PBS_NP \
  --o-classification $OUTDIR_SC/taxonomy.qza

qiime metadata tabulate \
  --m-input-file $OUTDIR_SC/taxonomy.qza \
  --o-visualization $OUTDIR_SC/taxonomy.qzv

qiime tools export \
  --input-path $OUTDIR_SC/taxonomy.qza --output-path $OUTDIR_SC

qiime taxa collapse \
    --i-table $SCR_FTAB \
    --i-taxonomy $OUTDIR_SC/taxonomy.qza \
    --p-level 6 \
    --o-collapsed-table $OUTDIR_SC/features-collapsed.qza

qiime feature-table relative-frequency \
    --i-table $OUTDIR_SC/features-collapsed.qza \
    --o-relative-frequency-table $OUTDIR_SC/features-collapsed-relfreq.qza

qiime tools export \
    --input-path $OUTDIR_SC/features-collapsed-relfreq.qza \
    --output-path $OUTDIR_SC \

biom convert \
    -i $OUTDIR_SC/feature-table.biom \
    -o $OUTDIR_SC/features-collapsed-relfreq.tsv \
    --to-tsv \
    --table-type "OTU table"

mkdir -p $OUTDIR
cp -r $OUTDIR_SC/* $OUTDIR
rm -rf $SCRATCH

echo -n "This job was executed on RTU HPC node "
head -n 1 $PBS_NODEFILE #so that I know in which node to investigate and clean up /scratch if something goes wrong

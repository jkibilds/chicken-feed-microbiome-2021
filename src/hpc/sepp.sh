#!/bin/bash
#PBS -N sepp
#PBS -l walltime=12:00:00
#PBS -l nodes=1:ppn=8,pmem=5GB
#PBS -q batch
#PBS -j oe
#PBS -m ae
#PBS -M juris.kibilds@gmail.com

# Insert representative ASV sequences in reference alignment

module load anaconda
source activate qiime2-2020.6

# Input files:
PROJDIR=$HOME/projects/scratch/vistas
REP_SEQS=$PROJDIR/results/representative_sequences_finalFiltered.qza
REF_ALN=$PROJDIR/../../gut/data/sepp-refs-silva-128.qza
# Scratch paths:
SCRATCH=/scratch/$PBS_JOBID
INPUT_DIR_SC=$SCRATCH/inputs
SCR_SEQS=$INPUT_DIR_SC/rep_seqs.qza
SCR_ALN=$INPUT_DIR_SC/aln.qza
OUTDIR_SC=$SCRATCH/sepp-outputs
# Outputs:
OUTDIR=$PROJDIR/results/sepp

echo "making scratch directory..."
mkdir -p $INPUT_DIR_SC
cp $REP_SEQS $SCR_SEQS
cp $REF_ALN $SCR_ALN
mkdir -p $OUTDIR_SC

qiime fragment-insertion sepp \
    --i-representative-sequences $SCR_SEQS \
    --i-reference-database $SCR_ALN \
    --o-tree $OUTDIR_SC/phylogeny.qza \
    --o-placements $OUTDIR_SC/placements.qza

mkdir -p $OUTDIR
cp -r $OUTDIR_SC/* $OUTDIR
rm -rf $SCRATCH

echo -n "This job was executed on RTU HPC node "
head -n 1 $PBS_NODEFILE #so that I know in which node to investigate and clean up /scratch if something goes wrong

#!/bin/bash

source activate qiime2-2020.11

cd /media/juris/5e715177-0993-440c-996e-24251812b25a/juris/seq/repos/chicken_feed_study

# IN_FTAB=results/dadatab-onlysamples-finalFiltered.qza # dadatab minus singletons and nonsense taxons (mito, unassign etc.)
IN_FTAB=results/collapstab-onlysamples-finalFiltered.qza # collapsed, minus nonsense taxons and minfreq 20
#IN_PHYL=results/sepp/phylogeny.qza
METADATA=data/metadata_samples_Q2.tsv
OUTDIR=results/alpha-collapstab

mkdir -p $OUTDIR

# non-phylogenetic metrics:
qiime diversity alpha \
    --i-table $IN_FTAB \
    --p-metric 'shannon' \
    --o-alpha-diversity $OUTDIR/shannon-alpha.qza
qiime diversity alpha-correlation \
    --i-alpha-diversity $OUTDIR/shannon-alpha.qza \
    --m-metadata-file $METADATA \
    --p-method 'spearman' \
    --o-visualization $OUTDIR/shannon-alpha-cor.qzv
qiime diversity alpha-group-significance \
    --i-alpha-diversity $OUTDIR/shannon-alpha.qza \
    --m-metadata-file $METADATA \
    --o-visualization $OUTDIR/shannon-alpha-sig.qzv

qiime diversity alpha \
    --i-table $IN_FTAB \
    --p-metric 'simpson' \
    --o-alpha-diversity $OUTDIR/simpson-alpha.qza
qiime diversity alpha-correlation \
    --i-alpha-diversity $OUTDIR/simpson-alpha.qza \
    --m-metadata-file $METADATA \
    --p-method 'spearman' \
    --o-visualization $OUTDIR/simpson-alpha-cor.qzv
qiime diversity alpha-group-significance \
    --i-alpha-diversity $OUTDIR/simpson-alpha.qza \
    --m-metadata-file $METADATA \
    --o-visualization $OUTDIR/simpson-alpha-sig.qzv

qiime diversity alpha \
    --i-table $IN_FTAB \
    --p-metric 'chao1' \
    --o-alpha-diversity $OUTDIR/chao1-alpha.qza
qiime diversity alpha-correlation \
    --i-alpha-diversity $OUTDIR/chao1-alpha.qza \
    --m-metadata-file $METADATA \
    --p-method 'spearman' \
    --o-visualization $OUTDIR/chao1-alpha-cor.qzv
qiime diversity alpha-group-significance \
    --i-alpha-diversity $OUTDIR/chao1-alpha.qza \
    --m-metadata-file $METADATA \
    --o-visualization $OUTDIR/chao1-alpha-sig.qzv

qiime diversity alpha \
    --i-table $IN_FTAB \
    --p-metric 'mcintosh_d' \
    --o-alpha-diversity $OUTDIR/mcintosh_d-alpha.qza
qiime diversity alpha-correlation \
    --i-alpha-diversity $OUTDIR/mcintosh_d-alpha.qza \
    --m-metadata-file $METADATA \
    --p-method 'spearman' \
    --o-visualization $OUTDIR/mcintosh_d-alpha-cor.qzv
qiime diversity alpha-group-significance \
    --i-alpha-diversity $OUTDIR/mcintosh_d-alpha.qza \
    --m-metadata-file $METADATA \
    --o-visualization $OUTDIR/mcintosh_d-alpha-sig.qzv

# phylogenetic alpha diversity metric (not applicable because phylogeny can't be produced from collapsed taxon table):
#qiime diversity alpha-phylogenetic \
#    --i-table $IN_FTAB \
#    --i-phylogeny $IN_PHYL \
#    --p-metric 'faith_pd' \
#    --o-alpha-diversity $OUTDIR/faith-alpha.qza
#qiime diversity alpha-correlation \
#    --i-alpha-diversity $OUTDIR/faith-alpha.qza \
#    --m-metadata-file $METADATA \
#    --p-method 'spearman' \
#    --o-visualization $OUTDIR/faith-alpha-cor.qzv
#qiime diversity alpha-group-significance \
#    --i-alpha-diversity $OUTDIR/faith-alpha.qza \
#    --m-metadata-file $METADATA \
#    --o-visualization $OUTDIR/faith-alpha-sig.qzv

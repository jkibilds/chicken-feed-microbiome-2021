#!/bin/bash

source activate qiime2-2020.11

cd /media/juris/5e715177-0993-440c-996e-24251812b25a/juris/seq/repos/chicken_feed_study

IN_FTAB=results/dadatab-onlysamples-finalFiltered-srs.qza # dadatab minus singletons and nonsense taxons (mito, unassign etc.), SRS-normalized
# IN_FTAB=results/collapstab-onlysamples-finalFiltered-srs.qza # collapsed, minus nonsense taxons and minfreq 20, SRS-normalized
IN_PHYL=results/sepp/phylogeny.qza
METADATA=data/metadata_samples_Q2.tsv
META_COL_COR1="dose_mg_per_kg"
META_COL_COR2="denoised_read_count"
META_COL_GROUP1="treated"
OUTDIR=results/beta-dadatab-2-srs

mkdir -p $OUTDIR

# non-phylogenetic metrics:
qiime diversity beta \
    --i-table $IN_FTAB \
    --p-metric 'braycurtis' \
    --p-pseudocount 1 \
    --o-distance-matrix $OUTDIR/braycurtis-beta.qza
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/braycurtis-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR1 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/braycurtis-beta-cor-$META_COL_COR1
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/braycurtis-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR2 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/braycurtis-beta-cor-$META_COL_COR2
qiime diversity beta-group-significance \
    --i-distance-matrix $OUTDIR/braycurtis-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_GROUP1\
    --p-method 'permanova' \
    --o-visualization $OUTDIR/braycurtis-beta-sig.qzv

qiime diversity beta \
    --i-table $IN_FTAB \
    --p-metric 'dice' \
    --p-pseudocount 1 \
    --o-distance-matrix $OUTDIR/dice-beta.qza
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/dice-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR1 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/dice-beta-cor-$META_COL_COR1
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/dice-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR2 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/dice-beta-cor-$META_COL_COR2
qiime diversity beta-group-significance \
    --i-distance-matrix $OUTDIR/dice-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_GROUP1\
    --p-method 'permanova' \
    --o-visualization $OUTDIR/dice-beta-sig.qzv

qiime diversity beta \
    --i-table $IN_FTAB \
    --p-metric 'aitchison' \
    --p-pseudocount 1 \
    --o-distance-matrix $OUTDIR/aitchison-beta.qza
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/aitchison-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR1 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/aitchison-beta-cor-$META_COL_COR1
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/aitchison-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR2 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/aitchison-beta-cor-$META_COL_COR2
qiime diversity beta-group-significance \
    --i-distance-matrix $OUTDIR/aitchison-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_GROUP1\
    --p-method 'permanova' \
    --o-visualization $OUTDIR/aitchison-beta-sig.qzv

qiime diversity beta \
    --i-table $IN_FTAB \
    --p-metric 'jaccard' \
    --p-pseudocount 1 \
    --o-distance-matrix $OUTDIR/jaccard-beta.qza
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/jaccard-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR1 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/jaccard-beta-cor-$META_COL_COR1
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/jaccard-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR2 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/jaccard-beta-cor-$META_COL_COR2
qiime diversity beta-group-significance \
    --i-distance-matrix $OUTDIR/jaccard-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_GROUP1\
    --p-method 'permanova' \
    --o-visualization $OUTDIR/jaccard-beta-sig.qzv

# phylogenetic beta diversity metric:
qiime diversity beta-phylogenetic \
    --i-table $IN_FTAB \
    --i-phylogeny $IN_PHYL \
    --p-metric 'weighted_normalized_unifrac' \
    --o-distance-matrix $OUTDIR/wnUniFrac-beta.qza
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/wnUniFrac-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR1 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/wnUniFrac-beta-cor-$META_COL_COR1
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/wnUniFrac-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR2 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/wnUniFrac-beta-cor-$META_COL_COR2
qiime diversity beta-group-significance \
    --i-distance-matrix $OUTDIR/wnUniFrac-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_GROUP1\
    --p-method 'permanova' \
    --o-visualization $OUTDIR/wnUniFrac-beta-sig.qzv

qiime diversity beta-phylogenetic \
    --i-table $IN_FTAB \
    --i-phylogeny $IN_PHYL \
    --p-metric 'weighted_unifrac' \
    --o-distance-matrix $OUTDIR/wUniFrac-beta.qza
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/wUniFrac-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR1 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/wUniFrac-beta-cor-$META_COL_COR1
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/wUniFrac-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR2 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/wUniFrac-beta-cor-$META_COL_COR2
qiime diversity beta-group-significance \
    --i-distance-matrix $OUTDIR/wUniFrac-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_GROUP1\
    --p-method 'permanova' \
    --o-visualization $OUTDIR/wUniFrac-beta-sig.qzv

qiime diversity beta-phylogenetic \
    --i-table $IN_FTAB \
    --i-phylogeny $IN_PHYL \
    --p-metric 'generalized_unifrac' \
    --o-distance-matrix $OUTDIR/gUniFrac-beta.qza
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/gUniFrac-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR1 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/gUniFrac-beta-cor-$META_COL_COR1
qiime diversity beta-correlation \
    --i-distance-matrix $OUTDIR/gUniFrac-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_COR2 \
    --p-method 'spearman' \
    --output-dir $OUTDIR/gUniFrac-beta-cor-$META_COL_COR2
qiime diversity beta-group-significance \
    --i-distance-matrix $OUTDIR/gUniFrac-beta.qza \
    --m-metadata-file $METADATA \
    --m-metadata-column $META_COL_GROUP1\
    --p-method 'permanova' \
    --o-visualization $OUTDIR/gUniFrac-beta-sig.qzv

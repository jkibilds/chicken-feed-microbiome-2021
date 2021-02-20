#!/bin/bash

cd /media/juris/5e715177-0993-440c-996e-24251812b25a/juris/seq/repos/chicken_feed_study

IN_MAASLIN=results/MaAsLin2/srs_noTax_LogTransform_dose/significant_results.tsv
IN_TAX=results/feature-taxonomy-tabulated.tsv
TEMP_TAXFILE=results/MaAsLin2/srs_noTax_LogTransform_dose/temp_taxfile.tsv
TEMP_MAASLINFILE=results/MaAsLin2/srs_noTax_LogTransform_dose/significant_results_temp.tsv
OUTFILE=results/MaAsLin2/srs_noTax_LogTransform_dose/significant_results_w_taxonomy.tsv

echo -e "feature\tfeature taxonomy" > $TEMP_TAXFILE #taxonomy will be stored here before adding to the maaslin output file

tail -n +2 $IN_MAASLIN | cut -f 1 | sed 's/X//' - > $TEMP_MAASLINFILE #maaslin significant results without header line and without Xs that MaAsLin2 prepends to feature IDS which start with digits

while read LINE
do
#    echo $LINE
    grep $LINE $IN_TAX | cut -f 1-2 >> $TEMP_TAXFILE
done < $TEMP_MAASLINFILE

paste $TEMP_TAXFILE $IN_MAASLIN > $OUTFILE

# beigās jāiegūst maaslin significant features fails, kur blakus feature hash ir katra feature taksonomija - tad varēs viegli redzēt, cik daudz dažādu feature viena taksona ietvaros ir būtiskas saistības ar metadatiem

rm $TEMP_TAXFILE $TEMP_MAASLINFILE # clean up

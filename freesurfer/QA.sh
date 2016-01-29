#!/bin/bash
# The main script for running freesurfer QA. The final output is
# a csv that has flags on whether someone is an outlier (>2sd) in any of
# the following fields:
# 1. mean thickness
# 2. total surface area
# 3. Cortical volume
# 4. Subcortical gray matter
# 5. Cortical White matter
# 6. CNR
# 7. SNR
# 8. ROI-Raw cortical thickness
# 9. ROI- laterality thickness difference
# For the ROI based measures we compute number of roi outliers for each subject
# then compute outliers across subjects for number of ROIs flagged.


# full directory to subject list bblid_scanid
slist=/data/jag/BBL/studies/pnc/subjectData/freesurfer/go1_go2_freesurfer53_qa_run_list.txt
export SUBJECTS_DIR=/data/jag/BBL/studies/pnc/processedData/structural/freesurfer53
export QA_TOOLS=/data/jag/BBL/applications/QAtools_v1.1/
export FREESURFER_HOME=/share/apps/freesurfer/5.3.0/
export PATH=$FREESURFER_HOME/bin/:$PATH

# create subcortical segment volumes
if [ ! -e "$SUBJECTS_DIR/stats/aseg.stats" ]; then
	mkdir -p $SUBJECTS_DIR/stats/aseg.stats
fi
asegstats2table --subjectsfile=$slist -t $SUBJECTS_DIR/stats/aseg.stats/aseg.stats.volume.csv -m volume --skip

# create parcelation tables
if [ ! -e "$SUBJECTS_DIR/stats/aparc.stats" ]; then
	mkdir -p $SUBJECTS_DIR/stats/aparc.stats
fi
# code to create mean QA data charts. thickness and surface area charts.
/data/jag/BBL/projects/pncReproc2015/pncReproc2015Scripts/freesurfer/aparc.stats.meanthickness.totalarea.sh $slist $SUBJECTS_DIR 

#aparcstats2table --hemi lh --subjectsfile=$slist -t $SUBJECTS_DIR/stats/aparc.stats/lh.aparc.stats.thickness.csv -m thickness --skip
#aparcstats2table --hemi rh --subjectsfile=$slist -t $SUBJECTS_DIR/stats/aparc.stats/rh.aparc.stats.thickness.csv -m thickness --skip
#aparcstats2table --hemi lh --subjectsfile=$slist -t $SUBJECTS_DIR/stats/aparc.stats/lh.aparc.stats.volume.csv -m volume --skip
#aparcstats2table --hemi rh --subjectsfile=$slist -t $SUBJECTS_DIR/stats/aparc.stats/rh.aparc.stats.volume.csv -m volume --skip
aparcstats2table --hemi lh --subjectsfile=$slist -t $SUBJECTS_DIR/stats/aparc.stats/lh.aparc.stats.area.csv --skip
aparcstats2table --hemi rh --subjectsfile=$slist -t $SUBJECTS_DIR/stats/aparc.stats/rh.aparc.stats.area.csv --skip

# cnr
# this runs the cnr_euler_number_calculation.sh 
#/data/jag/BBL/projects/pncReproc2015/pncReproc2015Scripts/freesurfer/cnr_euler_number_calculation.sh $slist $SUBJECTS_DIR  ###########CURRENTLY THIS SCRIPT IS SET UP TO RUN ON THE FULL SAMPLE, WILL HAVE TO EDIT TO WORK WITH QA SCRIPT

# snr
#for i in $(cat $slist); do
#	#$QA_TOOLS/recon_checker -s $(cat $slist) -nocheck-aseg -nocheck-status -nocheck-outputFOF -no-snaps > temp.txt
#	$QA_TOOLS/recon_checker -s $i -nocheck-aseg -nocheck-status -nocheck-outputFOF -no-snaps 
#done > temp.txt
#grep "wm-anat-snr results" temp.txt | cut -d"(" -f2 | cut -d")" -f1 >temp2.txt
#for i in $(cat -n temp.txt | grep "wm-anat-snr results" | cut -f1); do
#	echo $(sed -n "$(echo $i +2 | bc)p" temp.txt | cut -f1)
#done > temp3.txt
#paste temp2.txt temp3.txt > $SUBJECTS_DIR/stats/cnr/snr.txt
#rm -f temp*.txt


# r scripts to flag outliers from tables created above.
# These flag all the outliers, but write them all to separate files.
# need to add something to the end of aseg.stats.volumes.R to concatenate them all.
#/share/apps/R/R-3.1.1/bin/R --slave --file=/data/jag/BBL/projects/pncReproc2015/pncReproc2015Scripts/freesurfer/flag_outliers.R --args $SUBJECTS_DIR 



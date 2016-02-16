#!/bin/bash

export SUBJECTS_DIR="/data/joy/BBL/studies/pnc/processedData/structural/freesurfer53"
slist=$(ls -d /data/joy/BBL/studies/pnc/rawData/*/*x????) 
logs="/data/joy/BBL/projects/pncReproc2015/freesurfer/logs"

#for every subject in the subjects folder
for i in $slist; do
	#echo $i
	#get bblid, datexscanid, and MPRAGE nifti 
	bblid=`echo $i | cut -d "/" -f 8`
	subjid=`echo $i | cut -d "/" -f 9`
	echo $subjid
	infile=`ls -d $i/mprage*/*_t1.nii.gz`
	#get the working subjects folder for that subject
	surfpath=`ls -d /data/joy/BBL/studies/pnc/processedData/structural/freesurfer53/$bblid/$subjid`
	SUBJECTS_DIR="/data/joy/BBL/studies/pnc/processedData/structural/freesurfer53/$bblid"
	#if the freesurfer folder isn't empty for that subject then skip that subject        
	if [ "X$surfpath" != "X" ]; then
		echo "*-*-*-*-Freesurfer has already been run for this subject-*-*-*-*"
		continue
	#if there is no freesurfer folder for that subject then submit the freesurfer_grid_submission script to the grid
	else
	qsub -V -e $logs -o $logs -q all.q -S /bin/bash /data/joy/BBL/projects/pncReproc2015/pncReproc2015Scripts/freesurfer/freesurfer_grid_submission.sh $infile $SUBJECTS_DIR $subjid
fi
done 

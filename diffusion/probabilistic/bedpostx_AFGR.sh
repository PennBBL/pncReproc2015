#!/bin/sh

# this script by MQ, DRR, and GLB (10/28/15) runs bedpostx using subject specific motion and distortion corrected files.

# Path to diffusion data (input to bedpostx)
path=/data/jag/BBL/studies/pnc/processedData/diffusion/probabilistic

#for each subject in the list of subjects/timepoints that passed DTI QA (from DRR on dtipipe channel on slack 9/10/15)...
	for i in `cat /data/jag/BBL/studies/pnc/subjectData/go1_bedpostX/new_go1_dti_qaInclude_AFGR_batch1.csv`; do
	
	#create variables for bblid,scanid and the date of scan (day, month, year) (directory structure is bblid/dateofscanxscanid)
	bblid=`echo $i | cut -d "," -f 1`
	scanid=`echo $i | cut -d "," -f 2`
	day=`echo $i | cut -d "," -f 3 | cut -d "/" -f 2`
	month=`echo $i | cut -d "," -f 3 | cut -d "/" -f 1`
	year=`echo $i | cut -d "," -f 3 | cut -d "/" -f 3`
	datexscanid=`echo "20"$year$month$day"x"$scanid`

	echo "........................... Processing subject "$bblid $scanid
	
# Create directories in the /data/jag/BBL/studies/pnc/processedData/diffusion/probabilistic/ parent directory for each subject and timepoint, then create a bedpostx_input directory for each subject/timepoint which will contain the input data for bedpostx. Output directories will be originally named bedpostx_input.bedpostx then will be changed post hoc to bedpostx_output. Also create bedpostx_logs directories which will get the bedpostx log output

		mkdir -p $path/$bblid/$datexscanid/bedpostx_input
#		rmdir $path/$bblid/$datexscanid/bedpostx_logs

#rm -rf $path/$bblid/$datexscanid/bedpostx_input.bedpostX/

# Set path variables

bpX_InputPath=$path/$bblid/$datexscanid/bedpostx_input

#logDir=$path/$bblid/$datexscanid/bedpostx_logs
		
#symlink the data for each subject from their roalfDti directory to their bedpostx_input directory. Bedpostx requires a specific naming convention for files so files will also be renamed to follow those specifications

		ln -s /data/jag/BBL/studies/pnc/processedData/diffusion/roalfDti/$bblid/$datexscanid/raw_merged_dti/*dti.merged_rotated.bvec $path/$bblid/$datexscanid/bedpostx_input/bvecs
		ln -s /data/jag/BBL/studies/pnc/processedData/diffusion/roalfDti/$bblid/$datexscanid/raw_merged_dti/$scanid".dti.merged.bval" $path/$bblid/$datexscanid/bedpostx_input/bvals
		ln -s /data/jag/BBL/studies/pnc/processedData/diffusion/roalfDti/$bblid/$datexscanid/eddy_results/dico_corrected/$scanid".dico_dico.nii" $path/$bblid/$datexscanid/bedpostx_input/data.nii
		ln -s /data/jag/BBL/studies/pnc/processedData/diffusion/roalfDti/$bblid/$datexscanid/raw_merged_dti/"dtistd_2_"$scanid".mask.nii.gz" $path/$bblid/$datexscanid/bedpostx_input/nodif_brain_mask.nii.gz


# Undefine FSLGECUDAQ variable so that bedpostx doesn't try to use CUDA
FSLGECUDAQ="null" 

export FSLGECUDAQ


# Source bedpostx directly on chead ** NO QSUB. -c flag is crucial for preventing use of CUDA hardware (which we don't have) **

bedpostx ${bpX_InputPath}/ -c


# Open group permissions on output
chmod -R 775 $path/$bblid/$datexscanid/bedpostx_input.bedpostX/

done


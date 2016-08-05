subjlist=${1}
subj=$(cat $subjlist | sed -n "${SGE_TASK_ID}p")

if [ ! -f /data/joy/BBL/studies/pnc/processedData/structural/jlf/${subj}/jlfLabels.nii.gz ] ; then
  /data/joy/BBL/projects/pncReproc2015/pncReproc2015Scripts/jlf/scripts/antsJLF_OASIS30CustomSubset_afgr-testing-20160525.pl /data/joy/BBL/studies/pnc/processedData/structural/antsCorticalThickness/${subj}/ExtractedBrain0N4.nii.gz /data/joy/BBL/studies/pnc/processedData/structural/jlf/${subj}/jlf 1 0 Younger24
else
  echo "All Done"
  exit 0 
fi

subjlist=${1}
noParcText="/home/arosen/makeGmMaps/noParcSubjs.csv"
subj=$(cat $subjlist | sed -n "${SGE_TASK_ID}p")
bblid=`echo ${subj} | cut -f 1 -d ,`
scanid=`echo ${subj} | cut -f 2 -d ,`
dateid=`echo ${subj} | cut -f 3 -d ,`
antsPath="/data/joy/BBL/studies/pnc/processedData/structural/antsCorticalThickness/${bblid}/${dateid}x${scanid}/"
outImg="GmCombinedPriors.nii.gz"
parcImg=`ls /data/joy/BBL/studies/pnc/processedData/structural/mars/labeledImages/${bblid}_${dateid}x${scanid}*`
parcDir="MARS"
scriptToCall=""
templateImg="/data/joy/BBL/studies/pnc/template/pnc_template_brain.nii.gz"
if [ -z ${parcImg} ] ; then 
  echo "${bblid},${scanid},${dateid}" >> ${noParcText}  
else
  /data/joy/BBL/projects/pncReproc2015/pncReproc2015Scripts/antsCT/combinePriors2-4-5.sh -d ${antsPath} -o ${outImg} -p ${parcImg} -P ${parcDir} -t ${templateImg} ; 
fi
  
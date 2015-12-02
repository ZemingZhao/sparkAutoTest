#!/bin/sh

#############################################################################################################
#
#  Usage:
#     please configure environment and conf first
#     thre are two mode to run this regresion: regression script in a dir or a single script file
#    
#############################################################################################################

### source ENV 
source ./environment.conf
### source public function
source ./lib/public.framework
### validaty check,  create report and logs dir
if [[ -z "$1" || -n $2 ]]; then
   echo " Usage: There're two modes to run this tools."
   echo "        Regression  Mode:  $0 Case_Group_Dir"
   echo "                           such as: $0 ./caseList"
   echo "        Single file Mode:  $0 Script_Case_File"
   echo "                           such as: $0 ./caseList/xx.sh"
   exit 1
elif [[ ! -x $1 ]]; then
   echo "please make sure $1 has executale right."
   exit 1
fi

### create report, export reportDir testReport
createReportDir
echo "please find report at $reportDir/testReport.txt"

### write report tile, including begin date
writeReportTitle

### create case list
### Note: all executable file under $1 will be treated as a case
createCaseList $1
echo "please find case list at $reportDir/caseList"
echo "please find detail case log under $reportDir/logs/"

### run cases
cat $reportDir/caseList | while read caseScript; do
    if [[ ! -d $reportDir/logs/$caseScript || ! -x $reportDir/logs/$caseScript ]]; then
       mkdir -p $reportDir/logs/$caseScript
    fi
    export caseLogDir=$reportDir/logs/$caseScript
    #caseLogDir=$reportDir/logs/$caseScript
    ./$caseScript  1> $caseLogDir/stdout 2> $caseLogDir/stderr
    #$caseScript $reportDir  1> $reportDir/logs/$caseScript/stdout 2>$reportDir/logs/$caseScript/stderr
done

# Statistic Case Result
writeReportStatistic

exit 0

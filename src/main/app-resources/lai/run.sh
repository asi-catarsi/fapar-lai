#!/bin/bash

# Project:		 ${project.name}
# Author:		  $Author: fbrito $ (Terradue Srl)
# Last update:	${doc.timestamp}:
# Element:		 ${project.name}
# Context:		 ${project.artifactId}
# Version:		 ${project.version} (${implementation.build})
# Description:	${project.description}
#
# This document is the property of Terradue and contains information directly
# resulting from knowledge and experience of Terradue.
# Any changes to this code is forbidden without written consent from Terradue Srl
#
# Contact: info@terradue.com
# 2012-02-10 - NEST in jobConfig upgraded to version 4B-1.1

# source the ciop functions (e.g. ciop-log)

source ${ciop_job_include}
export LC_ALL="en_US.UTF-8"
source /application/CATARSI/catarsi.sh

# define the exit codes
SUCCESS=0
ERR_NOINPUT=1

# add a trap to exit gracefully
function cleanExit ()
{
	local retval=$?
	local msg=""
	case "$retval" in
		$SUCCESS) 	msg="Processing successfully concluded";;
		$ERR_NOINPUT)	msg="Input not retrieved to local node";;
		*)		msg="Unknown error";;
	esac

	[ "$retval" != "0" ] && ciop-log "ERROR" "Error $retval - $msg, processing aborted" || ciop-log "INFO" "$msg"

	exit $retval
}

trap cleanExit EXIT

ciop-log "DEBUG" "Input dir: ${TMPDIR}/input"
ciop-log "DEBUG" "Ouput dir: ${TMPDIR}/output"

inputDir=${TMPDIR}/input
outputDir=${TMPDIR}/output

mkdir -p $inputDir
mkdir -p $outputDir

#export DISPLAY=:99
ciop-log "DEBUG" "Running on display $DISPLAY"


while read input
do
	ciop-log "INFO" "Working with file $input"
	file=`ciop-copy -o $inputDir -U $input`

	ciop-log "DEBUG" "ciop-copy output is $file"

	file=`basename $file`

	#call the lai su $file
	cd $inputDir; unzip $file; rm -f $file; cd `echo $file | sed 's#\.zip##g'`

	ciop-log "DEBUG" "File is $file"

	myInputDir="$inputDir/`echo $file | sed 's#\.zip##g'`/"
	myOutputDir="$outputDir/`echo $file | sed 's#\.zip##g' | sed 's#input#output#g'`/"; mkdir -p $myOutputDir

	ciop-log "INFO" "Starting lai processor [/bin/sh /application/CATARSI/batch_Processor/FAPAR_and_LAI/run_lai.sh /usr/local/MATLAB/MATLAB_Compiler_Runtime/v76/ $myInputDir $myOutputDir]"

	cd /application/CATARSI/batch_Processor/FAPAR_and_LAI/
	/bin/sh -x run_LAI.sh /usr/local/MATLAB/MATLAB_Compiler_Runtime/v76/ $myInputDir $myOutputDir &> $myOutputDir/output.txt

	cd $outputDir
	tar cvfz `echo $file | sed 's#\.zip##g' | sed 's#input#output#g'`.tgz `echo $file | sed 's#\.zip##g' | sed 's#input#output#g'`
	ls -l
	ciop-log "INFO" "Publishing output [`echo $file | sed 's#\.zip##g' | sed 's#input#output#g'`]"
	ciop-publish -m $outputDir/`echo $file | sed 's#\.zip##g' | sed 's#input#output#g'`.tgz

done

#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# set -eEuxo pipefail
set -Euo pipefail

# These folders aren't kept under version control. May need recreating.
if [ ! -d ${SCRIPTDIR}/TestDiffs ]; then
    mkdir ${SCRIPTDIR}/TestDiffs
fi

FAILED=false

createCSV() {
    # As of 1/6/18, creates CSV in TestOutputs
    ${SCRIPTDIR}/../bin/createcsvs.out $file
    parseReturnCode=$?
    if [ ! $parseReturnCode ]; then
        FAILED=true
    fi
}

diffResult(){
    csv=$1
    # For some reason, this returns an error code, so fails on -e
    diff="$(diff "${SCRIPTDIR}/TestOutputs/${csv}" "${SCRIPTDIR}/TestAnswers/${csv}")"
    # Remove old diffs before replacing
    diffFile="${SCRIPTDIR}/TestDiffs/${csv}.diff"
    if [[ -f "$diffFile" ]]; then
        rm "$diffFile" > /dev/null 2>&1
    fi
    if [ ! "$diff" = "" ]; then
        FAILED=true
        printf "Failed!\n"
        echo $diff >> $diffFile
    fi
}

main(){
    for file in ${SCRIPTDIR}/TestInputs/*; do
        filebase=$(basename $(basename $file) .txt)
        printf "Testfile: ${filebase}\n"
        createCSV $file
        diffResult "${filebase}.csv"
    done
    if [[ $FAILED = true ]]; then
        printf "Some tests failed! Check TestDiffs for more.\n"
        exit 1
    else
        printf "All tests pass!\n"
        exit 0
    fi
}

main

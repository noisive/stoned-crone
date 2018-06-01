#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# set -eEuxo pipefail
set -eEuo pipefail

# These folders aren't kept under version control. May need recreating.
if [ ! -d ${SCRIPTDIR}/TestDiffs ]; then
    mkdir ${SCRIPTDIR}/TestDiffs
fi

createCSVs() {
    for file in ${SCRIPTDIR}/TestInputs/*; do
        printf "${file}\n"
        # As of 1/6/18, creates CSV in TestOutputs
        ${SCRIPTDIR}/../bin/createcsvs.out $file
    done
}

diffCSVs() {
    for file in "${SCRIPTDIR}/TestOutputs/*"; do
        diff=`diff $file "${SCRIPTDIR}/TestAnswers/${file}"`
        # Remove old diffs before replacing
        rm "${SCRIPTDIR}/TestDiffs/${file}.diff" > /dev/null 2>&1
        if [ $diff = "" ]; then
            FAILED=true
            echo $diff >> "${SCRIPTDIR}/TestDiffs/${file}.diff"
        fi
    done
    if [ $FAILED = true ]; then
        echo "Some tests failed! Check TestDiffs for more."
        exit 1
    else
        echo "All tests pass!"
        exit 0
    fi
}

createCSVs
diffCSVs

#!/bin/bash

# These folders aren't kept under version control. May need recreating.
if [ -d TestDiffs ]; then
    mkdir TestDiffs
fi
if [ -d TestComparisons ]; then
    mkdir TestComparisons
fi

extractBaseFile() {
    local filename=$(basename -- "$1")
    local extension="${filename##*.}"
    local filename="${filename%.*}"
    echo "$filename"
}

createCSVs() {
    for file in TestInputs/*; do
        ../src/createcsvs.out $file
        # Remove extension and base path from file
        testname=`extractBaseFile "$file"`
        mv "TestInputs/data.csv" "TestComparisons/${testname}.csv"
        rm "TestInputs/GoogleCalFile.csv"
    done
}

diffCSVs() {
    for file in "TestOutputs/*"; do
        diff=`diff $file "TestComparisons/${file}"`
        # Remove old diffs before replacing
        rm "TestDiffs/${file}.diff"
        echo $diff >> "TestDiffs/${file}.diff"
    done
}

createCSVs

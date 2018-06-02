# WingIt parser high-level Regression Test

## Usage

All files to be tested (see Creation/source) should go in `TestInput`. Their desired output csv should go in `TestAnswers`, with the same name but different extension. The output files should be carefully hand-checked.

Running the shell script `runtests.sh` will produce diffs of any files in the `TestInput` folder with their equivalent in the `TestAnswers` folder, storing intermediates in `TestOuputs` and results in `TestDiffs`.

## Extracted jsons for testing

These are kept in `InputTests` as .txt files.

#### Creation/source

Extracted from eVision timetable html (as saved from the timetable page in a desktop browser) by running this javascript code in the console:

    window.getJSArray = function() {return content = document.getElementById('ttb_timetable').getElementsByTagName('script')[0].innerHTML.trim();}
    window.getJSArray()

Then saved as .txt in `TestInput`

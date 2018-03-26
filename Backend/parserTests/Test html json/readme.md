# Extracted jsons for testing

## Creation/source

Extracted from eVision timetable html by running this javascript code in the console:

    `window.getJSArray = function() {return content = document.getElementById('ttb_timetable').getElementsByTagName('script')[0].innerHTML.trim();}
    window.getJSArray()`

Then run through a conventional prettyprinter like jsbeautifier.org
Then large lines are split with a command line in vim: `%s/<\\\/div/\\\/div\r/g`

## Usage

A test method that has not been created yet.

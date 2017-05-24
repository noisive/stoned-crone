Skip to content
This repository
Search
Pull requests
Issues
Marketplace
Gist
 @BlueDrink9
 Sign out
 Unwatch 4
  Unstar 1
 Fork 2 noisive/stoned-crone
 Code  Issues 0  Pull requests 0  Projects 0  Wiki  Settings Insights 
Branch: 2d_array_parser Find file Copy pathstoned-crone/Python parser conceptProof/parse.py
409fbfb  12 days ago
@BlueDrink9 BlueDrink9 finished 2d array version of python parser
1 contributor
RawBlameHistory     
85 lines (68 sloc)  2.95 KB
""" Returns error if text not found.
Otherwise, searches text until it finds target, 
then returns text between target and endTarget"""

# Current problem is that it keeps looking at same bit of data. Restarting at beginning of each line.
# previous version sorted this fine, because didn't allow non-unique duplicates?

import sys
import fileinput

def parse(text, target, endTarget):
    targetIndex = 0
    targLength = len(target)
    currentlyMatching = False
    doExtract = False
    out = ""
    for letter in text:
        
        if doExtract == True:
            if letter == endTarget:
                return out
            else:
                out+=letter
        else:
        
            if letter == target[targetIndex]:
                currentlyMatching = True
                if targetIndex == targLength -1:
                    doExtract = True
                targetIndex+=1
                
            else:
                currentlyMatching = False
                targetIndex = 0
                    
    return None
    
# Removes spaces from end of data
# Uses string indexing.
def tidyData(dataDict):
    for lecture in range(0, len(data)):
        for entry in range(0, len(data[lecture])):
            while data[lecture][entry][len(data[lecture][entry])-1] == " ":
                data[lecture][entry] = data[lecture][entry][0:len(data[lecture][entry])-1]
                # this is creating mutable COPY. Need to change original.

    

# Converts the start and end date strings in array to plain numbers, of form ddmmyyyy
def extractDateValues(data){
    startDateString = data[1]
    endDateString = data[2]

    startDateNum = startDateString[0:2]
    endDateNum

    case(startDateString(4:7)){
        ="Jan":
            startDateNum += 01
            break
        ="Feb"
            startDateNum += 02
            break
        
    }
}


# Only external array needs to be dynamic. Internal one can be set size.
dataLabels = ["Date range start", "Date range end", "Day of timetable", "start time","end time", "colour", "Class type", "Paper code", "Paper name", "Map url", "Stream", "Room code", "Room name", "Building"]
parseStartTags =["Now showing dates "," to ", "\"day\":", "\"start\":\"", "\"end\":\"","\"fcol\":\"", "\"info\":\"","Paper code:<\/strong> ", "Paper name:<\/strong> ", "href=\\\"", "Stream:<\/strong> ", "target=\\\"_blank\\\">", "Room:<\/strong> ","Building:<\/strong> "]
parseEndTags=[" to ",")","\"","\"","\"", "<","<","<","\"","<","<","<","<"]
data = []
data.append([""]*(len(dataLabels)-1))

dataIndex = 0
for line in fileinput.input():
    entryIndex = 0
    dictKeyIndex = 1 # Start time is key


    
    while True: #breaks if parsedInfo == None (no data)
        parsedInfo = parse(line, parseStartTags[entryIndex], parseEndTags[entryIndex])
        if parsedInfo == None:
            break # Look in next line.
            
        # End of current entry.
        if entryIndex == len(dataLabels)-1:
            entryIndex = 0
            # Found all the individual parts of a single entry.
            # Time for new entry.
            data.append([""]*(len(dataLabels)-1))
            dataIndex+=1
            break
        else:
            data[dataIndex][entryIndex] = parsedInfo
            entryIndex += 1
del data[(len(data)-1)]

tidyData(data)
print dataLabels
print data
#testLine = raw_input()
#print parse(testLine, "\"info\":\"", "<")
Contact GitHub API Training Shop Blog About
© 2017 GitHub, Inc. Terms Privacy Security Status Help
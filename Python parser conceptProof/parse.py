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
                out += letter
        else:
            
            if letter == target[targetIndex]:
                currentlyMatching = True
                if targetIndex == targLength -1:
                    doExtract = True
                targetIndex += 1
            
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

    

# Converts the start and end date strings in array to plain numbers, 
# of form ddmmyyyy
def extractDateValues(data):
    startDateString = data[0]
    endDateString = data[1]

    # Expected current format is dd\/Mmm\/yyyy,
    # with month being the 3 letter month code.
    # Python seems to be storing as 27\\/Mar\\/2017
    startDateNum = startDateString[0:2]
    endDateNum = endDateString[0:2]


    switcher={
        "Jan" : "01",
        "Feb" : "02",
        "Mar" : "03",
        "Apr" : "04",
        "May" : "05",
        "Jun" : "06",
        "Jul" : "07",
        "Aug" : "08",
        "Sep" : "09",
        "Oct" : "10",
        "Nov" : "11",
        "Dec" : "12"
    }
    startDateNum  +=  switcher[startDateString[4:7]] 
    endDateNum  +=  switcher[endDateString[4:7]]

    startDateNum  +=  startDateString[9:13]
    endDateNum  +=  endDateString[9:13]

    data[0][0] = startDateNum
    data[0][1] = endDateNum



# Only external array needs to be dynamic. Internal one can be set size.
dataLabels = ["Day of timetable", "start time", "end time", "hex colour", "Class type", "Paper code", "Paper name", "Map url", "Stream", "Room code", "Room name", "Building"]
parseStartTags = ["\"day\":", "\"start\":\"", "\"end\":\"", "\"fcol\":\"", "\"info\":\"", "Paper code:<\/strong> ", "Paper name:<\/strong> ", "href=\\\"", "Stream:<\/strong> ", "target=\\\"_blank\\\">", "Room:<\/strong> ", "Building:<\/strong> "]
parseEndTags = [",", "\"", "\"", "\"", "<", "<", "<", "\"", "<", "<", "<", "<"]
data = []
data.append([""]*len(dataLabels))
hasDates = False
dateRange = ["",""]

dateTags = ["Now showing dates ", " to ", " ",")"]

dataIndex = 0
for line in fileinput.input():
    entryIndex = 0

    if not hasDates:
        parsedInfo = parse(line, dateTags[0], dateTags[2])
        if parsedInfo != None:
            dateRange[0] = parsedInfo
            parsedInfo = parse(line, dateTags[1], dateTags[3])
            dateRange[1] = parsedInfo
            hasDates = True


    
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
            dataIndex += 1
            break
        else:
            data[dataIndex][entryIndex] = parsedInfo
            entryIndex  +=  1
del data[(len(data)-1)]

if len(data[0]) < len(dataLabels):
    raise EOFError("No input file, or insufficient data discovered in file.")
dataLabels.append(["Start date range", "End date range"])
data.append(dateRange)
tidyData(data)
extractDateValues(dateRange)
print dataLabels
print data
#testLine = raw_input()
#print parse(testLine, "\"info\":\"", "<")

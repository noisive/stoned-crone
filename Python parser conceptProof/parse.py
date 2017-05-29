""" Returns error if text not found.
Otherwise, searches text until it finds target, 
then returns text between target and endTarget"""
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
def tidyData(dataDict):
    for item in dataDict.iteritems():
        for index in range(0, len(item)-1):
            while item[index][len(item[index])-1] == " ":
                dataDict[item][index] = item[index][0:len(item[index])-1]
                # this is creating mutable COPY. Need to change original.

    
    
# Only external array needs to be dynamic. Internal one can be set size.
#data = [["10:00", "11:00", "lightgrey"], ["12:00", "13:00", "lightgrey"]]
dataLabels = ["Day of timetable", "start time","end time", "colour", "Class type", "Paper code", "Paper name", "Map url", "Stream", "Room code", "Room name", "Building"]
parseStartTags =["\"day\":", "\"start\":\"", "\"end\":\"","\"fcol\":\"", "\"info\":\"","Paper code:<\/strong> ", "Paper name:<\/strong> ", "href=\\\"", "Stream:<\/strong> ", "target=\\\"_blank\\\">", "Room:<\/strong> ","Building:<\/strong> "]
parseEndTags=[",","\"","\"","\"", "<","<","<","\"","<","<","<","<"]
data = {}



for line in fileinput.input():
    dataIndex = 0;
    dictKeyIndex = 1; # Start time is key
    currKey = ""
    tempInfo = []
    """
    parsedInfo = parse(line, parseStartTags[dataIndex], parseEndTags[dataIndex])
    
    if parsedInfo == None:
        continue
    else:
        if dataIndex == dictKeyIndex:
            currKey = parsedInfo
            data[currKey] = []
        else:
            data[currKey].append(parsedInfo)
        if dataIndex == dataLabels.length():
            break
            dataIndex = 0
        else:
            dataIndex += 1
    """

    
    while True: #breaks if parsedInfo == None (no data)
        parsedInfo = parse(line, parseStartTags[dataIndex], parseEndTags[dataIndex])
        if parsedInfo == None:
            break # Look in next line.
        
        if dataIndex == dictKeyIndex:
                currKey = parsedInfo
        try:
            data[currKey].append(parsedInfo)
        except KeyError:
            tempInfo.append(parsedInfo)
            
        if dataIndex == len(dataLabels)-1:
            data[currKey] = tempInfo
            dataIndex = 0
            tempInfo = []
            # Found all the individual parts of a single entry.
            # Time for new entry.
            break
        else:
            dataIndex += 1
        #continue
     
#tidyData(data)
print dataLabels
print data
#testLine = raw_input()
#print parse(testLine, "\"info\":\"", "<")
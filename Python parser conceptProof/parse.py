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
    
data = {"10:00" : ["11:00", "lightgrey"]}
dataLabels = ["Day of timetable", "start time","end time", "colour", "Class type", "Paper code", "Paper name", "Map url", "Stream", "Room code", "Room name", "Building"]
parseStartTags =["\"day\":", "\"start\":\"", "\"end\":\"","\"fcol\":\"", "\"info\":\"","Paper code:<\/strong> ", "Paper name:<\/strong> ", "href=\\\"", "Stream:<\/strong> ", "target=\\\"_blank\\\">", "Room:<\/strong> ","Building:<\/strong> "]
parseEndTags=[",","\"","\"","\"", "<","<","<","\"","<","<","<","<"]


dataIndex = 0;
dictKeyIndex = 1; # Start time is key
currKey = ""
for line in sys.stdin:
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
            
    
print data
#testLine = raw_input()
#print parse(testLine, "\"info\":\"", "<")
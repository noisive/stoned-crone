""" Returns error if text not found.
Otherwise, searches text until it finds target, 
then returns text between target and endTarget"""

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
					
	#return out
    
data = {"10:00" : ["11:00", "lightgrey"]}
dataLabels = ["Day of week", "start time","end time"]
parseStartTags =["\"day\":", "\"start\":\"", "\"end\":\""]
parseEndTags=[",","\"","\"", ]
for line in inputFile:
    


testLine = raw_input()
print parse(testLine, "\"info\":\"", "<")
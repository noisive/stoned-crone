["Day of timetable", "start time", "end time", "hex colour", "Class type", "Paper code", "Paper name", "Map url", "Stream", "Room code", "Room name", "Building"]
parseStartTags = ["\"day\":", "\"start\":\"", "\"end\":\"", "\"fcol\":\"", "\"info\":\"", "\"info\": \"<br>\n", "Paper:<\/strong><\/span>\n<\/div>\n<div class='sv-col-sm-9\>\n\t<span>", "href=\\\"", "Stream:<\/strong><\/span>\n<\/div>\n<div class='sv-col-sm-9'>\n\t<span>", "target=\\\"_blank\\\">", "Room:<\/strong><\/span>\n<\/div>\n<div class='sv-col-sm-9'>\n\t<span>", "Building:<\/strong><\/span>\n<\/div>\n<div class='sv-col-sm-9'>\n\t<span> "]
parseEndTags = [",", "\"", "\"", "\"", "<", "<", "<", "\"", "<", "<", "<", "<"]


Alternative for paper code, stream? type?
uo_mobile_more_BIOC352S1DNI2017PP1
note that end tag would have to be special. S1,S2,SS,FY. Couldn't be a letter, because might miss papers with S or F in code.

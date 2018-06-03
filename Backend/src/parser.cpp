/*der> Parser class implementation.
    @author Will Shaw - 2017
 
 An object which parses the extracted (and mangled) timetable json.
 The strings it looks for may change with eVision updates -
 these should be changed in the parseInfo method if this happens.
 Creates a timetable object with the data, saves to CSV.
 
 0xCC is used as a default blank 'uninitialised' value.
*/
#include "parser.hpp"
#include <regex>

Parser::Parser(void) {
    this->colorMap["lightgrey"] = "#D3D3D3";
    this->weekStart = 0xCC;
}

int Parser::indexOf(std::string data, std::string pattern) {
//    std::cout << pattern << std::endl;
    std::regex patternRgx(pattern.c_str());
    std::smatch rgxMatch;
//    pattern = slashEscape(pattern);

    if (!std::regex_search(data, rgxMatch, patternRgx)){
        return -1;
    }
    // Actual string matched is at rgxMatch[0]
    int firstCharOfMatchPosition = rgxMatch.position(0);
    // I can't help but feel this is wrong. This is returning position + 1! TODO
    return firstCharOfMatchPosition;
}

int Parser::indexOf(std::string data, std::string pattern, int startIndex) {

    int relIndex = indexOf(data.substr(startIndex), pattern);
    if (relIndex == -1){
        return -1;
    }else{
        return startIndex + relIndex;
    }
}


int Parser::lastIndexOf(std::string data, std::string pattern, int startIndex) {
    int index = this->indexOf(data, pattern, startIndex);
    if (index == -1) {
        return index;
    }
    return index + pattern.length();
}

int Parser::lastIndexOf(std::string data, std::string pattern) {
    return this->lastIndexOf(data, pattern, 0);
}

 std::string Parser::extractSubstrBetween(std::string data, std::string startPattern, std::string endPattern){
//     int startIndex = indexOf(data, startPattern) + startPattern.length();
//     int endIndex = indexOf(data, endPattern, startIndex);
//     return data.substr(startIndex, endIndex - startIndex);
// }
     std::regex startRgx(startPattern.c_str());
     std::regex endRgx(endPattern.c_str());
     std::smatch rgxMatchStart;
     std::smatch rgxMatchEnd;
     if (!std::regex_search(data, rgxMatchStart, startRgx)){
         return "0xCC";
     }
     // Actual string matched is at rgxMatch[0]
     long startI = rgxMatchStart.position(0);
     long startL = rgxMatchStart.length(0);
     long desiredStart = startI + startL;
     if (!std::regex_search(data.substr(desiredStart), rgxMatchEnd, endRgx)){
         return "0xCC";
     }
     long endI = rgxMatchEnd.position(0);
//     int endL = rgxMatch.length(0);
     return data.substr(desiredStart, endI);
 }

void Parser::extractJsonArray() {
    int startIndex = indexOf(this->json, "\\[");
    int endIndex = indexOf(this->json, "\\]");
    // Check to ensure the timetable isn't empty and the indexes were found.
    if (startIndex != -1 && endIndex != -1) {
        this->json = this->json.substr(startIndex, endIndex - startIndex + 1);
    }else{
        std::cerr << "Error: json not found" << std::endl;
    }
    // No data in json.
    if (endIndex - startIndex < 2){
        std::cerr << "Error: json timetable is empty" << std::endl;
    }
}

int Parser::getObjectCount(std::string json) {
    int startIndex = 0;
    int count = 0;

    for (int i = startIndex; i < json.size(); i++) {
        startIndex = lastIndexOf(json, "\\}\\},", startIndex);
        if (startIndex == -1) {
            return count;
        }
        i = startIndex;
        count++;
    }
    return count;
}

std::string Parser::parseMixedLangValue(std::string data, std::string key){
    std::string paperPreRgxStr = key + ":.+?(?=class)class=[^>]*> ";
    std::string divClose = "<\\\\/div>";
    return extractSubstrBetween(data, paperPreRgxStr, divClose);
}

TimetableEvent Parser::parseExam(std::string infoSegment, TimetableEvent ttEvent) {
    int startIndex = 0;
    int endIndex = indexOf(infoSegment, "<br");
    
    // Set paper code
    std::string wierdExamBr = "<br[^>]*>";
    std::string paperCodeStart = wierdExamBr + "\\\\n";
    startIndex = lastIndexOf(infoSegment, paperCodeStart, endIndex) - 1;
    endIndex = indexOf(infoSegment, wierdExamBr, startIndex);
    // - 2 is hack.
    ttEvent.setPaperCode(infoSegment.substr(startIndex - 2, endIndex - startIndex + 2));
    
    // Set maps url
    startIndex = lastIndexOf(infoSegment, "\"", endIndex);
    endIndex = indexOf(infoSegment, "\"", startIndex);
    std::string mapUrl = infoSegment.substr(startIndex, endIndex - startIndex - 1);
    
    // Set map lat
    startIndex = lastIndexOf(mapUrl, "=");
    endIndex = indexOf(mapUrl, ",", startIndex);
    ttEvent.setMapLat(mapUrl.substr(startIndex, endIndex - startIndex));
    
    // Set map long
    startIndex = indexOf(mapUrl, "&", startIndex);
    ttEvent.setMapLong(mapUrl.substr(endIndex + 1, startIndex - endIndex - 1));
    
    // Set room code
    startIndex = lastIndexOf(infoSegment, "\">", endIndex);
    endIndex = indexOf(infoSegment, "<\\\\/a>", startIndex);
    ttEvent.setRoomCode(infoSegment.substr(startIndex, endIndex - startIndex));
    
    // Set paper name
    ttEvent.setPaperName(parseMixedLangValue(infoSegment, "Paper name"));
    
    // Set room name
    ttEvent.setRoomName(parseMixedLangValue(infoSegment, "Room"));

    // Set building name
    ttEvent.setBuilding(parseMixedLangValue(infoSegment, "Building"));
    
    return ttEvent;
    
}

TimetableEvent Parser::parseInfo(std::string infoSegment, TimetableEvent ttEvent) {

    // infoSegment is part of json that starts with "\"info\":"

    // Cut off strange crap first...
    std::string charsBeforeEventType = "div>\\\\n";

    // Strange crap might not be there - let's check it is first.
    std::string checkCharsBeforeEventType="<div";
//    int checkIndex = regex_search(infoSegment, checkCharsBeforeEventType);
    int checkIndex = indexOf(infoSegment, checkCharsBeforeEventType);
    int startIndex = indexOf(infoSegment, charsBeforeEventType) + int(charsBeforeEventType.length() - 1);
    int endIndex = int(infoSegment.length());
    if (checkIndex == 0){
//    if (startIndex < checkIndex){
        infoSegment = infoSegment.substr(startIndex, endIndex);
    }

    // Set event type
    startIndex = 0;
    // int startIndex = indexOf(infoSegment, charsBeforeEventType) - sizeof(charsBeforeEventType);
    endIndex = indexOf(infoSegment, "<br");
    ttEvent.setType(infoSegment.substr(startIndex, endIndex));
    
    if (ttEvent.getType() == "Examination"){
        return parseExam(infoSegment, ttEvent);
    }

    // Set paper code
    std::string paperCodeStart = "<br>\\\\n";
    startIndex = lastIndexOf(infoSegment, paperCodeStart, endIndex) - 1;
    endIndex = indexOf(infoSegment, "<br>", startIndex);
    ttEvent.setPaperCode(infoSegment.substr(startIndex, endIndex - startIndex));

    // Set maps url
    startIndex = lastIndexOf(infoSegment, "\"", endIndex);
    endIndex = indexOf(infoSegment, "\"", startIndex);
    std::string mapUrl = infoSegment.substr(startIndex, endIndex - startIndex - 1);

    // Set map lat
    startIndex = lastIndexOf(mapUrl, "=");
    endIndex = indexOf(mapUrl, ",", startIndex);
    ttEvent.setMapLat(mapUrl.substr(startIndex, endIndex - startIndex));

    // Set map long
    startIndex = indexOf(mapUrl, "&", startIndex);
    ttEvent.setMapLong(mapUrl.substr(endIndex + 1, startIndex - endIndex - 1));

    // Set room code
    startIndex = lastIndexOf(infoSegment, "\">", endIndex);
    endIndex = indexOf(infoSegment, "<\\\\/a>", startIndex);
    ttEvent.setRoomCode(infoSegment.substr(startIndex, endIndex - startIndex));

    // Set paper name
    startIndex = indexOf(infoSegment, "9'", endIndex) + 11;
    endIndex = indexOf(infoSegment, "<\\\\/", startIndex);
    ttEvent.setPaperName(infoSegment.substr(startIndex, endIndex - startIndex));

    // Set room name
    int c = 0;
    while (c < 4) {
        startIndex = lastIndexOf(infoSegment, "<span>", endIndex);
        endIndex = indexOf(infoSegment, "<\\\\", startIndex) - 1; // Cuts space off end.
        c++;
    }
    ttEvent.setRoomName(infoSegment.substr(startIndex, endIndex - startIndex));

    // Set building name
    c = 0;
    while (c < 2) {
        startIndex = lastIndexOf(infoSegment, "<span>", endIndex);
        endIndex = indexOf(infoSegment, "<\\\\", startIndex);
        c++;
    }
    ttEvent.setBuilding(infoSegment.substr(startIndex, endIndex - startIndex));

    return ttEvent;
}


std::string month3CharNameTo2NumString(std::string monthString){
    std::transform(monthString.begin(), monthString.end(), monthString.begin(), ::tolower);
    std::string month3Char [] = {"jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"};
    std::string monthNum [] = {"01", "02","03", "04", "05", "06", "07", "08","09", "10", "11", "12"};
    
    for (int i=0; i<=sizeof(month3Char) / sizeof(month3Char[0]); i++){
        if (monthString == month3Char[i]){
            return monthNum[i];
        }
    }
    std::cerr << "Invalid date format" << std::endl;
    return "0xCC";
}

std::string monthFullNameTo2NumString(std::string monthString){
    std::transform(monthString.begin(), monthString.end(), monthString.begin(), ::tolower);
    std::string monthFull [] = {"january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"};
    std::string monthNum [] = {"01", "02","03", "04", "05", "06", "07", "08","09", "10", "11", "12"};
    
    for (int i=0; i<=sizeof(monthFull) / sizeof(monthFull[0]); i++){
        if (monthString == monthFull[i]){
            return monthNum[i];
        }
    }
    std::cerr << "Invalid date format" << std::endl;
    return "0xCC";
    
}


void Parser::getWeekStart() {
    int startIndex = indexOf(this->json, "ng dates ");
    if (this->json.length() >= 12 && startIndex != -1) {
        // This was the old json format, which stored its date as "Now showing dates 02\/10\/2017 to". New format is "Now showing dates 26\/Mar\/2017 to"
        /* std::string date = this->json.substr(startIndex + sizeof("ng dates ") - 1, 12); */
        int dateStringStartIndex = startIndex + sizeof("ng dates");
        int dateStringLength = indexOf(this->json, " to")-dateStringStartIndex;
        std::string dateSlice = this->json.substr(dateStringStartIndex,dateStringLength);
        
        // \/ has to be escaped, will show up like "\\/" in debugger. Look like \/ in real data.
        std::string slashPair = "\\\\/";
        // Day number is until first slash pair
        int slashIndex = indexOf(dateSlice, slashPair);
        std::string dayIntString = dateSlice.substr(0, slashIndex);
        // Cut the slash off.
        dateSlice = dateSlice.substr(slashIndex+2, std::string::npos);
        
        std::string monthIntString;
        // May be in 3 letter format (eg mar, Nov), or may be in two number form.
        if(indexOf(dateSlice, slashPair) == 3){
            monthIntString = month3CharNameTo2NumString(dateSlice.substr(0, 3));
        }else if(indexOf(dateSlice, slashPair) == 2){
            monthIntString = dateSlice.substr(0,2);
        }else{
            // Include full, just in case they change it again.
            monthIntString = monthFullNameTo2NumString(dateSlice.substr(0,indexOf(dateSlice, slashPair)));
        }
        
        slashIndex = indexOf(dateSlice, slashPair);
        // npos goes to end position
        dateSlice = dateSlice.substr(slashIndex+2, std::string::npos);
        // TODO make this check until " to" instead of assuming 4 digits.
        std::string yearIntString = dateSlice.substr(0, 4);
        // This requires input to be of format dd+mm+yy
        this->weekStart = std::stoi(dayIntString + monthIntString + yearIntString);
    }
//    std::cout<<weekStart << std::endl;
}

std::vector<TimetableEvent> Parser::parseFile(std::string fileName, std::string format) {

    std::vector<TimetableEvent> events;

    if (format.compare("csv") == 0) {

        std::string line;
        std::ifstream file(fileName);
        if (file.is_open()) {
            while (getline(file, line)) {
                if (line.length() > 1) {
                    events.push_back(parseCSVLine(line));
                }
            }
            file.close();
        }
        else
            std::cerr << "Unable to open file " << fileName << std::endl;
    }
    else
        std::cerr << "Format not supported" << std::endl;

    return events;
}

TimetableEvent Parser::parseCSVLine(std::string line) {

    int column = 0;
    std::string build = "";
    TimetableEvent ttEvent;

    for (int i = 0; i < line.length(); i++) {
        if (line.at(i) == ',') {
            switch (column) {
            case 0:
                break;
            case 1:
                ttEvent.setDay(stoi(build));
                break;
            case 2:
                ttEvent.setStartTime(stoi(build));
                break;
            case 3:
                ttEvent.setDuration(stoi(build));
                break;
            case 4:
                ttEvent.setColor(build);
                break;
            case 5:
                ttEvent.setType(build);
                break;
            case 6:
                ttEvent.setPaperCode(build);
                break;
            case 7:
                ttEvent.setPaperName(build);
                break;
            case 8:
                ttEvent.setMapLat(build);
                break;
            case 9:
                ttEvent.setMapLong(build);
                break;
            case 10:
                ttEvent.setRoomCode(build);
                break;
            case 11:
                ttEvent.setRoomName(build);
                break;
            case 12:
                ttEvent.setBuilding(build);
                break;
            }
            column++;
            build = "";
        } else {
            build += line.at(i);
        }
    }

    // Add the trailing column.
    // Implicitly constructs date.
    ttEvent.setDate(build);

    // Once all the data is loaded, generate the UID()
    // as generating this requires many pieces of information.
    ttEvent.genUID();

    return ttEvent;
}

std::vector<TimetableEvent> Parser::parse(const char* data) {
    std::string strData(data);
    return parse(strData);
}
                                         
std::vector<TimetableEvent> Parser::parse(std::string data) {
    this->json = data;

    std::vector<TimetableEvent> events;

    if (this->json == "0xCC" || this->json == "") {
        std::cerr << "No data given" << std::endl;
        return events;
    }

    getWeekStart();

    if (this->weekStart == 0xCC) {
        std::cerr << "No data given" << std::endl;
        return events;
    }

    extractJsonArray();

    int length = getObjectCount(json);

    int startIndex = 0;
    int endIndex = 0;

    std::string infoSegment;
    std::string jsonRemaining;

    for (int i = 0; i <= length; i++) {
        TimetableEvent ttEvent;
        // Need to escape these additionally for regex: ^ $ \ . * + ? ( ) [ ] { } |

        // Set each id
        std::string idString = "id\":\"";
        startIndex = indexOf(json,idString, endIndex) + idString.length();
        // - 1 to endindex to deal with closing quote.
        endIndex = indexOf(json, ",", startIndex) - 1;
        if (startIndex == -1 || endIndex == -1) {
            std::cerr << "Error scraping json" << std::endl;
            // Current approach to a json error? Return empty events.
            return events;
        }
        ttEvent.setId(json.substr(startIndex, endIndex - startIndex));

        // Set each day
        startIndex = indexOf(json, ":", endIndex) + 1;
        endIndex = indexOf(json, ",", startIndex);
        std::string dayStr = json.substr(startIndex, endIndex - startIndex);
        ttEvent.setDay(stoi(dayStr, nullptr));

        // Set each start time
        startIndex = indexOf(json, ":", endIndex) + 2;
        endIndex = indexOf(json, ":", startIndex);
        ttEvent.setStartTime(stoi(json.substr(startIndex, endIndex - startIndex), nullptr));

        // Set each end time
        startIndex = indexOf(json, ":", endIndex + 4) + 2;
        endIndex = indexOf(json, ":", startIndex);
        ttEvent.setEndTime(stoi(json.substr(startIndex, endIndex - startIndex), nullptr));

        // Set each color
        int c = 0;
        while (c < 5) {
            startIndex = indexOf(json, ":", endIndex) + 2;
            endIndex = indexOf(json, "\"", startIndex + 2);
            c++;
        }
        ttEvent.setColor(json.substr(startIndex, endIndex - startIndex));

        // Run a seperate parse on the info segment (html)
        std::string infoString = "info\\\":\"";
        std::string infoEnd =  "/div>\"";
        startIndex = indexOf(json, infoString, endIndex) + infoString.length() - 1;
        endIndex = indexOf(json,infoEnd, endIndex) + infoEnd.length() - 1;
        infoSegment = json.substr(startIndex, endIndex - startIndex - 1);

        ttEvent = parseInfo(infoSegment, ttEvent);

        ttEvent.setDuration(ttEvent.getEndTime() - ttEvent.getStartTime());

        startIndex = indexOf(json, "\\}\\},", endIndex) + 2;
        endIndex = startIndex + 1;
        jsonRemaining = json.substr(endIndex);
//        json = jsonRemaining;
   
        // This will search the colorMap and replace the web color with it's mapped HEX color.
        std::map<std::string, std::string>::iterator it = colorMap.find(ttEvent.getColor());
        if (it != colorMap.end()) {
            ttEvent.setColor(it->second);
        }

        ttEvent.fixDate(this->weekStart);

        ttEvent.genUID();

        events.push_back(ttEvent);
    }
    return events;
}


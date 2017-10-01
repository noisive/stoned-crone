/* Parser class implementation.
    @author Will Shaw - 2017
*/
#include "parser.hpp"
#include <cstring>

std::string dataPath = ((std::string) getenv("HOME")) + "/Library/Caches/data.csv";
std::string gCalPath = ((std::string) getenv("HOME")) + "/Library/Caches/GoogleCalFile.csv";

Parser::Parser(void) {
    this->json = "0xCC";
}

Parser::Parser(bool init) { 
    parseFile(dataPath, "csv"); 
}

/* Data obtained by calling javascript 
window.getData = function() {
    var content = document.getElementById('ttb_timetable').getElementsByTagName('script')[0].innerHTML.trim();
    return content.trim();
    }
window.getData();
*/

Parser::Parser(const char* data) {
    std::string j(data);
    this->json = j;
    this->weekStart = 0xCC;    
}

Parser::Parser(std::string j){
    this->json = j;
    this->weekStart = 0xCC;
}

void Parser::setJson(std::string json) {
    this->json = json;
}

std::string Parser::getJson() {
    return this->json;
}

int Parser::indexOf(std::string data, std::string pattern) {
    return this->indexOf(data, pattern, 0);
}

int Parser::indexOf(std::string data, std::string pattern, int startIndex) {
    int patternIndex = 0;
    for (int i = startIndex; i < data.size(); i++) {
        if (data[i] == pattern[patternIndex]) {
            if (patternIndex == pattern.size() - 1) return (i - patternIndex);
            patternIndex++;
        } else {
            patternIndex = 0;
        }            
    }
    return -1;
}

void Parser::extractJsonArray() {
    int startIndex = indexOf(this->json, "[");
    int endIndex = indexOf(this->json, "]");
    this->json = this->json.substr(startIndex, endIndex - startIndex + 1);
}

int Parser::getObjectCount(std::string json) {
    int startIndex = 0;
    int count = 0;

    for (int i = startIndex; i < json.size(); i++) {
        startIndex = indexOf(json, "}},", startIndex + 3);
        if (startIndex == -1) {
            return count;
        }
        i = startIndex;
        count ++;
    }
    return count;
}

TimetableEvent Parser::parseInfo(std::string infoSegment, TimetableEvent ttEvent) {

    // Set event type        
    int startIndex = 0;
    int endIndex = indexOf(infoSegment, "<");
    ttEvent.setType(infoSegment.substr(startIndex, endIndex));
    
    // Set paper code    
    startIndex = indexOf(infoSegment, "<br>", endIndex) + sizeof("<br>") +1;
    endIndex = indexOf(infoSegment, "<br>", startIndex);
    ttEvent.setPaperCode(
        infoSegment.substr(startIndex, endIndex - startIndex));

    // Set maps url    
    startIndex = indexOf(infoSegment, "\"", endIndex) + 1;
    endIndex = indexOf(infoSegment, "\"", startIndex);
    std::string mapUrl = infoSegment.substr(
                                startIndex, endIndex - startIndex - 1);
    
    // Set map lat
    startIndex = indexOf(mapUrl, "=") + 1;
    endIndex = indexOf(mapUrl, ",", startIndex);
    ttEvent.setMapLat(mapUrl.substr(startIndex, endIndex - startIndex));

    // Set map long
    startIndex = indexOf(mapUrl, "&") - 1;
    ttEvent.setMapLong(mapUrl.substr(endIndex + 1, startIndex - endIndex));

    // Set room code
    startIndex = indexOf(infoSegment, "\">", endIndex) + 2;
    endIndex = indexOf(infoSegment, "<\\/a>", startIndex);
    ttEvent.setRoomCode(
        infoSegment.substr(startIndex, endIndex - startIndex));
    
    // Set paper name
    startIndex = indexOf(infoSegment, "9'", endIndex) + 11;
    endIndex = indexOf(infoSegment, "<\\/", startIndex);
    ttEvent.setPaperName(
        infoSegment.substr(startIndex, endIndex - startIndex));

    // Set room name
    int c = 0;
    while (c < 4) {
        startIndex = indexOf(infoSegment, "<span>", endIndex) + 6;
        endIndex = indexOf(infoSegment, "<\\", startIndex) - 1;
        c++;
    }
    ttEvent.setRoomName(
        infoSegment.substr(startIndex, endIndex - startIndex));
    
    // Set building name
    c = 0;
    while (c < 2) {
        startIndex = indexOf(infoSegment, "<span>", endIndex) + 6;
        endIndex = indexOf(infoSegment, "<\\", startIndex);
        c++;
    }
    ttEvent.setBuilding(
        infoSegment.substr(startIndex, endIndex - startIndex));

    return ttEvent;
}

void Parser::getWeekStart() {
    int startIndex = indexOf(this->json, "ng dates ");
    std::string date = this->json.substr(startIndex + sizeof("ng dates ") - 1, 12);
    this->weekStart = std::stoi(date.substr(0,2) + 
                                date.substr(4,2) +
                                date.substr(8,4));
}

void Parser::parseFile(std::string fileName, std::string format) {

    Timetable timetable;

    if (format.compare("csv") == 0) {

        std::string line;
        std::ifstream file (fileName);
        if (file.is_open()) {
            while (getline(file, line)) {
                if (line.length() > 1) {
                    timetable.addEvent(parseCSVLine(line));
                }
            }
            file.close();
        }

        else std::cerr << "Unable to open file" << std::endl;

    }

    else std::cerr << "Format not supported" << std::endl;
    
    std::cout << timetable.toString() << std::endl;

}

TimetableEvent Parser::parseCSVLine(std::string line) {

    int column = 0;
    std::string build = "";
    TimetableEvent ttEvent;    

    for (int i = 0; i < line.length();  i++) {
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
    // Here set date is used as the date has already been converted.
    ttEvent.setDate(build);

    // Once all the data is loaded, generate the UID();
    ttEvent.genUID();

    std::cout << ttEvent.toString();

    return ttEvent;

}

void Parser::parse() {

    Timetable timetable;

    if (this->json == "0xCC") {
        std::cerr << "No data given" << std::endl;
        return;
    }

    getWeekStart();

    if (this->weekStart == 0xCC) {
        std::cerr << "No data given" << std::endl;
        return;
    }

    extractJsonArray();
    
    int length = getObjectCount(json);

    int startIndex = 0;
    int endIndex = 0;

    std::string infoSegment;

    for (int i = 0; i <= length; i++) {
        TimetableEvent ttEvent;

        // Set each id
        startIndex = indexOf(json, ":", endIndex) + 2;
        endIndex = indexOf(json, ",", startIndex) - 1;
        ttEvent.setId(json.substr(startIndex, endIndex - startIndex));

        // Set each day
        startIndex = indexOf(json, ":", endIndex) + 1;
        endIndex = indexOf(json, ",", startIndex);
        ttEvent.setDay(
            stoi(json.substr(startIndex, endIndex - startIndex), nullptr));

        // Set each start time
        startIndex = indexOf(json, ":", endIndex) + 2;
        endIndex = indexOf(json, ":", startIndex);
        ttEvent.setStartTime(
            stoi(json.substr(startIndex, endIndex - startIndex), nullptr));

        // Set each end time
        startIndex = indexOf(json, ":", endIndex + 4) + 2;
        endIndex = indexOf(json, ":", startIndex);
        ttEvent.setEndTime(
            stoi(json.substr(startIndex, endIndex - startIndex), nullptr));

        // Set each color
        int c = 0;
        while (c < 5) {
            startIndex = indexOf(json, ":", endIndex) + 2;
            endIndex = indexOf(json, "\"", startIndex + 2);
            c++;
        }
        ttEvent.setColor(json.substr(startIndex, endIndex - startIndex));

        // Run a seperate parse on the info segment (html)
        startIndex = indexOf(json, "\"info\":", endIndex) + 
                                sizeof("\"info\":");
        endIndex = indexOf(json, "/div>\"", endIndex) + sizeof("/div>\"") -1;
        infoSegment = json.substr(startIndex, endIndex - startIndex - 1);

        ttEvent = parseInfo(infoSegment, ttEvent);

        ttEvent.setDuration(ttEvent.getEndTime()-ttEvent.getStartTime());

        startIndex = indexOf(json, "}},", endIndex) + 2;
        endIndex = startIndex + 1;
   
        ttEvent.addDate(this->weekStart);
       
        ttEvent.genUID();

        std::cout << ttEvent.toString() << std::endl;

        timetable.addEvent(ttEvent);

    }

    // Save to CSV formatted file. 
    timetable.exportToFile(dataPath);
  
    // Save to Google Calendar Formatted file.
    timetable.exportToGoogleCalFile(gCalPath);

}

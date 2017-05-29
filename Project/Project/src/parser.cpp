/* Parser class implementation.
    @author Will Shaw - 2017
*/
#include "parser.hpp"

Parser::Parser(void) {
    this->json = "0xCC";
}

Parser::Parser(const char* data) {
    std::string j(data);
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
    int patternIndex = 0;
    for (int i = 0; i < data.size(); i++) {
        if (data[i] == pattern[patternIndex]) {
            if (patternIndex == pattern.size() - 1) return (i - patternIndex);
            patternIndex++;
        } else {
            patternIndex = 0;
        }            
    }
    return -1;
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
    startIndex = indexOf(infoSegment, "9'", endIndex) + 13;
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
        startIndex = indexOf(infoSegment, "<span>", endIndex) + 7;
        endIndex = indexOf(infoSegment, "<\\", startIndex) - 1;
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

    for (int i = 0; i < length; i++) {
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

        timetable.addEvent(ttEvent);

    }
    char buffer[265];
    strcpy(buffer, getenv("HOME"));
    std::string filename(buffer);
    filename += "/data.csv";
    timetable.exportToFile(filename);

}

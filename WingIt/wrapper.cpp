
#include "../Backend/src/parser.hpp"
// extern "C" will cause the C++ compiler
// (remember, this is still C++ code!) to
// compile the function in such a way that
// it can be called from C
// (and Swift).

Parser parser;

Timetable timetable;

extern "C" void parseTimetable(const char* data) {
    parser = Parser(data);
    timetable = parser.parse();
}

extern "C" void initParser() {
    timetable = parser.parseCachedFile();
}

extern "C" int numEvents(const char* dateString) {
    return (int) timetable.getByDate(dateString).size();
}

extern "C" const char* getEventsByDate(const char* dateString) {
    std::vector<TimetableEvent> events = timetable.getByDate(dateString);
    
    std::string data = "";
    
    size_t bufferSize =  0;
    
    for (TimetableEvent ev :events ) {
        bufferSize += ev.toString().length();
        data += ev.toString();
    }
    
    bufferSize += 200;
    
    char buffer[bufferSize];
    
    snprintf(buffer, sizeof(buffer), "%s", data.c_str());
    
    return strdup(buffer);
}



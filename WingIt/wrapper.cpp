
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

extern "C" void parseCachedFile() {
    timetable = parser.parseCachedFile();
}

extern "C" const char* getEventsByDate(const char* dateString) {
    
    std::vector<TimetableEvent> events = timetable.getByDate(dateString);
    
    std::string returnData = "";
    
    for (TimetableEvent ev :events ) {
        returnData += ev.toString();
    }
    return returnData.c_str();
}



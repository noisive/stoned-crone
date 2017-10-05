
#include "../Backend/src/timetable.hpp"
// extern "C" will cause the C++ compiler
// (remember, this is still C++ code!) to
// compile the function in such a way that
// it can be called from C
// (and Swift).

Timetable timetable;

extern "C" void parseEvents(const char* data) {
    timetable.parseEvents(data);
}

extern "C" void initTimetable() {
    timetable.restore();
}

extern "C" int queryDate(const char* dateString) {
    return (int) timetable.queryByDate(dateString);
}

extern "C" const char* queryResult(int index) {
    
    std::string data = "";
    
    size_t bufferSize =  0;
    
    TimetableEvent event = timetable.queryResult(index);

    bufferSize += event.toString().length();
    data += event.toString();
    
    bufferSize += 20;
    
    char buffer[bufferSize];
    
    snprintf(buffer, sizeof(buffer), "%s", data.c_str());
    
    return strdup(buffer);
}


#include "timetable.hpp"
// extern "C" will cause the C++ compiler
// (remember, this is still C++ code!) to
// compile the function in such a way that
// it can be called from C
// (and Swift).

Timetable timetable;

extern "C" const char* B_parseEvents(const char* data) {
    std::string CSVData = timetable.parseEvents(data);
    timetable.save();
    
    size_t bufferSize =  0;

    bufferSize += CSVData.length();
    bufferSize += 20;
    char buffer[bufferSize];
    
    snprintf(buffer, sizeof(buffer), "%s", CSVData.c_str());
    
    return strdup(buffer);
}
//std::string parseEvents(std::string data){
//    return std::string(B_parseEvents(data.c_str()));
//}

extern "C" void initTimetable() {
    timetable.restore();
}

extern "C" void validateTimetable() {
    timetable.validate();
}

extern "C" int queryDate(const char* dateString) {
    return (int) timetable.queryByDate(dateString);
}

extern "C" const char* B_queryResult(int index) {
    
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

//// Wrapper to avoid use of CStrings in swift
//std::string queryResult(int index){
//    const char *result = B_queryResult(index);
//    std::string out = std::string(result);
//    std::free((char*)result);
//    return out;
//}


extern "C" const char* B_getFirstEventDate() {
    
    std::string data = "";
    
    size_t bufferSize = 20;
    
    data = timetable.getFirstEventDateString();
    
    char buffer[bufferSize];
    
    snprintf(buffer, sizeof(buffer), "%s", data.c_str());
    
    return strdup(buffer);
}
//std::string getFirstEventDate(){
//    const char *result = B_getFirstEventDate();
//    std::string out = std::string(result);
//    std::free((char*)result);
//    return out;
//}


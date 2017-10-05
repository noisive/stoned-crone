/* Parser class.
    @author Will Shaw - 2017
*/
#ifndef PARSER_H_
#define PARSER_H_

#include <string>
#include "timetableEvent.hpp"
#include "timetable.hpp"
#include <iostream>
#include <map>

class Parser {
    private:
        // Member variables.
        std::string json;
        int weekStart;
        std::string dataPath;
        std::string gCalPath;
        std::map<std::string, std::string> colorMap;

        // Base Functions
        void init();
        void extractJsonArray();
        void getWeekStart();
        int indexOf(std::string data, std::string pattern);
        int indexOf(std::string data, std::string pattern, int startIndex);
        int lastIndexOf(std::string data, std::string pattern, int startIndex);
        int lastIndexOf(std::string data, std::string pattern);

        // Parsing Functions
        int getObjectCount(std::string json);
        TimetableEvent parseCSVLine(std::string line);
        TimetableEvent parseInfo(std::string infoString, TimetableEvent ttEvent);

    public:
        // Constructors
        Parser(void);
        Parser(const char* data);
        Parser(std::string j);

        // Access
        std::string getJson();

        // Parsing
        Timetable parse();
        Timetable parseCachedFile();
        Timetable parseFile(std::string filename, std::string format);

};

#endif  // PARSER_H_

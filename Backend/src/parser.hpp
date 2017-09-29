/* Parser class.
    @author Will Shaw - 2017
*/
#ifndef PARSER_H_
#define PARSER_H_

#include <string>
#include "timetableEvent.hpp"
#include "timetable.hpp"
#include <iostream>

class Parser {
    private:
        // Member variables.
        std::string json;
        int weekStart;

        // Base Functions
        void extractJsonArray();
        void getWeekStart();
        int indexOf(std::string data, std::string pattern);
        int indexOf(std::string data, std::string pattern, int startIndex);

        // Parsing Functions
        int getObjectCount(std::string json);
        void parseFile(std::string filename, std::string format);
        TimetableEvent parseCSVLine(std::string line);
        TimetableEvent parseInfo(std::string infoString, TimetableEvent ttEvent);

    public:
        // Constructors
        Parser(void);
        Parser(bool init);
        Parser(const char* data);
        Parser(std::string j);

        // Access
        void setJson(std::string json);
        std::string getJson();

        // Parsing
        void parse();

};

#endif  // PARSER_H_

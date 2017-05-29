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
        std::string json;
        int weekStart;

        void extractJsonArray();
        void getWeekStart();
        int indexOf(std::string data, std::string pattern);
        
        int indexOf(std::string data, std::string pattern, int startIndex);
        TimetableEvent parseInfo(std::string infoString, TimetableEvent ttEvent);
        int getObjectCount(std::string json);

    public:

        Parser(void);

        Parser(const char* data);

        void setJson(std::string json);

        std::string getJson();

        void parse();

};

#endif  // PARSER_H_

/* Parser class.
    @author Will Shaw - 2017
*/
#ifndef PARSER_HPP_
#define PARSER_HPP_

#include "timetableEvent.hpp"
#include <iostream>
#include <fstream>
#include <map>
#include <vector>

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
        std::string extractSubstrBetween(std::string data, std::string startPattern, std::string endPattern);
        std::string parseMixedLangValue(std::string data, std::string key);

        // Parsing Functions
        int getObjectCount(std::string json);
        TimetableEvent parseCSVLine(std::string line);
        TimetableEvent parseInfo(std::string infoString, TimetableEvent ttEvent);
        TimetableEvent parseExam(std::string infoString, TimetableEvent ttEvent);

    public:
        // Constructors
        Parser(void);
        Parser(const char* data);
        Parser(std::string j);

        // Access
        std::string getJson();

        // Parsing
        std::vector<TimetableEvent> parse(const char* data);
        std::vector<TimetableEvent> parse(std::string data);
        std::vector<TimetableEvent> parseFile(std::string filename, std::string format);
};

#endif  // PARSER_HPP_

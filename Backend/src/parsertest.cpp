#include <iostream>
#include <fstream>
#include <streambuf>
#include "timetable.hpp"
#include "parser.hpp"

int main(int argc, char** argv) {
    
    // Get the home directory for checking files.
    std::string home = getenv("HOME"); 
    
    std::ifstream fileStream("./test/ttb.txt");
    std::string dataString;

    fileStream.seekg(0, std::ios::end);   
    dataString.reserve(fileStream.tellg());
    fileStream.seekg(0, std::ios::beg);

    dataString.assign((std::istreambuf_iterator<char>(fileStream)),
    std::istreambuf_iterator<char>()); 

    std::cout << "\e[33mRunning parse on evision mess.\e[0m" << std::endl;

    Timetable timetable;

    timetable.parseEvents(dataString); 

    timetable.save();

    std::cout << "[\033[32mOK\033[0m] Check file://" + home + 
        "/Library/Caches/data.csv has been parsed." << std::endl << std::endl;    

    std::cout << "\e[33mRunning parse on created CSV file.\e[0m" << std::endl;
  
    timetable.restore();

    int numEvents = timetable.queryByDate("2017-09-28");

    for (int i = 0; i < numEvents; i++) {
        std::cout << timetable.queryResult(i).toString() << std::endl;
    }

    numEvents = timetable.queryByDate("2017-09-27");

    for (int i = 0; i < numEvents; i++) {
        std::cout << timetable.queryResult(i).toString() << std::endl;
    }

    std::cout << "[\e[32mOK\e[0m] Check that the "
        "above looks correct." << std::endl << std::endl;

    return 0;
}

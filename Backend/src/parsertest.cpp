#include <iostream>
#include <fstream>
#include <streambuf>
#include "timetable.hpp"
#include "parser.hpp"
#include <iostream>      /* puts */
#include <time.h>       /* time_t, struct tm, time, localtime, strftime */
#include <cstring>

// http://www.cplusplus.com/reference/ctime/strftime/
// strftime example
std::string getCurrentDate()
{
  time_t rawtime;
  struct tm * timeinfo;
  char st [80];
	
  time (&rawtime);
  timeinfo = localtime (&rawtime);

  strftime (st,80,"%y-%m-%d",timeinfo);
  return std::string(st);
}

int main(int argc, char** argv) {
    
    // Get the home directory for checking files.
    std::string home = getenv("HOME"); 
    
    /* std::ifstream fileStream("./test/ttb.txt"); */
    std::ifstream fileStream("../parserTests/Test html json/easterjson.txt");
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

    const char * todayDateTime = getCurrentDate().c_str();
    /* auto todayDateTime = getCurrentDate(); */
    std::cout << todayDateTime;

    int numEvents = timetable.queryByDate(todayDateTime);

    for (int i = 0; i < numEvents; i++) {
        std::cout << timetable.queryResult(i).toString() << std::endl;
    }

    numEvents = timetable.queryByDate(todayDateTime);

    for (int i = 0; i < numEvents; i++) {
        std::cout << timetable.queryResult(i).toString() << std::endl;
    }

    std::cout << "[\e[32mOK\e[0m] Check that the "
        "above looks correct." << std::endl << std::endl;

    return 0;
}


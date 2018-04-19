#include <iostream>
#include <fstream>
#include <streambuf>
#include "timetable.hpp"
#include "parser.hpp"
#include <iostream>      /* puts */
#include <time.h>       /* time_t, struct tm, time, localtime, strftime */
#include <cstring>

std::string getPathBaseDir (std::string str);

int main(int argc, char** argv) {
    
    if(argc != 2){
        std::cout << "Usage: createcsv [file]" << std::endl;
    }
    // std::string inFilePath = pf(argv[1]);
    std::string inFilePath = argv[1];
    
    // Read file contents into dataString
    std::ifstream fileStream(inFilePath);
    std::string dataString;

    fileStream.seekg(0, std::ios::end);
    dataString.reserve(fileStream.tellg());
    fileStream.seekg(0, std::ios::beg);

    dataString.assign((std::istreambuf_iterator<char>(fileStream)),
    std::istreambuf_iterator<char>());

    /* Parse and save in same directory as test */
    std::string dataPath = getPathBaseDir(inFilePath);
    Timetable timetable(dataPath);
    timetable.parseEvents(dataString);
    timetable.save();

    return 0;
}

std::string getPathBaseDir (std::string str) {
  int found=str.find_last_of("/\\");
  // cout << " folder: " << str.substr(0,found) << endl;
  // cout << " file: " << str.substr(found+1) << endl;
  return str.substr(0, found);
}

#include <iostream>
#include <fstream>
#include <streambuf>
#include "timetable.hpp"
#include "parser.hpp"

int main(int argc, char** argv) {

    // Read the dummy data from file.
  
    std::ifstream fileStream("../data.txt");
    std::string dataString;

    fileStream.seekg(0, std::ios::end);   
    dataString.reserve(fileStream.tellg());
    fileStream.seekg(0, std::ios::beg);

    dataString.assign((std::istreambuf_iterator<char>(fileStream)),
    std::istreambuf_iterator<char>()); 

    const char* data = "something"; 
    Parser parser(dataString);
    parser.parse();

    return 0;
}

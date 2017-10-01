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

    Parser parser(dataString);
    parser.parse();

    std::cout << "[\033[32mOK\033[0m] Check file://" + home + 
        "/Library/Caches/data.csv has been parsed." << std::endl << std::endl;    

    std::cout << "\e[33mRunning parse on created CSV file.\e[0m" << std::endl;

    parser = Parser(true);
    
    std::cout << "[\e[32mOK\e[0m] Check that the "
        "above looks correct." << std::endl << std::endl;

    return 0;
}

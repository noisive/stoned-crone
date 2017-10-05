//
//  stdinParse.cpp
//  Backend
//
//  Created by William Warren on 10/6/17.
//  Copyright © 2017 Noisive. All rights reserved.
//

#include "stdinParse.hpp"
#include <iostream>
#include <string>
#include "../parser.hpp"

int main() {
    
    for (std::string line; std::getline(std::cin, line);) {
        parser = Parser(line);
        timetable = parser.parse();
        
    }
    return 0;
}

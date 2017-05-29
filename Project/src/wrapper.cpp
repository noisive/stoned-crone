
#include "parser.hpp"
// extern "C" will cause the C++ compiler
// (remember, this is still C++ code!) to
// compile the function in such a way that
// it can be called from C
// (and Swift).
extern "C" void parseTimetable(const char* data) {
    Parser parser(data);
    parser.parse();
}

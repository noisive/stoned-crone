/* Timetable Domain Class.
    @author W. Warren - 2017
*/
#ifndef TIMETABLE_H_
#define TIMETABLE_H_

#include <string>
#include <vector>
#include "timetableEvent.hpp"
#include <fstream>

typedef TimetableEvent te;

class Timetable {
    private:
        std::vector<te> tt;

    public:
        Timetable();
        void addEvent(te t);
        void removeEvent(te t);
        void updateEvent(te t);
        int size();
        std::string toString();
        void printToCSV();
        void exportToFile(std::string fileName);
       };

#endif // TIMETABLE_H_


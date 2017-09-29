/* Timetable Domain Class.
    @author W. Warren - 2017
*/
#ifndef TIMETABLE_H_
#define TIMETABLE_H_

#include <string>
#include <vector>
#include "timetableEvent.hpp"
#include <fstream>

typedef TimetableEvent ttEvent;

class Timetable {
    private:
        // eVision events list.
        std::vector<ttEvent> eventList;
        // Custom events list.
        std::vector<ttEvent> customEvents;
        
        void clean(std::vector<ttEvent> &list);
        void removeEvent(ttEvent t, std::vector<ttEvent> &list);

    public:
        // Constructors
        Timetable();

        // Base Functions
        void addEvent(ttEvent t);
        void addEvent(ttEvent t, bool custom);
        void removeEvent(ttEvent t);
        void removeEvent(ttEvent t, bool custom);
        void updateEvent(ttEvent t, bool custom);
        int size();
        std::string toString();

        // Integration
        const char* getByDate(const char* date);
        int merge();

        // Exporting
        void printToCSV();
        void exportToFile(std::string fileName);
        void exportToGoogleCalFile(std::string fileName);

};

#endif // TIMETABLE_H_

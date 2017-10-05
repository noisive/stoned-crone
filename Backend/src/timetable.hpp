/* Timetable Domain Class.
    @author W. Warren - 2017
*/
#ifndef TIMETABLE_H_
#define TIMETABLE_H_

#include <string>
#include <vector>
#include "timetableEvent.hpp"
#include <fstream>
#include "parser.hpp"

typedef TimetableEvent ttEvent;

class Timetable {
    private:
        // eVision events list.
        std::vector<ttEvent> eventList;
        // Custom events list.
        std::vector<ttEvent> customEvents;

        // Save file paths.
        std::string dataPath;
        std::string gCalPath;

        // Timetable Maintenance
        void reset();
        void clean(std::vector<ttEvent> &list);
        void removeEvent(ttEvent t, std::vector<ttEvent> &list);

    public:
        // Constructors
        Timetable();

        // Base Functions
        void addEvent(ttEvent t);
        void addEvent(ttEvent t, bool custom);
        
        void addMultiple(std::vector<ttEvent> events);
        void addMultiple(std::vector<ttEvent> events, bool custom);

        void removeEvent(ttEvent t);
        void removeEvent(ttEvent t, bool custom);
        
        void updateEvent(ttEvent t, bool custom);
        int size();
        std::string toString();

        // Integration
        void parseEvents(std::string jumbledData);
        std::vector<ttEvent> getByDate(const char* date);
        int merge();
        TimetableEvent getByUID(const char* id);
        void addEvent(const char* event);

        // Persistence
        void save();
        void restore();
        void printToCSV();
        void exportToFile(std::string fileName);
        void exportToGoogleCalFile(std::string fileName);

};

#endif // TIMETABLE_H_

/* Timetable Domain Class.
    @author W. Warren - 2017
*/
#ifndef TIMETABLE_H_
#define TIMETABLE_H_

#include "timetableEvent.hpp"
#include "parser.hpp"
#include <sstream>
#include <vector>

typedef TimetableEvent ttEvent;

class Timetable {
    private:
        // eVision events list.
        std::vector<ttEvent> eventList;
        // Custom events list.
        std::vector<ttEvent> customEvents;

        // Cached query
        std::vector<ttEvent> queryStore;

        // Save file paths.
        std::string dataPath;
        std::string gCalPath;

        // Timetable Maintenance
        void reset();
        void clean(std::vector<ttEvent> &list);
        void removeEvent(ttEvent t, std::vector<ttEvent> &list);

    public:
        // Constructors
        Timetable(std::string dataBasePath = (std::string)getenv("HOME") + "/Library/Caches");

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
        int queryByDate(const char* d);
        TimetableEvent queryResult(int index);
        int merge();
        TimetableEvent getByUID(const char* id);
        void addEvent(const char* event);
    
        std::string getFirstEventDateString();
        std::string getLastEventDateString();


        // Persistence
        void save(std::string filePath = "0x8C");
        void restore();
        void printToCSV();
        void exportToFile(std::string fileName);
        void exportToGoogleCalFile(std::string fileName);

};

#endif // TIMETABLE_H_

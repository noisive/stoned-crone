/* TimetableEvent Domain Class.
    @author Will Shaw - 2017
*/

#ifndef TIMETABLEEVENT_H_
#define TIMETABLEEVENT_H_

#include "date.hpp"

class TimetableEvent {
    private:
        unsigned long uid; // Unique identifier for each TT.
        std::string id;
        Date date; // ISO format, or specific legacy format.
        int duration; // in hours
        int mapZoom;
        int startTime; // hour, in 24h time.
        int endTime; // not used
        int day; // Day of week as int, mon=1
        std::string color;
        std::string mapLat;
        std::string mapLong;
        std::string paperCode; // eg COSC345
        std::string paperName; // Paper description
        std::string roomCode; // Eg STDAV1
        std::string roomName; // Full name of room
        std::string building;
        std::string mapUrl;
        std::string type; // Lecture, lab, tut, etc.
 
        unsigned long hash();
    

    public:
    
        TimetableEvent(void); 

        bool validateEventData();

        unsigned long getUID();

        bool equals(TimetableEvent other);
        
        void genUID(); // Seems to be unused...

        // Wraps the setDate function to parse and add days from evision.
        void fixDate(int startingDate);
        Date getDate();
        void setDate(Date date);

        std::string getId() const;
        void setId(std::string id);

        int getDuration() const;
        void setDuration(const int duration);

        int getStartTime() const;
        void setStartTime(int startTime);

        int getEndTime() const;
        void setEndTime(int endTime);

        int getDay() const;
        void setDay(int day);

        std::string getPaperCode() const;
        void setPaperCode(std::string paperCode);

        std::string getPaperName() const;
        void setPaperName(std::string paperName);

        std::string getRoomCode() const;
        void setRoomCode(std::string roomCode);

        std::string getRoomName() const;
        void setRoomName(std::string roomName);

        std::string getBuilding() const;
        void setBuilding(std::string building);

        std::string getMapLat() const;
        void setMapLat(std::string mapLat);

        std::string getMapLong() const;
        void setMapLong(std::string mapLong);

        std::string getType() const;
        void setType(std::string type);

        std::string getColor() const;
        void setColor(std::string hexColor);

        std::string toString();

        std::string toCSVRow() const; 
};

#endif // TIMETABLEEVENT_H_

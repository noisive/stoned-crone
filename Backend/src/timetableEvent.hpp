/* TimetableEvent Domain Class.
    @author Will Shaw - 2017
*/

#ifndef TIMETABLEEVENT_H_
#define TIMETABLEEVENT_H_

#include <string>

class TimetableEvent {
    private:
        unsigned long uid;
        std::string id;
        std::string date;
        int duration;
        int mapZoom;
        int startTime;
        int endTime;
        int day;
        std::string color;
        std::string mapLat;
        std::string mapLong;
        std::string paperCode;
        std::string paperName;
        std::string roomCode;
        std::string roomName;
        std::string building;
        std::string mapUrl;
        std::string type;

        void datePlusDays( struct tm* date, int days );
        struct tm createDate(int day, int month, int year);
        void setDate(std::string date);
        unsigned long hash();
    
    public:
    
        TimetableEvent(void); 

        unsigned long getUID();

        bool equals(TimetableEvent other);
        
        void genUID();
        
        // Wraps the setDate function to parse into a standard format.
        void addDate(int startingDate);
        std::string getDate() const;

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

        std::string toString() const;

        std::string toCSVRow() const;

        bool equals(TimetableEvent other) const;
};

#endif // TIMETABLEEVENT_H_

/* Timetable Domain Class.
    @author W. Warren - 2017
*/
#include "timetable.hpp"
#include <cstring>
#include <iostream> 
#include <fstream>
#include <cmath>
#include <sstream>

/* Defines implementation for timetable. Stores array of TimetableEvents */

typedef TimetableEvent te;

    /* Set initial vector size.
     * 20 is a rough peak for number of classes in a week. */
std::vector<te> tt(20);
    
Timetable::Timetable() {

}

void Timetable::addEvent(te t){
    tt.push_back(t);
}

void Timetable::removeEvent(te t){
    std::string id = t.getId();

    for(int i = 0; i<tt.size(); i++){
        if(tt[i].getId() == id){
            tt.erase(tt.begin() + i);
        }
    }
}

void Timetable::updateEvent(te t){
    removeEvent(t);
    Timetable::addEvent(t);
}

int Timetable::size() {
    return tt.size();
}

std::string Timetable::toString() {
    std::string out = "Timetable of size: " + 
                        std::to_string(size()) + " with elements: ";
    for (TimetableEvent event : tt) {
        out += event.getId() + ", ";
    }
    return out.substr(0, out.size() - 2); 
}

void Timetable::exportToFile(std::string fileName) {
    std::ofstream myfile;
    myfile.open (fileName);
    if (myfile.is_open()){
        std::string output;

        for (TimetableEvent event: tt) {
            output += event.toString();
        }

        myfile << output;
        myfile.close();
    }else{
        // Error opening file
        std::cout << "Unable to open file \"" << fileName <<"\"\n";
    }
}

/* These next two methods purely for turning an event toString
    into a format accepted by Google.
*/
std::string dateFormat(std::string dateNumbers){
    if (dateNumbers.length() != 8){
        return "error";
    }else{
        return dateNumbers.substr(0,2) + "/" + dateNumbers.substr(2,2) + "/" + dateNumbers.substr(4,4); 
    }
}
std::string timeFormat(int timeNumber, bool isEndTime=false){
    std::string ampm;
    std::ostringstream oss;
    if (isEndTime){
        // reduce by 1, add 50 to minutes
        timeNumber--;
    }
   if (timeNumber > 12){
    ampm = "PM";
   }else{
       ampm = "AM";
   }
   timeNumber %= 12;
   std::string minsec;
   if (isEndTime){
       minsec = "50:00 ";
   }else{
       minsec = "00:00 ";
   }
   oss << timeNumber << ":" << minsec << ampm;
   return oss.str();
}

void Timetable::exportToGoogleCalFile(std::string fileName) {
    std::ofstream myfilew;
    std::ifstream myfiler;
    std::string output = "Subject,Start Date,End Date,Start Time,End Time,Description,Location,Private\n";
    myfiler.open (fileName); 
    if (myfiler.is_open()){
        std::string headerLine;
        std::getline(myfiler, headerLine);
        headerLine+="\n";
        // First line is required headers for import to google cal.
        if(headerLine == output){
            // File already exists, already has header.
            // So don't add it again.
            output = "";
        }
    }
    myfiler.close();
    myfilew.open(fileName,std::ofstream::app);
    if (myfilew.is_open()){
        myfilew << output;
        for (TimetableEvent event: tt) {
            std::string date = dateFormat(event.getDate());
            myfilew << event.getPaperCode() << " " << event.getType() << "," << date << "," << date << "," << timeFormat(event.getStartTime()) << "," << timeFormat(event.getEndTime(), true) << "," << "\"" << event.getPaperName() << "\"" <<" in " << event.getRoomName() << ": " << event.getBuilding() << "," << event.getRoomCode() << "," << "True" << std::endl;         
        }
        
        myfilew.close();
    }else{
        // Error opening file
        std::cout << "Unable to open file \"" << fileName <<"\"\n";
    }
}
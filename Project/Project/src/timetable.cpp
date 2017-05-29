/* Timetable Domain Class.
    @author W. Warren - 2017
*/
#include "timetable.hpp"
#include <cstring>

/* Defines implementation for timetable. Stores array of TimetableEvents */

typedef TimetableEvent te;

    /* Set initial vector size.
     * 20 is a rough peak for number of classes in a week. */
std::vector<te> tt(20);
    
int startingDate = 27052017;

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
    std::string output;

    for (TimetableEvent event: tt) {
        output += event.toString();
    }

    myfile << output;
    myfile.close();
}

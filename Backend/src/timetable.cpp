/* Timetable Domain Class.
   @author W. Warren - 2017
   */
#include "timetable.hpp"

/* Set initial vector size.
 * 20 is a rough peak for number of classes in a week. */

std::vector<TimetableEvent> eventList(40);
std::vector<TimetableEvent> customList(40);
std::vector<TimetableEvent> queryStore(40);

Timetable::Timetable(std::string dataBasePath) {
    reset();
    this->dataPath = dataBasePath + "/data.csv";
    this->gCalPath = dataBasePath + "/GoogleCalFile.csv";
}

void Timetable::restore() {
    reset();
    Parser parser;
    std::vector<TimetableEvent> events = parser.parseFile(dataPath, "csv");
    addMultiple(events);
}

void Timetable::reset() {
    eventList.clear();
    customList.clear();
    queryStore.clear();
}

void Timetable::parseEvents(std::string jumbledData) {
    reset();
    Parser parser;
    std::vector<TimetableEvent> events = parser.parse(jumbledData);
    addMultiple(events);
    for (TimetableEvent event : events){
        event.validateEventData();
    }
}

void Timetable::save(std::string filePath) {
    if(filePath != "0x8C"){
        dataPath = filePath;
    }else{
        exportToGoogleCalFile(gCalPath);
    }
    exportToFile(dataPath);
}

void Timetable::addMultiple(std::vector<TimetableEvent> events) {
    addMultiple(events, false);
}

void Timetable::addMultiple(std::vector<TimetableEvent> events, bool custom) {
    for (TimetableEvent event : events) { 
        this->eventList.push_back(event);
    }
}

void Timetable::addEvent(TimetableEvent t) {
    this->addEvent(t, false);
}

void Timetable::addEvent(const char* event) {
    // An event comes from swift as a string (CSV).
    // we can parse and add it here.
}

void Timetable::addEvent(TimetableEvent t, bool custom) {
    if (custom) {
        customList.push_back(t);
    } else {
        eventList.push_back(t);
    }
}

/* Find the item in the referenced list and remove it. */
void Timetable::removeEvent(TimetableEvent t, std::vector<TimetableEvent> &list) {
    std::string id = t.getId();
    for (int i = 0; i < list.size(); i++) {
        if (list[i].getId() == id) {
            list.erase(list.begin() + i);
            return;
        }
    } 
}

void Timetable::removeEvent(TimetableEvent t, bool custom) {
    if (custom) {
        this->removeEvent(t, customList);
        return;
    }
    this->removeEvent(t, eventList);
}

void Timetable::removeEvent(TimetableEvent t) {
    this->removeEvent(t, false);
}

void Timetable::clean(std::vector<TimetableEvent> &list) { 
    time_t gmt = time(0);
    struct tm* now = localtime(&gmt); 

    for (int i = 0; i < list.size(); i++) {
        if (list[i].getStartTime() + list[i].getDuration() < now->tm_hour) {
            this->removeEvent(list[i]);
            // Decrement i to account for concurrent modification.
            i--;
        }
    }
}

int Timetable::merge() {
    int numRemoved = 0;
    for (int i = 0; i < eventList.size(); i++) {
        for (int c = 0; c < customList.size(); c++) {
            if (eventList[i].equals(customList[c])) {
                std::cerr << "Removing overridden event." << std::endl;
                removeEvent(eventList[i]);
                numRemoved++;
                i--;
            }
        }
    }
    return numRemoved;
}

int Timetable::queryByDate(const char* d) {
    queryStore.clear();
    Date date(d);
    for (TimetableEvent event : eventList) {
        if (date.compare(event.getDate()) == 0) {
            queryStore.push_back(event); 
        }
    }
    return (int) queryStore.size();
}

std::string Timetable::getFirstEventDateString(){
    if (eventList.size() == 0){
        return "0xCC";
    }
    TimetableEvent event = eventList[0];
    return event.getDate().ISODate();
}
// TODO test this.
std::string Timetable::getLastEventDateString(){
    if (eventList.size() == 0){
        return "0xCC";
    }
    TimetableEvent event = eventList.back();
    return event.getDate().ISODate();
}

TimetableEvent Timetable::queryResult(int index) {
    if (index == queryStore.size() - 1) {
        TimetableEvent event = queryStore[index];
        queryStore.clear();
        return event;
    }
    return queryStore[index]; 
}

TimetableEvent Timetable::getByUID(const char* id) {
    char* pEnd;
    unsigned long uid = strtoul(id,&pEnd,10);
    for (TimetableEvent event : eventList) {
        if (event.getUID() == uid) {
            return event;
        }
    }

    for (TimetableEvent event : customList) {
        if (event.getUID() == uid) {
            return event;
        }
    }
    return TimetableEvent();
}

void Timetable::updateEvent(TimetableEvent t, bool custom) {
    this->removeEvent(t, custom);
    this->addEvent(t, custom);
}

int Timetable::size() {
    return (int) eventList.size();
}

std::string Timetable::toString() {
    std::string out = "Timetable of size: " + 
        std::to_string(size()) + " with elements: ";

    /* Uncomment to delete events in the past.
       this->clean(eventList);
       this->clean(customList);
       */

    for (TimetableEvent event : eventList) {
        out += event.getPaperCode() + ", ";
    }

    for (TimetableEvent event : customList) { 
        out += event.getPaperCode() + ", ";
    }

    return out.substr(0, out.size() - 2); 
}

void Timetable::exportToFile(std::string fileName) {
    std::ofstream myfile;
    myfile.open (fileName);
    if (myfile.is_open()) {
        std::string output;

        /* Uncomment to delete events in the past.
           this->clean(eventList);
           this->clean(customList);
           */

        for (TimetableEvent event: eventList) {
            output += event.toString() + "\n";
        }

        for (TimetableEvent event: customList) {
            output += event.toString() + "\n";
        }

        myfile << output;
        myfile.close();

    } else {
        // Error opening file
        std::cerr << "Unable to open file \"" << fileName <<"\"\n";
    }
}

/* These next two methods purely for turning an event toString
   into a format accepted by Google.
   */
std::string dateFormat(std::string dateNumbers) {
    if (dateNumbers.length() != 8) {
        return "error";
    } else {
        return dateNumbers.substr(0,2) + "/" + dateNumbers.substr(2,2) + "/" + dateNumbers.substr(4,4); 
    }
}
std::string timeFormat(int timeNumber, bool isEndTime=false) {
    std::string ampm;
    std::ostringstream oss;
    if (isEndTime) {
        // reduce by 1, add 50 to minutes
        timeNumber--;
    }
    if (timeNumber > 12) {
        ampm = "PM";
    } else {
        ampm = "AM";
    }
    timeNumber %= 12;
    std::string minsec;
    if (isEndTime) {
        minsec = "50:00 ";
    } else {
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
    if (myfiler.is_open()) {
        std::string headerLine;
        std::getline(myfiler, headerLine);
        headerLine += "\n";
        // First line is required headers for import to google cal.
        if (headerLine == output) {
            // File already exists, already has header.
            // So don't add it again.
            output = "";
        }
    }
    myfiler.close();
    myfilew.open(fileName,std::ofstream::app);

    if (myfilew.is_open()) {
        myfilew << output;
        for (TimetableEvent event: eventList) {
            std::string date = event.getDate().ISODate();
            myfilew << event.getPaperCode() << " " << event.getType() << "," << date << "," << date 
                << "," << timeFormat(event.getStartTime()) << "," << timeFormat(event.getEndTime(), true) 
                << "," << "\"" << event.getPaperName() << "\"" <<" in " << event.getRoomName() << ": " 
                << event.getBuilding() << "," << event.getRoomCode() << "," << "True" << std::endl;         
        }
        myfilew.close();

    } else {
        // Error opening file
        std::cerr << "Unable to open file \"" << fileName <<"\"\n";
    }
}

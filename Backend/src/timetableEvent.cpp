/* TimetableEvent Implementation class.
    @author Will Shaw - 2017
*/
#include "timetableEvent.hpp"
#include <ctime>
#include <iomanip>
#include <sstream>
#include <iostream>

TimetableEvent::TimetableEvent(void) {
    this->uid = 0xCC;
    this->id = "0xCC";
    this->date = "0xCC";
    this->day = 0xCC;
    this->duration = 0xCC;
    this->startTime = 0xCC;
    this->endTime = 0xCC;
    this->mapLat = "0xCC";
    this->mapLong = "0xCC";
    this->paperCode = "0xCC";
    this->paperName = "0xCC";
    this->roomCode = "0xCC";
    this->roomName = "0xCC";
    this->building = "0xCC";
    this->type = "0xCC";
}

unsigned long TimetableEvent::hash() {
    unsigned long hash = 3; 
    int val = 0;
    for (int i = 0; i < this->paperName.length(); i++) {
        val += ((int) this->paperName[i]);
    } 
    hash = hash * 3 + val;
    val = 0;
    hash = hash * 3 + this->day;
    for (int i = 0; i < this->type.length(); i++) {
        val += ((int) this->type[i]);
    }
    hash = hash * 3 + val;
    val = 0;
    hash = hash * 3 + this->startTime;
    hash = hash * 3 + this->duration;
    for (int i = 0; i < this->date.length(); i++) {
        val += ((int) this->date[i]);
    }
    hash = hash * 3 + val;
    return hash;
}

unsigned long TimetableEvent::getUID() {
    return this->uid;
}

void TimetableEvent::genUID() {
    this->uid = this->hash();
}

/* Accessor Functions */

std::string TimetableEvent::getId() const { return this->id; }

std::string TimetableEvent::getDate() const { return this->date; }

int TimetableEvent::getDuration() const { return this->duration; }

std::string TimetableEvent::getPaperCode() const { return this->paperCode; }

std::string TimetableEvent::getPaperName() const { return this->paperName; }

std::string TimetableEvent::getRoomCode() const { return this->roomCode; }

std::string TimetableEvent::getRoomName() const { return this->roomName; }

std::string TimetableEvent::getBuilding() const { return this->building; }

std::string TimetableEvent::getMapLat() const { return this-> mapLat; }

std::string TimetableEvent::getMapLong() const { return this-> mapLong; }

std::string TimetableEvent::getType() const { return this->type; }

int TimetableEvent::getStartTime() const { return this->startTime; }

int TimetableEvent::getEndTime() const { return this->endTime; }

int TimetableEvent::getDay() const { return this->day; }

std::string TimetableEvent::getColor() const { return this->color; }


/* Mutator functions */

void TimetableEvent::setId(std::string id) { this->id = id; }

void TimetableEvent::setDate(std::string date) { this->date = date; }

void TimetableEvent::setDuration(const int duration) 
                                    { this->duration = duration; }

void TimetableEvent::setPaperCode(std::string paperCode) 
                                    { this->paperCode = paperCode; }

void TimetableEvent::setPaperName(std::string paperName) 
                                    { this->paperName = paperName; }

void TimetableEvent::setRoomCode(std::string roomCode) 
                                    { this->roomCode = roomCode; }

void TimetableEvent::setRoomName(std::string roomName) 
                                    { this->roomName = roomName; }

void TimetableEvent::setBuilding(std::string building) 
                                    { this->building = building; }

void TimetableEvent::setMapLat(std::string mapLat) { this->mapLat = mapLat; }

void TimetableEvent::setMapLong(std::string mapLong) { this->mapLong = mapLong; }

void TimetableEvent::setType(std::string type) { this->type = type; }

void TimetableEvent::setStartTime(int startTime) 
                                    { this->startTime = startTime; }

void TimetableEvent::setEndTime(int endTime) { this->endTime = endTime; }

void TimetableEvent::setDay(int day) { this->day = day; }

void TimetableEvent::setColor(std::string hexColor) { this->color = hexColor; }


// Adjust date by a number of days +/-
// source: user Clifford, StackOverflow, 2010.
// https://stackoverflow.com/questions/2344330/algorithm-to-add-or-subtract-days-from-a-date
void TimetableEvent::datePlusDays(struct tm* date, int days) {
    const time_t ONE_DAY = 24 * 60 * 60;

    // Seconds since start of epoch
    time_t date_seconds = mktime(date) + (days * ONE_DAY);

    // Update caller's date
    // Use localtime because mktime converts to UTC so may change date
    *date = *localtime(&date_seconds);
}

// Adapted from Clifford (2010)
struct tm TimetableEvent::createDate(int day, int month, int year) {
    struct tm date = { 0, 0, 12 };  // nominal time midday (arbitrary).
    // Set up the date structure
    date.tm_year = year - 1900;
    date.tm_mon = month - 1;  // note: zero indexed
    date.tm_mday = day;       // note: not zero indexed
    return date;
}

bool TimetableEvent::equals(TimetableEvent other) const {
    if (this->uid != 0xCC && this->uid == other.getUID()) {
        return true;
    }
    return false;
}

void TimetableEvent::addDate(int startingDate) {
    // Get sets of digits out of int.
    int year = startingDate % 10000;
    int month = (startingDate % 1000000 - year) / 10000;
    int day = (startingDate % 100000000 - year - month) / 1000000;

    struct tm date = createDate(day, month, year);
    datePlusDays(&date, this->day);

    std::ostringstream syear;
    syear  << std::setw(4) << std::setfill( '0' ) << year;
    std::ostringstream smonth;
    smonth  << std::setw(2) << std::setfill( '0' ) << month;
    std::ostringstream sday;
    sday  << std::setw(2) << std::setfill( '0' ) << day;

    setDate(sday.str()+smonth.str()+syear.str());
}

/* To std::string function */

std::string TimetableEvent::toString() const {
        return std::to_string(this->uid) + 
        "," + std::to_string(this->day) + 
        "," + std::to_string(this->startTime) + 
        "," + std::to_string(this->duration) + 
        "," + this->color +  
        "," + this->type + 
        "," + this->paperCode + 
        "," + this->paperName + 
        "," + this->mapLat + 
        "," + this->mapLong + 
        "," + this->roomCode +
        "," + this->roomName +
        "," + this->building +
        "," + this->date + "\n";
}


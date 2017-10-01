/* TimetableEvent Implementation class.
    @author Will Shaw - 2017
*/
#include "timetableEvent.hpp"
#include <ctime>
#include <iomanip>
#include <sstream>
#include <iostream>
#include "date.hpp"

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

bool TimetableEvent::equals(TimetableEvent other) {
    if (this->uid != 0xCC && this->uid == other.getUID()) {
        return true;
    }
    return false;
}

void TimetableEvent::addDate(int startingDate) {    
    Date date(startingDate);
    date.addDays(this->day - 1); // 1 on eVision is the first day.
    setDate(date.legacyDate()); 
}

/* Output a string representation of this event. */
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


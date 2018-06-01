/* TimetableEvent Implementation class.
   @author Will Shaw - 2017
   */
#include "timetableEvent.hpp"
#include <assert.h>
#include <regex>

TimetableEvent::TimetableEvent(void) {
    this->uid = 0xCC; // Unique identifier for each TT.
    this->id = "0xCC"; // Seems to be unused...
    this->date = Date(); // ISO format, or specific legacy format.
    this->day = 0xCC; // Day of week as int, mon=1
    this->duration = 0xCC; // in hours
    this->startTime = 0xCC; // hour, in 24h time.
    this->endTime = 0xCC; // not used
    this->mapLat = "0xCC";
    this->mapLong = "0xCC";
    this->paperCode = "0xCC"; // eg COSC345
    this->paperName = "0xCC"; // Paper description
    this->roomCode = "0xCC"; // Eg STDAV1
    this->roomName = "0xCC"; // Full name of room
    this->building = "0xCC";
    this->type = "0xCC"; // Lecture, lab, tut, etc.
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
    std::string isoDate = this->date.ISODate();
    for (int i = 0; i < isoDate.length(); i++) {
        val += ((int) isoDate[i]);
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

Date TimetableEvent::getDate() { return this->date; }

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

void TimetableEvent::setDate(Date date) { this->date = date; }

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

void TimetableEvent::fixDate(int startingDate) {    
    Date date(startingDate);
    date.addDays(this->day - 1); // 1 on eVision is the first day.
    setDate(date.legacyDate()); 
}

/* Output a string representation of this event. Useable as CSV. */
std::string TimetableEvent::toString() { 
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
        "," + this->date.ISODate();
}

bool TimetableEvent::validateEventData(){
    // Checks tt events don't contain unexpected characters.
    assert (this->day < 7 && day > 0);
    assert (this->duration < 14 && duration > 0);

    std::regex hexrgx("#[\\da-fA-F]{6}");
    assert(regex_match(this->color, hexrgx));

    std::regex paperrgx("[[:upper:]]{4}\\d{3}");
    assert(std::regex_match(this->paperCode, paperrgx));

    std::regex upperAlphaNumRgx("[[:upper:][:digit:]]*");
    assert(std::regex_match(this->roomCode, upperAlphaNumRgx));

    std::regex alphanumrgx("[[:alnum:]]*");
    assert(std::regex_match(this->type, alphanumrgx));

    std::regex buildingrgx("[[:alnum:] '().]*");
    assert(std::regex_match(this->building, buildingrgx));
    assert(std::regex_match(this->roomName, buildingrgx));

    // TODO validate date


    // Ensure none of the string-based items have caught a funny char.
    const char *blarray[] = {"<",">","\"","\\n",";","/"};
    std::vector<std::string> blacklist(blarray, std::end(blarray));
    // TODO make this a soft fail - replace with blank string instead.
    // For time being, is useful for CI testing, because will crash app instaed of passing bad data.
    // TODO this should NOT be integrated into master!
    for (std::string blacklistedChar : blacklist) {
        std::string rgxString ="[^" + blacklistedChar + "]*";
        std::regex rgx(rgxString);
        assert(std::regex_match(this->color, rgx));
        assert(std::regex_match(this->mapLat, rgx));
        assert(std::regex_match(this->mapLong, rgx));
        assert(std::regex_match(this->paperCode, rgx));
        assert(std::regex_match(this->paperName, rgx));
        assert(std::regex_match(this->roomCode, rgx));
        assert(std::regex_match(this->roomName, rgx));
        assert(std::regex_match(this->building, rgx));
        assert(std::regex_match(this->mapUrl, rgx));
        assert(std::regex_match(this->type, rgx));
    }

    return true;
}

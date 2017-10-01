
#include "date.hpp"
#include <stdlib.h>
#include <iostream>
#include <ctime>

Date::Date() {
    time_t gmt = time(0);
    struct tm* now = localtime(&gmt);
    this->year = now->tm_year;
    this->month = now->tm_mon + 1; // not zero index
    this->day = now->tm_mday;
}

Date::Date(int d, int m, int y) {
    this->year = y - 1900;
    this->month - m;
    this->day = d;
}

Date::Date(int dateNum) { 
    this->year = (dateNum % 10000) - 1900;
    this->month = ((dateNum % 1000000 - year) / 10000);
    this->day = (dateNum % 100000000 - year - month) / 1000000;  
}

Date::Date(std::string date) { 
    dateFromString(date);
}

Date::Date(const char* date) {
    std::string d(date);
    dateFromString(d);
}

void Date::dateFromString(std::string date) { 
    if (date.length() > 8) {
        // Date from ISO date.
        this->year = stoi(date.substr(0, 4)) - 1900;
        this->month = stoi(date.substr(5, 2));
        this->day = stoi(date.substr(8, 2));
    } else {
        // Date from out legacy date.
        this->day = stoi(date.substr(0, 2));
        this->month = stoi(date.substr(2, 2));
        this->year = stoi(date.substr(4)) - 1900;        
    }
}

int Date::getYear() { return this->year; };

int Date::getMonth() { return this->month; };

int Date::getDay() { return this->day; };

int Date::compare(Date other) {
    if (this->year == other.getYear()) {
        if (this->month == other.getMonth()) {
            if (this->day == other.getDay()) {
                return 0;
            } else {
                return (this->day > other.getDay()) ? 1 : -1;
            }
        } else {
            return (this->month > other.getMonth()) ? 1 : -1;
        }
    } else {
        return (this->year > other.getYear()) ? 1 : -1;
    }
}

bool Date::isLeapYear() {
    if (this->year % 4 == 0) {
        if (this->year % 100 == 0) {
            if (this->year % 400 == 0) {
                return true;
            } else {
                return false;
            }
        } else {
            return true;   
        }
    }
    return false;
}

void Date::addDays(int days) {
    days = this->day + days;
    int mDays = daysInMonth();
    
    if (days > mDays) {
        month++;
        this->day = days - mDays;
    } else {
        this->day = days;
    }
}

int Date::daysInMonth() {
    switch(this->month) {
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
        case 2:
            if (isLeapYear()) {
                return 29;
            }
            return 28;
        default:
            return 31;
    }
}

tm Date::tmDate() {
    struct tm date; 

    date.tm_year = this->year;
    date.tm_mon = this->month - 1; // zero index
    date.tm_mday = this->day;

    return date;
}

std::string Date::format(const char* fmt) {

    struct tm date = tmDate();

    char out[200];
    size_t result = strftime(out, sizeof out, fmt, &date);
    return std::string(out, out + result);
}

std::string Date::ISODate() {
    return format("%F");
}

std::string Date::legacyDate() {
    return format("%d%m%Y");
}


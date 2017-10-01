
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
    return format("%d%m%y");
}


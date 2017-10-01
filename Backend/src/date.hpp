
#ifndef DATE_H_
#define DATE_H_

#include <ctime>
#include <string>

class Date {
    private:
        int year;
        int month;
        int day;
     
        int daysInMonth();

    public:
        Date();

        Date(int y, int m, int d);

        Date(int dateNum);
     
        bool isLeapYear();
        
        void addDays(int days);

        tm tmDate();

        std::string format(const char* format);
        
        std::string ISODate();

        std::string legacyDate();
};

#endif // DATE_H_

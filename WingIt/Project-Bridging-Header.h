//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "SWRevealViewController.h"
void parseTimetable(const char* data);
void parse();
const char* getEventsByDate(const char* dateString);
void initParser();
int numEvents(const char* dateString);

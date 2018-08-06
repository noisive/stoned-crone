//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "RMessage.h"
#import "OnePasswordExtension.h"


const char* B_parseEvents(const char* data);
void initTimetable();
void clearTimetable();
void validateTimetable();
int queryDate(const char* dateString);
const char* B_queryResult(int index);
const char* B_getFirstEventDate();

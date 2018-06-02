//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "SWRevealViewController.h"
#import "SVProgressHUD.h"
#import "RMessage.h"

const char* parseEvents(const char* data);
void initTimetable();
void validateTimetable();
int queryDate(const char* dateString);
const char* queryResult(int index);
const char* getFirstEventDate();

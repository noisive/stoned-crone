//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "SWRevealViewController.h"
#import "SVProgressHUD.h"

void parseEvents(const char* data);
void initTimetable();
int queryDate(const char* dateString);
const char* queryResult(int index);
const char* getFirstEventDate();


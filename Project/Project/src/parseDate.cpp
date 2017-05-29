#include <string>
#include <iostream>



int parseDate(std::string line){
    std::string target = "Now showing dates ";
    char targetEnd = ' ';
    int targetIndex = 0;
    int targLength = target.length();
    bool currentlyMatching = false;
    bool doExtract = false;
    std::string builder = "";
    int out;


    for(int letter = 0; letter < line.length(); letter++){
        
        if(doExtract){

            if (line[letter] == targetEnd){
                /* Converts the string's format of dd/mm/yyyy
                 * to 8 digit integer for return. */
                out = std::stoi(
                        builder.substr(0,2) + 
                        builder.substr(4,2) +
                        builder.substr(8,4));

                return out;
            }else{
                builder += line[letter];
            }
        }else{
            if(line[letter] == target[targetIndex]){
                currentlyMatching = true;
                targetIndex++;
                if(targetIndex == targLength ){
                    doExtract = true;
                    
                }
            }else{
                currentlyMatching = false;
                targetIndex = 0;
            }
        }
    }
    return -1;
}


int main(void){
    std::string line =  "if(typeof($) == \"function\") {  newtimetable();   }else{  sits_attach_event(window, \"load\", newtimetable);  }  function newtimetable() {    var options = {\"onEventHover\":function(e,ui){sitsjqtt_increase_event_size($(this)); if(typeof ui.extraData.extra.eirh==='string'&&ui.extraData.extra.eirh!=''){return true;}return false;},\"onEventEditClick\":function(e,ui){ttb_editDetails(ui.extraData.extra.eire, ui.extraData.extra.eirr, ui.extraData.extra.eirh);},\"height\":\"90%\",\"in_client\":\"inBrowser\",\"title\":\"Timetable for  (Now showing dates 22\\/05\\/2017 to 28\\/05\\/2017)\",\"start_day\":1,\"no_days\":7,\"start_time\":8,\"no_hours\":14,\"view\":\"DAY_BY_TIME\",\"snap_mins\":30,\"view_toggle\":\"Y\",\"show_time\":\"N\",\"dim_on_select\":false,\"more_info\":\"<B>More<\\/B>\"};    var eventdata = [{\"id\":\"YTTB1\",\"day\":1,\"start\":\"10:00\",\"end\":\"11:00\",\"draggable\":false,\"resizable\":false,\"selected\":false,\"bcol\":\"lig";

    std::cout << parseDate("Timetable for  (Now showing dates 22\\/05\\/2017 to 28\\/05\\/2017)\"") << std::endl;
    return 0;
    char targetEnd = ' ';
}

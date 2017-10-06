# WingIt
[![Build Status](https://travis-ci.org/noisive/stoned-crone.svg?branch=master)](https://travis-ci.org/noisive/stoned-crone)
## README


##### **WingIt** is an app for keeping track of your University of Otago timetable

For more background information, see our [first assignment](ProjectInfo.md)

### So what does WingIt do?
WingIt is a iOS tool for managing University of Otago classes. It uses a webview in the app to log you in to eVision, injects JavaScript to navigate pages, then more JavaScript trickery to pull your timetable out of the webview.

Once it has retrieved your timetable from eVision, it's thrown at a Parser which unjumbles the mess of JavaScript, HTML, & JSON which eVision has kindly messed up in order to display your timetable as easy as possible (albeit with some bad practice thrown in). This Parser also handles saving your sorted time table to your phones internal storage; it's written in C++.


### Installation

Release versions are [available through the App Store](https://itunes.apple.com/nz/app/wingit-evision-timetable/id1292454564)  
The latest version of the app can be manually built and installed on an iOS device through **Xcode 9**.  
Clone this repository, open [WingIt.xcoworkspace](stoned-crone/WingIt.xcworkspace) and build.  

### Usage
If your timetable is not loaded into the app, such as when it is being used for the first time, the app will prompt you to log into your eVision so that it can load and parse your timetable. WingIt is now ready for use.

#### Updating timetable
If your timetable for the week has changed compared to the currently loaded week, you should manually update it. To do this, log in via the left sidebar menu to refresh the data for the current week (Monday to Sunday).

Connectivity issues can occasionally mean the app hangs during this process. Clicking cancel and retrying will rectify this.

### Internal working documention

The data acquisition process is the most important and most likely to break part of the app. The login occurs first in the [UI](stoned-crone/WingIt/LoginViewController.swift) by loading a hidden browser page, obtaining user credentials, and using javascript injection to navigate to the timetable page. The HTML is then scraped for a mangled json object, the text of which is passed to the custom Parser in C++.

The parser, in [parser.cpp](stoned-crone/Backend/src/parser.cpp), is the part that will need updating as eVision changes its interface and the html/javascript tags that bookend the relevant data get shuffled. It has been modularised to make this easier to do while referencing an html timetable example.

The test case comparison timetables will have to be replaced should such an eVision change occur. Sourcing varied course samples is the challenge.

Once the data is extracted into structs for each [timetable event](stoned-crone/Backend/src/timetableEvent.cpp), which are loaded into a representation of the week’s timetable, it is written into a csv database, for persistent storage.

Each time the app starts up, [swift calls](stoned-crone/blob/master/WingIt/AppDelegate.swift#L47) initiate the C++ CSV loader, which restores the offline data to an accessible form.  
Swift then recreates its representation of the timetables by calling accessor methods on the data. It then loads and presents this to the user.

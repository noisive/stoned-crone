# WingIt
## README
For more background information, see our [first assignment](ProjectInfo.md)

### Requirements
The build process requires **CocoaPods** dependency manager.  
CocoaPods can be installed as super user with ```$ sudo gem install cocoapods```.  
Lacking elevated permissions you can install with ```gem install cocoapods --user-install```.  
Once installed, navigate to the repository root (stoned-ctone), then the first Project sub directory and in terminal run ```pod install```

### Installation
1. Clone the git repository from https://github.com/noisive/stoned-crone.git or the project homepage.
2. Navigate to the Project/src folder using terminal and run ```make```.
3. Open the project file stoned-crone/Project/Project.xcodeproj/ in Xcode.
4. Build the project and run it through the Simulator\*, or on a connected iOS device if available.  
\*Known to work with iPhone 7 simulator

### So what does WingIt do?
WingIt is a iOS tool for managing University of Otago classes. It uses a webview in the app to log you in to eVision, injects JavaScript to navigate pages, then more JavaScript trickery to pull your timetable out of the webview.

Once it has retrieved your timetable from eVision, it's thrown at a Parser which unjumbles the mess of JavaScript, HTML, & JSON which eVision has kindly messed up in order to display your timetable as easy as possible (albeit with some bad practice thrown in). This Parser also handles saving your sorted time table to your phones internal storage; it's written in C++.

### Operation
1. Tap the Pancake Menu icon on the left hand side of the screen.
2. Tap 'update', enter your eVision login details and wait as the program parses your calendar.
3. Use the application to keep track of this week's engagements.

### COSC345
# Timetable App Project Codename: stoned-crone
## Assignment One

Alex Gregory | Nadja Jury | Will Shaw | William Warren

[github](github.com/noisive/stoned-crone)

# What and why?
Many students find it relatively difficult to memorise their University timetable as it varies from semester to semester and sometimes from week to week. With the proliferation of double degrees and minors, students often find themselves taking a variety of papers and aren’t part of a habit forming cohort. They are unable to rely on a single group to know where to go next. What a dilemma. Parallel to this, accessing one’s timetable through the University’s eVision system is cumbersome, time consuming and delivers a poor user experience on a mobile device. To add insult to injury, there is no feature that allows students to receive notifications for upcoming classes, tests or tutorials, or to export these engagements to a calendar app.

Intuitively, we knew we’d use an app that solves these problems every week, if not every day - however, we wanted to understand exactly what attributes or functionalities were important to make this app appealing to students at large.
To better understand the approaches that students use to manage their class timetables, we spoke to a number of them and compiled some common approaches and their relative drawbacks.

## Analysis of current options
**eVision**
- Poor UX on mobile devices
- Requires Navigation to login page, entering username and password, scrolling, panning and clicking See More to load calendar
- No facility for notifications or export to calendar
**Mobile screenshot of eVision timetable**
- Static - does not capture changes to class times or locations or fortnightly tutorials etc.
- Image is eventually submerged on user’s ‘camera roll’
- No facility for notifications or export to calendar
**Manual entry into calendar application**
- Very time consuming relative to other options - large burden on user at beginning of each semester
- Allows notifications
- Requires accuracy and understanding of class behaviours e.g. no lab in first week, fortnightly tutorial etc.
- Static - does not capture any changes in the timetable
**Diary**
- Involves transcribing timetable into diary
- Unresponsive to changes in venue, fortnightly tutorials etc. unless you transcribe week by week
- Time consuming
- No notifications
- Most students already carry their phone - carrying a diary generally means another item to lose, forget or weigh you down

## So what are we going to build?
An iOS app that assists students to manage their day at University. To offer an improvement on the above tools it have the ability to:
- Pull timetable data from eVision with minimal user effort
- Rapidly display the calendar to the user in an intuitive way
- Notify the user of upcoming classes

# Who and how?
## Our people

Our group brings a diverse set of skills to this project. We have discussed our existing strengths and weaknesses, as well as the skills we would like to develop through our work on the project. We have assigned people to lead various tasks but plan to work together where it is efficient to do so.

Alex Gregory - Report Lead

_Alex will draft reports in consultation with the group and bring them together for review. He has some limited experience doing interface design in xcode which he will use to assist this aspect of the project._

Nadja Jury - Code Review Lead

_Nadja will review code as it is pushed to GitHub to ensure it ‘does what is says it does’ as well as for style and readability. Nadja will work closely with William to ensure that code entering review phase is being meaningfully tested, as well as with Will to ensure we are hitting appropriate functionality milestones._

Will Shaw - Development Lead

_Will is leading the development effort for this project which will include collaborating on specifications and delegating the development of aspects of the program to other members of the group as required._

William Warren - Test Lead

_William is leading our testing effort. With a particular interest in this area, he will try to break our program and communicate issues back to the group as he finds them so that they can be fixed._

## How are we going to build this application
_We’ve designed four high level components and identified tasks which are needed to assemble these._
### High Level Architecture Plan
[Image](https://github.com/noisive/stoned-crone/raw/master/img/Architecture.png)
```
# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/noisive/stoned-crone/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://help.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.

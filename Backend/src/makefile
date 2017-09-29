parsertest.out : libParse.a parsertest.cpp
	g++ -std=c++11 -g parsertest.cpp -L. -lm -lParse -o parsertest.out

libParse.a : parser.o timetableEvent.o timetable.o 
	ar r libParse.a parser.o timetable.o timetableEvent.o 

timetable.o : timetable.cpp
	g++ -std=c++11 -g -c timetable.cpp

timetableEvent.o : timetableEvent.cpp 
	g++ -std=c++11 -g -c timetableEvent.cpp 

parser.o : parser.cpp 
	g++ -std=c++11 -g -c parser.cpp

clean :
	rm *.o* *.a

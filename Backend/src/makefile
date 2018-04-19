parsertest.out : libParse.a parsertest.cpp createcsvs.out
	g++ -std=c++11 -g parsertest.cpp -L. -lm -lParse -o parsertest.out

createcsvs.out : libParse.a createcsvs.cpp
	g++ -std=c++11 -g createcsvs.cpp -L. -lm -lParse -o createcsvs.out

libParse.a : parser.o timetableEvent.o timetable.o date.o
	ar r libParse.a parser.o timetable.o timetableEvent.o date.o

timetable.o : timetable.cpp
	g++ -std=c++11 -g -c timetable.cpp

timetableEvent.o : timetableEvent.cpp 
	g++ -std=c++11 -g -c timetableEvent.cpp 

date.o : date.cpp
	g++ -std=c++11 -g -c date.cpp

parser.o : parser.cpp 
	g++ -std=c++11 -g -c parser.cpp

clean :
	rm -rf *.dSYM
	rm *.o* *.a

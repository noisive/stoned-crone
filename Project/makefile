parsertest.out : libParse.a src/parsertest.cpp
	clang++ -std=c++11 -O2 src/parsertest.cpp -Lsrc -lm -lParse -o bin/parsertest.out

libParse.a : parser.o timetableEvent.o timetable.o 
	ar r src/libParse.a bin/parser.o bin/timetable.o bin/timetableEvent.o 

timetable.o :  src/timetable.cpp
	clang++ -std=c++11 -O2 -c  src/timetable.cpp -o bin/timetable.o

timetableEvent.o :  src/timetableEvent.cpp 
	clang++ -std=c++11 -O2 -c  src/timetableEvent.cpp -o bin/timetableEvent.o

parser.o :  src/parser.cpp 
	clang++ -std=c++11 -O2 -c  src/parser.cpp -o bin/parser.o

clean :
	rm bin/*.o* src/*.o* src/*.a

optimisationLevel = -g # -O2
buildDir = ../build/
binDir = ../bin/
objectNames = parser.o timetableEvent.o timetable.o date.o
objects = $(addprefix $(buildDir),$(objectNames))
libArgs = -L$(buildDir) -lm -lParse

# $@ expands to the name of the rule.
$(binDir)parsertest.out : $(buildDir)libParse.a parsertest.cpp $(binDir)createcsvs.out
	g++ -std=c++11 $(optimisationLevel) parsertest.cpp $(libArgs)

$(binDir)createcsvs.out : $(buildDir)libParse.a createcsvs.cpp
	g++ -std=c++11 $(optimisationLevel) createcsvs.cpp $(libArgs)

$(buildDir)libParse.a : $(objectNames)
	ar r $@ $(objects)

$(buildDir)timetable.o : timetable.cpp
	g++ -std=c++11 $(optimisationLevel) -c timetable.cpp

$(buildDir)timetableEvent.o : timetableEvent.cpp
	g++ -std=c++11 $(optimisationLevel) -c timetableEvent.cpp

$(buildDir)date.o : date.cpp
	g++ -std=c++11 $(optimisationLevel) -c date.cpp

$(buildDir)parser.o : parser.cpp
	g++ -std=c++11 $(optimisationLevel) -c parser.cpp

clean :
	# rm -rf *.dSYM
	# rm *.o* *.a
	rm -rf ../build/*
	rm -rf ../bin/*

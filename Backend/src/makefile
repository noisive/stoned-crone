optimisationLevel = -g # -O2
gpp= g++ -c -std=c++11 $(optimisationLevel)
gppBuild= $(gpp) -o $(buildDir)/$@
gppBin= $(gpp) -o $(binDir)/$@
buildDir = ../build
binDir = ../bin
objectNames = parser.o timetableEvent.o timetable.o date.o
objects = $(addprefix $(buildDir)/,$(objectNames))
libArgs = -L$(buildDir) -lm -lParse

# $@ expands to the name of the rule.
parsertest.out : libParse.a parsertest.cpp createcsvs.out
	$(gppBin) parsertest.cpp $(libArgs)

createcsvs.out : libParse.a createcsvs.cpp
	$(gppBin) createcsvs.cpp $(libArgs)

libParse.a : $(objectNames)
	ar r $(buildDir)/$@ $(objects)

timetable.o : timetable.cpp
	$(gppBuild) timetable.cpp

timetableEvent.o : timetableEvent.cpp
	$(gppBuild) timetableEvent.cpp

date.o : date.cpp
	$(gppBuild) date.cpp

parser.o : parser.cpp
	$(gppBuild) parser.cpp

clean :
	# rm -rf *.dSYM
	# rm *.o* *.a
	rm -rf ../build/*
	rm -rf ../bin/*

optimisationLevel = -g # -O2

srcs = parser.cpp timetableEvent.cpp timetable.cpp date.cpp
objectNames = $(subst .cpp,.o,$(srcs))

buildDir = ../build
binDir = ../bin
# VPATH = src
COMPILE.cpp = $(gpp)
CXXFLAGS = -std=c++11 $(optimisationLevel)
# CFLAGS = -c $(optimisationLevel)
CXX = g++
LDLIBS = -L$(buildDir) -lParse

# % is a wildcard, $< expands to first depedency ($^ is all dependencies)
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $(buildDir)/$@ $<
%.out: %.cpp libParse.a
	$(CXX) $(CXXFLAGS) -o $(binDir)/$@ $< -lm $(LDLIBS)

gpp= g++ $(CXXFLAGS)
# $@ expands to the name of the rule.
# gppBuild= $(gpp) -c -o $(buildDir)/$@
# gppBin= $(gpp) -o $(binDir)/$@
objects = $(addprefix $(buildDir)/,$(objectNames))
libArgs = $(LDLIBS)

all: parsertest.out createcsvs.out

libParse.a : $(objectNames)
	ar rcs $(buildDir)/$@ $(objects)

# parsertest.out : parsertest.cpp libParse.a
# 	$(gppBin) $< -lm $(libArgs)
#
# createcsvs.out : createcsvs.cpp libParse.a
# 	$(gppBin) $< -lm $(libArgs)

# timetable.o : timetable.cpp
# 	$(gppBuild) timetable.cpp

# timetableEvent.o : timetableEvent.cpp
# 	$(gppBuild) timetableEvent.cpp
#
# date.o : date.cpp
# 	$(gppBuild) date.cpp
#
# parser.o : parser.cpp
# 	$(gppBuild) parser.cpp

clean :
	# rm -rf *.dSYM
	# rm *.o* *.a
	rm -rf ../build/*
	rm -rf ../bin/*

# For debugging. `make print-VAR` prints the value of var.
print-%: ; @echo $* is $($*)

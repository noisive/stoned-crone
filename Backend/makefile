# ---- BUILT-IN VARS ----
#  Overwriting default variables.
# CFLAGS = -c $(optimisationLevel)
VPATH = src
CXXFLAGS = -std=c++11 $(optimisationLevel)
CXX = g++
LDLIBS = -Lbuild -lParse
# -----------------------

optimisationLevel = -g # -O2

# Source files for binaries
bins = parsertest.cpp createcsvs.cpp
# srcs are only the ones required for the library.
srcs = parser.cpp timetableEvent.cpp timetable.cpp date.cpp
# Replace .cpp with .o
objectNames = $(subst .cpp,.o,$(srcs))
objects = $(addprefix obj/,$(objectNames))

outs = $(subst .cpp,.out,$(bins))
binOuts = $(addprefix bin/,$(outs))

all: init $(binOuts)

# % is a wildcard.
# $< expands to first depedency ($^ is all dependencies).
# $@ expands to the name of the rule.
obj/%.o: %.cpp %.hpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<
bin/%.out: %.cpp build/libParse.a
	$(CXX) $(CXXFLAGS) -o $@ $< -lm $(LDLIBS)

build/libParse.a : $(objects)
	ar rcs $@ $(objects)

init:
	mkdir -p build bin obj

clean :
	rm -rf build/*
	rm -rf bin/*
	rm -rf obj/*

# For debugging. `make print-VAR` prints the value of var.
print-%: ; @echo $* is $($*)

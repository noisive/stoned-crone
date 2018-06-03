# ---- BUILT-IN VARS ----
#  Overwriting default variables.
# CFLAGS = -c $(optimisationLevel)
VPATH = $(mkfile_dir)/src
CXXFLAGS = -std=c++11 $(optimisationLevel)
CXX = g++
LDLIBS = -L$(mkfile_dir)/build -lParse
# -----------------------

current_dir := $(PWD)
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
# mkfile_path = /bin/bash/trees/time.txt
mkfile_dir = $(abspath $(dir $(mkfile_path)))
optimisationLevel = -g # -O2

# Source files for binaries
bins = createcsvs.cpp
# srcs are only the ones required for the library.
srcs = parser.cpp timetableEvent.cpp timetable.cpp date.cpp
# Replace .cpp with .o
objectNames = $(subst .cpp,.o,$(srcs))
objects = $(addprefix $(mkfile_dir)/obj/,$(objectNames))

outs = $(subst .cpp,.out,$(bins))
binOuts = $(addprefix $(mkfile_dir)/bin/,$(outs))

all: init $(binOuts)

test: all
	$(mkfile_dir)/parserTests/runtest.sh

# % is a wildcard.
# $< expands to first depedency ($^ is all dependencies).
# $@ expands to the name of the rule.
$(mkfile_dir)/obj/%.o: %.cpp %.hpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<
$(mkfile_dir)/bin/%.out: %.cpp $(mkfile_dir)/build/libParse.a
# $(mkfile_dir)/bin/%.out: %.cpp build/libParse.a
	$(CXX) $(CXXFLAGS) -o $@ $< -lm $(LDLIBS)

$(mkfile_dir)/build/libParse.a : $(objects)
	ar rcs $@ $(objects)

init:
	mkdir -p $(mkfile_dir)/build $(mkfile_dir)/bin $(mkfile_dir)/obj

clean :
	rm -rf $(mkfile_dir)/build/*
	rm -rf $(mkfile_dir)/bin/*
	rm -rf $(mkfile_dir)/obj/*

# For debugging. `make print-VAR` prints the value of var.
print-%: ; @echo $* is $($*)

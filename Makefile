UNAME_S = $(shell uname -s)

CC = g++
CFLAGS = -std=c++20 -O3 -g -Wall -Wextra -Wpedantic -Wstrict-aliasing
CFLAGS += -Wno-pointer-arith -Wno-newline-eof -Wno-unused-parameter -Wno-gnu-statement-expression
CFLAGS += -Wno-gnu-compound-literal-initializer -Wno-gnu-zero-variadic-macro-arguments
CFLAGS += -Ilib/glad/include -Ilib/glfw/include -fbracket-depth=1024
LDFLAGS = lib/glad/src/glad.o lib/glfw/src/libglfw3.a -lm

# GLFW required frameworks on OSX
ifeq ($(UNAME_S), Darwin)
	LDFLAGS += -framework OpenGL -framework IOKit -framework CoreVideo -framework Cocoa
endif

ifeq ($(UNAME_S), Linux)
	LDFLAGS += -ldl -lpthread
endif

SRC  = $(wildcard src/**/*.cpp) $(wildcard src/*.cpp) $(wildcard src/**/**/*.cpp) $(wildcard src/**/**/**/*.cpp)
OBJ  = $(SRC:.cpp=.o)
BIN = bin

.PHONY: all clean

all: dirs libs game

libs:
	cd lib/glfw && cmake . && make
	cd lib/glad && gcc -o src/glad.o -Iinclude -c src/glad.c

dirs:
	mkdir -p ./$(BIN)

run: all
	$(BIN)/game

game: $(OBJ)
	$(CC) -o $(BIN)/game $^ $(LDFLAGS)

%.o: %.cpp
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	rm -rf $(BIN) $(OBJ)

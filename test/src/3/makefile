CC := g++ -std=c++11

ifneq ($(debug), )
CC += -g
endif

test:test.cpp
	$(CC) test.cpp -o test
	
all:
	
clean:
	rm test
	
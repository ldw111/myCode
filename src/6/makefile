CC := g++
CFLAGS = -std=c++11 -g -lpthread
OBJS = server
SRCS = server.cpp

all:$(OBJS)
all:client
$(OBJS):$(SRCS)
	$(CC) -o $@ $^ $(CFLAGS)
client:client.cpp
	$(CC) -o client client.cpp $(CFLAGS)
	
.PHONY:clean
clean:
	rm $(OBJS) client
	

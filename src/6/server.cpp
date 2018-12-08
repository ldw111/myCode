#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <linux/un.h>
#include <pthread.h>
#include <stddef.h>

using namespace std;

#define IPPROBE_STR "./ipport.str"

void *read_fun(void *arg);
void *write_fun(void *arg);

int main(int argc,char *argv[])
{
	int sockfd = socket(AF_LOCAL, SOCK_STREAM, 0);
	if(sockfd < 0)
	{
		cout << __LINE__<< endl;
		return -1;
	}
	struct sockaddr_un serv_addr, cli_addr;
	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sun_family = AF_LOCAL;
	strcpy(serv_addr.sun_path, IPPROBE_STR);
	unlink(serv_addr.sun_path);
	int len = offsetof(struct sockaddr_un, sun_path) + strlen(IPPROBE_STR);
    if (bind(sockfd, (struct sockaddr *)&serv_addr, len) < 0)
	{
		cout << __LINE__<< endl;
		return -1;
	}
	
	if (listen(sockfd, 10) < 0)
	{
		cout << __LINE__<< endl;
		return -1;
	}
    int conn_fd;
	socklen_t cli_len = sizeof(cli_addr);
	while(1)
	{
		if ((conn_fd = accept(sockfd, (struct sockaddr *)&cli_addr, &cli_len)) < 0 )
		{
			cout << __LINE__<< endl;
			return -1;
		}
		pthread_t tid;
		pthread_create(&tid, nullptr, read_fun, (void *)(&conn_fd));
		pthread_t tid1;
		pthread_create(&tid1, nullptr, write_fun, (void *)(&conn_fd));
	}
	
    return 0;
}

void *read_fun(void *arg)
{
	char buf[1024];
	int conn_fd = *(int *)arg;
	while(1)
	{
		bzero(buf, sizeof(buf));
		int ret = read(conn_fd, buf, sizeof(buf));
		if(ret > 0)
		{
			cout << buf;
		}
	}
}

void *write_fun(void *arg)
{
	char buf[1024];
	char msg[1024];
	int conn_fd = *(int *)arg;
	while(1)
	{
		bzero(msg, sizeof(msg));
		bzero(buf, sizeof(buf));
		strcpy(msg, "server:");
		fgets(buf, sizeof(buf), stdin);
		strcat(msg, buf);
		int ret = write(conn_fd, msg, sizeof(msg));
	}
}
#include <iostream>
#include <cstring>
#include <list>
#include <iterator>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/ipc.h>
#include <sys/shm.h>

using namespace std;

#define SIZE 1024

//template<typename T>
//void create_fork(void fun(T),T arg);
template<typename T>
void fun(T shmaddr);
//char *shared_memory();
//void wait_fork();

template<typename T>
class My_Fork
{
public:
	My_Fork() { cnt = 0; }
	void create_fork(void fun(T),T arg);
	void wait_fork();
	char *shared_memory();
private:
	int cnt;
};

struct stu_info
{
	int id;
	char name[20];
};
	
int main(int argc,char *argv[])
{
	My_Fork<char *> *m = new My_Fork<char *>;
	char *shmaddr = m->shared_memory();
	m->create_fork(fun, shmaddr);
	cout << "p:" << endl;
	//char *shmaddr = shared_memory();
	stu_info *s = new stu_info;
	memcpy(s, shmaddr, sizeof(*s));
	cout << s->id << " " << s->name << endl;
	m->wait_fork();
	
    return 0;
}

template<typename T>
void My_Fork<T>::wait_fork()
{
	for(int i = 0; i < cnt; i++)
	{
		wait(NULL);
		cout << i << " ";
	}
	cout << endl;
}
template<typename T>
void My_Fork<T>::create_fork(void fun(T),T arg)
{
	pid_t pid = fork();
	if(pid == 0)
	{
		cout << "c:" << endl;
		fun(arg);
		exit(0);
	}
	cnt++;
	//waitpid(pid, nullptr, 0);
}

template<typename T>
void fun(T shmaddr)
{
	stu_info *s = new stu_info;
	s->id = 1;
	strcpy(s->name, "lll");
	memcpy(shmaddr, s, sizeof(*s));
	shmdt(shmaddr);
}

template<typename T>
char *My_Fork<T>::shared_memory()
{
	key_t key = ftok(".",'a');
	int shmid = shmget(key, SIZE, IPC_CREAT|0664);
	char *shmaddr = (char *)shmat(shmid, nullptr, 0);
	return shmaddr;
}
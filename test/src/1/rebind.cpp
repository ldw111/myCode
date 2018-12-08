#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <assert.h>

using namespace std;

int main(int argc,char *argv[])
{
	
	return 0;
}








#if 0
//引用解绑
{
	long a = 3;
	long b = 5;
	long &r = a;
	long *addr = &b;
	addr++;
	*addr += (long)&b - (long)&a;
	r = 10;
	cout << a << " " << b << endl;
	return 0;
}
#endif
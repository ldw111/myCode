#include <iostream>
#include <cstdio>
#include <cstring>

using namespace std;

int main(int argc,char *argv[])
{
	auto fp = popen("ls", "r");
	char buf[256];
	memset(buf, 0, sizeof(buf));
	fread(buf, sizeof(char), sizeof(buf), fp);
	cout << buf;
    return 0;
}

#include <iostream>
#include <vector>

using namespace std;

//template<typename T>
vector<int> iVector;

int main(int argc,char *argv[])
{
	for(auto i = 0;i < 10;i++)
		iVector.push_back(i);
	for(auto p:iVector)
	{
		cout << p << " ";
	}
	cout << endl;
	auto a = 1;
	auto b = "hello world";
	decltype(b) c = b;
	cout << a << " " << b << " " << c << endl;
    return 0;
}


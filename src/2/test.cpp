#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <iterator>
#include <algorithm>
#include <vector>
#include <list>

using namespace std;

int iarray[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
vector<int> inVector(iarray, iarray+10);
list<int> iList;

template<typename T>
void Display(T& v,const char *s);
int sum(int a, int b)
{
	return a - b;
}
int fun(int a)
{
	//cout << a << endl;
}

int main(int argc,char *argv[])
{
	int k = count_if(inVector.begin(), inVector.end(), bind1st(greater<int>(), 8));
	cout << k << endl;  // << 8
	//fun(bind1st(ptr_fun(sum), 5)(3));
	/*
	copy(iarray, iarray + 10, back_inserter(iList));
	list<int>::iterator p = find(iList.begin(), iList.end(), 2);
	cout << "Before p = " << *p << endl;
	advance(p, 2);
	cout << "After p = " << *p << endl;
	int k = distance(p, iList.end());
	cout << "k = " << k << endl;
	/*
    srandom(time(nullptr));
	vector<int>::iterator intIter = inVector.begin();
	for(int i=0;i < 10;i++)
	{
		*intIter = (int)(10000.0*random()/(RAND_MAX+1.0));
		intIter++;
		//inVector.push_back((int)(10000.0*random()/(RAND_MAX+1.0)));
	}
	copy(inVector.begin(), inVector.end(), front_inserter(iList));
	Display(iList,"Before find and copy");
	/*
	Display(inVector, "Before sorting");
	sort(inVector.begin(), inVector.end());
	Display(inVector, "After sorting");
    /*
    inVector[20] = 50;
    vector<int>::iterator intIter = find(inVector.begin(), inVector.end(), 50);
    if(intIter != inVector.end())
        cout << "vector contains value " << *intIter << endl;
    else
        cout << "vector does not contains 50" << endl;
    vector<int>::iterator first = inVector.begin();
    *first = 123;
    cout << inVector[0] << endl;
    */
    return 0;
}

template<typename T>
void Display(T& v,const char *s)
{
	cout << endl << s << endl;
	copy(v.begin(), v.end(), ostream_iterator<int>(cout, "\t"));
	cout << endl;
}

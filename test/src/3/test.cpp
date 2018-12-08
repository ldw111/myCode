#include <iostream>
#include <memory>

using namespace std;

class Child;
class Parent;

class Parent {
private:
    //std::shared_ptr<Child> ChildPtr;
    std::weak_ptr<Child> ChildPtr;
public:
    void setChild(std::shared_ptr<Child> child) {
        this->ChildPtr = child;
    }

    void doSomething() {
        //new shared_ptr
        if (this->ChildPtr.lock()) {

        }
    }

    ~Parent() {
    }
};

class Child {
private:
    std::shared_ptr<Parent> ParentPtr;
public:
    void setPartent(std::shared_ptr<Parent> parent) {
        this->ParentPtr = parent;
    }
    void doSomething() {
        if (this->ParentPtr.use_count()) {

        }
    }
    ~Child() {
    }
};

int main(int argc,char *argv[])
{
	std::weak_ptr<Parent> wpp;
    std::weak_ptr<Child> wpc;
    {
        std::shared_ptr<Parent> p(new Parent);
        std::shared_ptr<Child> c(new Child);
        p->setChild(c);
        c->setPartent(p);
        wpp = p;
        wpc = c;
        std::cout << p.use_count() << std::endl; // 2
        std::cout << c.use_count() << std::endl; // 1
    }
    std::cout << wpp.use_count() << std::endl;  // 0
    std::cout << wpc.use_count() << std::endl;  // 0
/*
	Parent* p = new Parent;
	Child* c =  new Child;
	p->setChild(c);
	c->setPartent(p);
	delete c;  //only delete one
/*
	std::shared_ptr<int> sh_ptr = std::make_shared<int>(10);
	std::cout << sh_ptr.use_count() << std::endl;
	cout << *sh_ptr << endl;

	std::weak_ptr<int> wp(sh_ptr);
	std::cout << wp.use_count() << std::endl;

	if(!wp.expired()){
		std::shared_ptr<int> sh_ptr2 = wp.lock(); //get another shared_ptr
		*sh_ptr = 100;
		std::cout << wp.use_count() << std::endl;
		cout << *sh_ptr << endl;
		cout << *sh_ptr2 << endl;
	}
    //delete memory
	/*
	int a = 10;
	shared_ptr<int> ptra = make_shared<int>(a);
	shared_ptr<int> ptra2(ptra);
	cout << ptra.use_count() << endl;
	
	int b = 20;
	int *pb = &a;
	//std::shared_ptr<int> ptrb = pb;  //error
	shared_ptr<int> ptrb = make_shared<int>(b);
	ptra2 = ptrb; //assign
	pb = ptrb.get(); //获取原始指针

	cout << ptra.use_count() << endl;
	cout << ptrb.use_count() << endl;
	*/
    return 0;
}



#include<iostream>
#include<fstream>

using namespace std;

int main()
{
	streampos size;
	char * mpa;

	ifstream mpa_0("dtc.1.prn", ios::in| ios::binary | ios::ate);
	ofstream out("out.txt");

	//if (mpa_0.is_open())
	//{
		size = mpa_0.tellg();
		mpa = new char[size];

		mpa_0.seekg(0, ios::beg);
		mpa_0.read(mpa, size);

		out.write(mpa, size);

		//mpa_0.close();
	//}

	return 0;
}
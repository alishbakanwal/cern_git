
#include<iostream>
#include<fstream>

using namespace std;

int main()
{
	streampos size;
	char * mpa_4;

	int header;

	header = 113;

	ifstream file_mpa_4("dtc.4.prn", ios::in | ios::binary | ios::ate);
	ofstream out("out.txt");

	if (file_mpa_4.is_open())
	{
		size = file_mpa_4.tellg();
		mpa_4 = new char[size];

		file_mpa_4.seekg(header, ios::beg);
		file_mpa_4.read(mpa_4, size);

		out.write(mpa_4, size);

		file_mpa_4.close();

		/*
		size = file_mpa_0.tellg();
		mpa_0 = new char[size];

		file_mpa_0.seekg(header, ios::beg);
		file_mpa_0.read(mpa_0, size);

		out.write(mpa_0, size);

		file_mpa_0.close();
		*/
	}

	ifstream procfile("out.txt", ios::app | ios::ate | ios::binary);
	ofstream shit("shit.txt");

	int addra_pos;
	int jump; // # of bits between consecutive values
	int size_addra;

	int douta_0m_pos;
	int size_douta;

	char * addra; // variable in which value from file is to be stored
	char * douta_0m;
	char * dout_0m_prev;

	jump = 66; // to find: characters - lines

	if (procfile.is_open())
	{
		addra_pos = 7;
		size_addra = 2;

		douta_0m_pos = 10;
		size_douta = 5;

		addra = new char[size_addra];
		douta_0m = new char[size_douta];

		for (int i = 0; i < 2; i++)

		{
			procfile.seekg(addra_pos + i*jump, ios::beg);
			procfile.read(addra, size_addra);

			procfile.seekg(douta_0m_pos + i*jump, ios::beg);
			procfile.read(douta_0m, size_douta);

			shit.write(addra, size_addra);
			shit.write(douta_0m, size_douta);
			shit << "\n";
		}
			procfile.close();
	}

	return 0;
}
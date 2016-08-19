
#include<iostream>
#include<fstream>

using namespace std;

int main()
{
	streampos size;
	char * mpa_4_f;
	char * mpa_5_f;
	char * mpa_6_f;
	char * mpa_7_f;
	char * mpa_8_f;
	char * mpa_9_f;
	char * mpa_10_f;
	char * mpa_11_f;

	int header;

	header = 113;


	//
	//
	//----- dtc.1.prn
	//
	//
	//

	ifstream file_mpa_0("dtc.1.prn", ios::in | ios::binary | ios::ate);
	ofstream out("out.txt");

	if (file_mpa_0.is_open())
	{
		size = file_mpa_0.tellg();
		mpa_4_f = new char[size];

		file_mpa_0.seekg(header, ios::beg);
		file_mpa_0.read(mpa_4_f, size);

		out.write(mpa_4_f, size);

		file_mpa_0.close();

		/*
		size = file_mpa_0.tellg();
		mpa_0 = new char[size];

		file_mpa_0.seekg(header, ios::beg);
		file_mpa_0.read(mpa_0, size);

		out.write(mpa_0, size);

		file_mpa_0.close();
		*/
	}

	ifstream proc_0("out.txt", ios::in | ios::ate | ios::binary);

	ofstream mpa_0m_file("mpa_0.txt");
	ofstream mpa_1m_file("mpa_1.txt");
	ofstream mpa_2m_file("mpa_2.txt");
	ofstream mpa_3m_file("mpa_3.txt");
	ofstream mpa_4m_file("mpa_4.txt");
	ofstream mpa_5m_file("mpa_5.txt");
	ofstream mpa_6m_file("mpa_6.txt");
	ofstream mpa_7m_file("mpa_7.txt");

	int addra_pos; //  starting point of addra's
	int jump; // # of bits between consecutive values
	int size_addra;

	// starting points of all douta_xm's
	int douta_0m_pos;
	int douta_1m_pos;
	int douta_2m_pos;
	int douta_3m_pos;
	int douta_4m_pos;
	int douta_5m_pos;
	int douta_6m_pos;
	int douta_7m_pos;

	int size_douta;

	char * addra; // variable in which value from file is to be stored
	char * douta_0m;
	char * douta_1m;
	char * douta_2m;
	char * douta_3m;
	char * douta_4m;
	char * douta_5m;
	char * douta_6m;
	char * douta_7m;

	char * dout_0m_prev;

	if (proc_0.is_open())
	{
		addra_pos = 7;
		size_addra = 2;

		size_douta = 6;

		addra = new char[size_addra];
		douta_0m = new char[size_douta];
		douta_1m = new char[size_douta];
		douta_2m = new char[size_douta];
		douta_3m = new char[size_douta];
		douta_4m = new char[size_douta];
		douta_5m = new char[size_douta];
		douta_6m = new char[size_douta];
		douta_7m = new char[size_douta];


		//
		// segment 0-9, 10-99, 100-1024
		//
		
		int i;

		// for 0-9

		for (i = 0; i < 10; i++)
		{
			jump = 66;
			douta_0m_pos = 10;
			douta_1m_pos = 17;
			douta_2m_pos = 24;
			douta_3m_pos = 31;
			douta_4m_pos = 38;
			douta_5m_pos = 45;
			douta_6m_pos = 52;
			douta_7m_pos = 59;

			// mpa_0
			proc_0.seekg(douta_0m_pos + i*jump, ios::beg);
			proc_0.read(douta_0m, size_douta);

			mpa_0m_file.write(douta_0m, size_douta);
			mpa_0m_file << "\n";

			//mpa_1
			proc_0.seekg(douta_1m_pos + i*jump, ios::beg);
			proc_0.read(douta_1m, size_douta);

			mpa_1m_file.write(douta_1m, size_douta);
			mpa_1m_file << "\n";

			//mpa_2
			proc_0.seekg(douta_2m_pos + i*jump, ios::beg);
			proc_0.read(douta_2m, size_douta);

			mpa_2m_file.write(douta_2m, size_douta);
			mpa_2m_file << "\n";

			//mpa_3
			proc_0.seekg(douta_3m_pos + i*jump, ios::beg);
			proc_0.read(douta_3m, size_douta);

			mpa_3m_file.write(douta_3m, size_douta);
			mpa_3m_file << "\n";

			//mpa_4
			proc_0.seekg(douta_4m_pos + i*jump, ios::beg);
			proc_0.read(douta_4m, size_douta);

			mpa_4m_file.write(douta_4m, size_douta);
			mpa_4m_file << "\n";

			//mpa_5
			proc_0.seekg(douta_5m_pos + i*jump, ios::beg);
			proc_0.read(douta_5m, size_douta);

			mpa_5m_file.write(douta_5m, size_douta);
			mpa_5m_file << "\n";

			//mpa_6
			proc_0.seekg(douta_6m_pos + i*jump, ios::beg);
			proc_0.read(douta_6m, size_douta);

			mpa_6m_file.write(douta_6m, size_douta);
			mpa_6m_file << "\n";

			//mpa_7
			proc_0.seekg(douta_7m_pos + i*jump, ios::beg);
			proc_0.read(douta_7m, size_douta);

			mpa_7m_file.write(douta_7m, size_douta);
			mpa_7m_file << "\n";
		}

		// for 10-99

		for (i = 0; i < 90; i++)
		{
			jump = 68;
			douta_0m_pos = 672;
			douta_1m_pos = 679;
			douta_2m_pos = 686;
			douta_3m_pos = 693;
			douta_4m_pos = 700;
			douta_5m_pos = 707;
			douta_6m_pos = 714;
			douta_7m_pos = 721;

			// mpa_0
			proc_0.seekg(douta_0m_pos + i*jump, ios::beg);
			proc_0.read(douta_0m, size_douta);

			mpa_0m_file.write(douta_0m, size_douta);
			mpa_0m_file << "\n";

			//mpa_1
			proc_0.seekg(douta_1m_pos + i*jump, ios::beg);
			proc_0.read(douta_1m, size_douta);

			mpa_1m_file.write(douta_1m, size_douta);
			mpa_1m_file << "\n";

			//mpa_2
			proc_0.seekg(douta_2m_pos + i*jump, ios::beg);
			proc_0.read(douta_2m, size_douta);

			mpa_2m_file.write(douta_2m, size_douta);
			mpa_2m_file << "\n";

			//mpa_3
			proc_0.seekg(douta_3m_pos + i*jump, ios::beg);
			proc_0.read(douta_3m, size_douta);

			mpa_3m_file.write(douta_3m, size_douta);
			mpa_3m_file << "\n";

			//mpa_4
			proc_0.seekg(douta_4m_pos + i*jump, ios::beg);
			proc_0.read(douta_4m, size_douta);

			mpa_4m_file.write(douta_4m, size_douta);
			mpa_4m_file << "\n";

			//mpa_5
			proc_0.seekg(douta_5m_pos + i*jump, ios::beg);
			proc_0.read(douta_5m, size_douta);

			mpa_5m_file.write(douta_5m, size_douta);
			mpa_5m_file << "\n";

			//mpa_6
			proc_0.seekg(douta_6m_pos + i*jump, ios::beg);
			proc_0.read(douta_6m, size_douta);

			mpa_6m_file.write(douta_6m, size_douta);
			mpa_6m_file << "\n";

			//mpa_7
			proc_0.seekg(douta_7m_pos + i*jump, ios::beg);
			proc_0.read(douta_7m, size_douta);

			mpa_7m_file.write(douta_7m, size_douta);
			mpa_7m_file << "\n";
		}

		// for 100-999

		for (i = 0; i < 900; i++)
		{
			jump = 70;
			douta_0m_pos = 6794;
			douta_1m_pos = 6801;
			douta_2m_pos = 6808;
			douta_3m_pos = 6815;
			douta_4m_pos = 6822;
			douta_5m_pos = 6829;
			douta_6m_pos = 6836;
			douta_7m_pos = 6843;

			proc_0.seekg(douta_0m_pos + i*jump, ios::beg);
			proc_0.read(douta_0m, size_douta);

			mpa_0m_file.write(douta_0m, size_douta);
			mpa_0m_file << "\n";

			//mpa_1
			proc_0.seekg(douta_1m_pos + i*jump, ios::beg);
			proc_0.read(douta_1m, size_douta);

			mpa_1m_file.write(douta_1m, size_douta);
			mpa_1m_file << "\n";

			//mpa_2
			proc_0.seekg(douta_2m_pos + i*jump, ios::beg);
			proc_0.read(douta_2m, size_douta);

			mpa_2m_file.write(douta_2m, size_douta);
			mpa_2m_file << "\n";

			//mpa_3
			proc_0.seekg(douta_3m_pos + i*jump, ios::beg);
			proc_0.read(douta_3m, size_douta);

			mpa_3m_file.write(douta_3m, size_douta);
			mpa_3m_file << "\n";

			//mpa_4
			proc_0.seekg(douta_4m_pos + i*jump, ios::beg);
			proc_0.read(douta_4m, size_douta);

			mpa_4m_file.write(douta_4m, size_douta);
			mpa_4m_file << "\n";

			//mpa_5
			proc_0.seekg(douta_5m_pos + i*jump, ios::beg);
			proc_0.read(douta_5m, size_douta);

			mpa_5m_file.write(douta_5m, size_douta);
			mpa_5m_file << "\n";

			//mpa_6
			proc_0.seekg(douta_6m_pos + i*jump, ios::beg);
			proc_0.read(douta_6m, size_douta);

			mpa_6m_file.write(douta_6m, size_douta);
			mpa_6m_file << "\n";

			//mpa_7
			proc_0.seekg(douta_7m_pos + i*jump, ios::beg);
			proc_0.read(douta_7m, size_douta);

			mpa_7m_file.write(douta_7m, size_douta);
			mpa_7m_file << "\n";
		}

		// for 1000-1023

		for (i = 0; i < 24; i++)
		{
			jump = 72;
			douta_0m_pos = 69796;
			douta_1m_pos = 69803;
			douta_2m_pos = 69810;
			douta_3m_pos = 69817;
			douta_4m_pos = 69824;
			douta_5m_pos = 69831;
			douta_6m_pos = 69838;
			douta_7m_pos = 69845;

			proc_0.seekg(douta_0m_pos + i*jump, ios::beg);
			proc_0.read(douta_0m, size_douta);

			mpa_0m_file.write(douta_0m, size_douta);
			mpa_0m_file << "\n";

			//mpa_1
			proc_0.seekg(douta_1m_pos + i*jump, ios::beg);
			proc_0.read(douta_1m, size_douta);

			mpa_1m_file.write(douta_1m, size_douta);
			mpa_1m_file << "\n";

			//mpa_2
			proc_0.seekg(douta_2m_pos + i*jump, ios::beg);
			proc_0.read(douta_2m, size_douta);

			mpa_2m_file.write(douta_2m, size_douta);
			mpa_2m_file << "\n";

			//mpa_3
			proc_0.seekg(douta_3m_pos + i*jump, ios::beg);
			proc_0.read(douta_3m, size_douta);

			mpa_3m_file.write(douta_3m, size_douta);
			mpa_3m_file << "\n";

			//mpa_4
			proc_0.seekg(douta_4m_pos + i*jump, ios::beg);
			proc_0.read(douta_4m, size_douta);

			mpa_4m_file.write(douta_4m, size_douta);
			mpa_4m_file << "\n";

			//mpa_5
			proc_0.seekg(douta_5m_pos + i*jump, ios::beg);
			proc_0.read(douta_5m, size_douta);

			mpa_5m_file.write(douta_5m, size_douta);
			mpa_5m_file << "\n";

			//mpa_6
			proc_0.seekg(douta_6m_pos + i*jump, ios::beg);
			proc_0.read(douta_6m, size_douta);

			mpa_6m_file.write(douta_6m, size_douta);
			mpa_6m_file << "\n";

			//mpa_7
			proc_0.seekg(douta_7m_pos + i*jump, ios::beg);
			proc_0.read(douta_7m, size_douta);

			mpa_7m_file.write(douta_7m, size_douta);
			mpa_7m_file << "\n";
		}


		proc_0.close();	}




		//
		//
		//----- dtc.2.prn
		//
		//
		//

		ifstream file_mpa_1("dtc.2.prn", ios::in | ios::binary | ios::ate);
		ofstream out_1("out_1.txt");

		ifstream proc_1("out_1.txt");

		if (file_mpa_1.is_open())
		{
			size = file_mpa_1.tellg();
			mpa_5_f = new char[size];

			file_mpa_1.seekg(header, ios::beg);
			file_mpa_1.read(mpa_5_f, size);

			out_1.write(mpa_5_f, size);

			file_mpa_1.close();
		}

	

		if (proc_1.is_open())
		{

			//
			// segment 0-9, 10-99, 100-1024
			//

			int i;

			// for 0-9

			for (i = 0; i < 10; i++)
			{
				jump = 66;
				douta_0m_pos = 10;
				douta_1m_pos = 17;
				douta_2m_pos = 24;
				douta_3m_pos = 31;
				douta_4m_pos = 38;
				douta_5m_pos = 45;
				douta_6m_pos = 52;
				douta_7m_pos = 59;

				// mpa_0
				proc_1.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_1.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_1.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_1.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_1.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_1.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_1.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_1.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_1.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_1.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_1.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_1.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_1.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_1.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_1.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_1.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 10-99

			for (i = 0; i < 90; i++)
			{
				jump = 68;
				douta_0m_pos = 672;
				douta_1m_pos = 679;
				douta_2m_pos = 686;
				douta_3m_pos = 693;
				douta_4m_pos = 700;
				douta_5m_pos = 707;
				douta_6m_pos = 714;
				douta_7m_pos = 721;

				// mpa_0
				proc_1.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_1.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_1.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_1.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_1.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_1.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_1.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_1.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_1.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_1.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_1.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_1.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_1.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_1.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_1.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_1.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 100-999

			for (i = 0; i < 900; i++)
			{
				jump = 70;
				douta_0m_pos = 6794;
				douta_1m_pos = 6801;
				douta_2m_pos = 6808;
				douta_3m_pos = 6815;
				douta_4m_pos = 6822;
				douta_5m_pos = 6829;
				douta_6m_pos = 6836;
				douta_7m_pos = 6843;

				proc_1.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_1.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_1.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_1.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_1.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_1.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_1.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_1.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_1.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_1.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_1.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_1.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_1.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_1.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_1.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_1.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 1000-1023

			for (i = 0; i < 24; i++)
			{
				jump = 72;
				douta_0m_pos = 69796;
				douta_1m_pos = 69803;
				douta_2m_pos = 69810;
				douta_3m_pos = 69817;
				douta_4m_pos = 69824;
				douta_5m_pos = 69831;
				douta_6m_pos = 69838;
				douta_7m_pos = 69845;

				proc_1.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_1.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_1.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_1.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_1.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_1.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_1.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_1.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_1.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_1.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_1.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_1.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_1.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_1.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_1.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_1.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}


			proc_1.close();

		}




		//
		//
		//----- dtc.3.prn
		//
		//
		//

		ifstream file_mpa_2("dtc.3.prn", ios::in | ios::binary | ios::ate);
		ofstream out_2("out_2.txt");

		ifstream proc_2("out_2.txt", ios::in | ios::binary | ios::ate);

		if (file_mpa_2.is_open())
		{
			size = file_mpa_2.tellg();
			mpa_6_f = new char[size];

			file_mpa_2.seekg(header, ios::beg);
			file_mpa_2.read(mpa_6_f, size);

			out_2.write(mpa_6_f, size);

			file_mpa_2.close();
		}



		if (proc_2.is_open())
		{

			//
			// segment 0-9, 10-99, 100-1024
			//

			int i;

			// for 0-9

			for (i = 0; i < 10; i++)
			{
				jump = 66;
				douta_0m_pos = 10;
				douta_1m_pos = 17;
				douta_2m_pos = 24;
				douta_3m_pos = 31;
				douta_4m_pos = 38;
				douta_5m_pos = 45;
				douta_6m_pos = 52;
				douta_7m_pos = 59;

				// mpa_0
				proc_2.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_2.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_2.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_2.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_2.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_2.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_2.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_2.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_2.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_2.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_2.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_2.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_2.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_2.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_2.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_2.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 10-99

			for (i = 0; i < 90; i++)
			{
				jump = 68;
				douta_0m_pos = 672;
				douta_1m_pos = 679;
				douta_2m_pos = 686;
				douta_3m_pos = 693;
				douta_4m_pos = 700;
				douta_5m_pos = 707;
				douta_6m_pos = 714;
				douta_7m_pos = 721;

				// mpa_0
				proc_2.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_2.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_2.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_2.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_2.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_2.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_2.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_2.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_2.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_2.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_2.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_2.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_2.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_2.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_2.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_2.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 100-999

			for (i = 0; i < 900; i++)
			{
				jump = 70;
				douta_0m_pos = 6794;
				douta_1m_pos = 6801;
				douta_2m_pos = 6808;
				douta_3m_pos = 6815;
				douta_4m_pos = 6822;
				douta_5m_pos = 6829;
				douta_6m_pos = 6836;
				douta_7m_pos = 6843;

				proc_2.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_2.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_2.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_2.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_2.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_2.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_2.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_2.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_2.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_2.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_2.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_2.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_2.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_2.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_2.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_2.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 1000-1023

			for (i = 0; i < 24; i++)
			{
				jump = 72;
				douta_0m_pos = 69796;
				douta_1m_pos = 69803;
				douta_2m_pos = 69810;
				douta_3m_pos = 69817;
				douta_4m_pos = 69824;
				douta_5m_pos = 69831;
				douta_6m_pos = 69838;
				douta_7m_pos = 69845;

				proc_2.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_2.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_2.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_2.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_2.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_2.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_2.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_2.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_2.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_2.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_2.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_2.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_2.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_2.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_2.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_2.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}


			proc_2.close();
		}




		//
		//
		//----- dtc.4.prn
		//
		//
		//

		ifstream file_mpa_3("dtc.4.prn", ios::in | ios::binary | ios::ate);
		ofstream out_3("out_3.txt");

		ifstream proc_3("out_3.txt", ios::in | ios::binary | ios::ate);

		if (file_mpa_3.is_open())
		{
			size = file_mpa_3.tellg();
			mpa_7_f = new char[size];

			file_mpa_3.seekg(header, ios::beg);
			file_mpa_3.read(mpa_7_f, size);

			out_3.write(mpa_7_f, size);

			file_mpa_3.close();
		}



		if (proc_3.is_open())
		{

			//
			// segment 0-9, 10-99, 100-1024
			//

			int i;

			// for 0-9

			for (i = 0; i < 10; i++)
			{
				jump = 66;
				douta_0m_pos = 10;
				douta_1m_pos = 17;
				douta_2m_pos = 24;
				douta_3m_pos = 31;
				douta_4m_pos = 38;
				douta_5m_pos = 45;
				douta_6m_pos = 52;
				douta_7m_pos = 59;

				// mpa_0
				proc_3.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_3.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_3.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_3.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_3.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_3.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_3.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_3.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_3.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_3.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_3.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_3.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_3.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_3.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_3.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_3.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 10-99

			for (i = 0; i < 90; i++)
			{
				jump = 68;
				douta_0m_pos = 672;
				douta_1m_pos = 679;
				douta_2m_pos = 686;
				douta_3m_pos = 693;
				douta_4m_pos = 700;
				douta_5m_pos = 707;
				douta_6m_pos = 714;
				douta_7m_pos = 721;

				// mpa_0
				proc_3.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_3.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_3.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_3.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_3.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_3.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_3.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_3.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_3.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_3.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_3.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_3.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_3.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_3.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_3.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_3.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 100-999

			for (i = 0; i < 900; i++)
			{
				jump = 70;
				douta_0m_pos = 6794;
				douta_1m_pos = 6801;
				douta_2m_pos = 6808;
				douta_3m_pos = 6815;
				douta_4m_pos = 6822;
				douta_5m_pos = 6829;
				douta_6m_pos = 6836;
				douta_7m_pos = 6843;

				proc_3.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_3.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_3.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_3.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_3.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_3.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_3.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_3.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_3.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_3.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_3.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_3.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_3.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_3.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_3.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_3.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 1000-1023

			for (i = 0; i < 24; i++)
			{
				jump = 72;
				douta_0m_pos = 69796;
				douta_1m_pos = 69803;
				douta_2m_pos = 69810;
				douta_3m_pos = 69817;
				douta_4m_pos = 69824;
				douta_5m_pos = 69831;
				douta_6m_pos = 69838;
				douta_7m_pos = 69845;

				proc_3.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_3.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_3.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_3.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_3.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_3.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_3.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_3.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_3.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_3.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_3.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_3.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_3.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_3.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_3.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_3.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}


			proc_3.close();
		}



		//
		//
		//----- dtc.5.prn
		//
		//
		//

		ifstream file_mpa_4("dtc.5.prn", ios::in | ios::binary | ios::ate);
		ofstream out_4("out_4.txt");

		ifstream proc_4("out_4.txt", ios::in | ios::binary | ios::ate);

		if (file_mpa_4.is_open())
		{
			size = file_mpa_4.tellg();
			mpa_8_f = new char[size];

			file_mpa_4.seekg(header, ios::beg);
			file_mpa_4.read(mpa_8_f, size);

			out_4.write(mpa_8_f, size);

			file_mpa_4.close();
		}



		if (proc_4.is_open())
		{

			//
			// segment 0-9, 10-99, 100-1024
			//

			int i;

			// for 0-9

			for (i = 0; i < 10; i++)
			{
				jump = 66;
				douta_0m_pos = 10;
				douta_1m_pos = 17;
				douta_2m_pos = 24;
				douta_3m_pos = 31;
				douta_4m_pos = 38;
				douta_5m_pos = 45;
				douta_6m_pos = 52;
				douta_7m_pos = 59;

				// mpa_0
				proc_4.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_4.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_4.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_4.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_4.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_4.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_4.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_4.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_4.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_4.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_4.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_4.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_4.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_4.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_4.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_4.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 10-99

			for (i = 0; i < 90; i++)
			{
				jump = 68;
				douta_0m_pos = 672;
				douta_1m_pos = 679;
				douta_2m_pos = 686;
				douta_3m_pos = 693;
				douta_4m_pos = 700;
				douta_5m_pos = 707;
				douta_6m_pos = 714;
				douta_7m_pos = 721;

				// mpa_0
				proc_4.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_4.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_4.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_4.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_4.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_4.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_4.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_4.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_4.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_4.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_4.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_4.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_4.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_4.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_4.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_4.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 100-999

			for (i = 0; i < 900; i++)
			{
				jump = 70;
				douta_0m_pos = 6794;
				douta_1m_pos = 6801;
				douta_2m_pos = 6808;
				douta_3m_pos = 6815;
				douta_4m_pos = 6822;
				douta_5m_pos = 6829;
				douta_6m_pos = 6836;
				douta_7m_pos = 6843;

				proc_4.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_4.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_4.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_4.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_4.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_4.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_4.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_4.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_4.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_4.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_4.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_4.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_4.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_4.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_4.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_4.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 1000-1023

			for (i = 0; i < 24; i++)
			{
				jump = 72;
				douta_0m_pos = 69796;
				douta_1m_pos = 69803;
				douta_2m_pos = 69810;
				douta_3m_pos = 69817;
				douta_4m_pos = 69824;
				douta_5m_pos = 69831;
				douta_6m_pos = 69838;
				douta_7m_pos = 69845;

				proc_4.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_4.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_4.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_4.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_4.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_4.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_4.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_4.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_4.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_4.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_4.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_4.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_4.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_4.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_4.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_4.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}


			proc_4.close();
		}


		//
		//
		//----- dtc.6.prn
		//
		//
		//

		ifstream file_mpa_5("dtc.6.prn", ios::in | ios::binary | ios::ate);
		ofstream out_5("out_5.txt");

		ifstream proc_5("out_5.txt", ios::in | ios::binary | ios::ate);

		if (file_mpa_5.is_open())
		{
			size = file_mpa_5.tellg();
			mpa_9_f = new char[size];

			file_mpa_5.seekg(header, ios::beg);
			file_mpa_5.read(mpa_9_f, size);

			out_5.write(mpa_9_f, size);

			file_mpa_5.close();
		}



		if (proc_5.is_open())
		{

			//
			// segment 0-9, 10-99, 100-1024
			//

			int i;

			// for 0-9

			for (i = 0; i < 10; i++)
			{
				jump = 66;
				douta_0m_pos = 10;
				douta_1m_pos = 17;
				douta_2m_pos = 24;
				douta_3m_pos = 31;
				douta_4m_pos = 38;
				douta_5m_pos = 45;
				douta_6m_pos = 52;
				douta_7m_pos = 59;

				// mpa_0
				proc_5.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_5.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_5.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_5.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_5.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_5.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_5.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_5.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_5.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_5.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_5.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_5.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_5.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_5.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_5.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_5.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 10-99

			for (i = 0; i < 90; i++)
			{
				jump = 68;
				douta_0m_pos = 672;
				douta_1m_pos = 679;
				douta_2m_pos = 686;
				douta_3m_pos = 693;
				douta_4m_pos = 700;
				douta_5m_pos = 707;
				douta_6m_pos = 714;
				douta_7m_pos = 721;

				// mpa_0
				proc_5.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_5.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_5.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_5.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_5.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_5.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_5.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_5.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_5.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_5.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_5.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_5.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_5.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_5.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_5.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_5.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 100-999

			for (i = 0; i < 900; i++)
			{
				jump = 70;
				douta_0m_pos = 6794;
				douta_1m_pos = 6801;
				douta_2m_pos = 6808;
				douta_3m_pos = 6815;
				douta_4m_pos = 6822;
				douta_5m_pos = 6829;
				douta_6m_pos = 6836;
				douta_7m_pos = 6843;

				proc_5.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_5.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_5.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_5.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_5.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_5.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_5.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_5.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_5.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_5.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_5.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_5.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_5.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_5.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_5.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_5.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 1000-1023

			for (i = 0; i < 24; i++)
			{
				jump = 72;
				douta_0m_pos = 69796;
				douta_1m_pos = 69803;
				douta_2m_pos = 69810;
				douta_3m_pos = 69817;
				douta_4m_pos = 69824;
				douta_5m_pos = 69831;
				douta_6m_pos = 69838;
				douta_7m_pos = 69845;

				proc_5.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_5.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_5.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_5.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_5.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_5.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_5.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_5.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_5.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_5.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_5.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_5.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_5.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_5.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_5.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_5.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}


			proc_5.close();
		}


		//
		//
		//----- dtc.7.prn
		//
		//
		//

		ifstream file_mpa_6("dtc.7.prn", ios::in | ios::binary | ios::ate);
		ofstream out_6("out_6.txt");

		ifstream proc_6("out_6.txt", ios::in | ios::binary | ios::ate);

		if (file_mpa_6.is_open())
		{
			size = file_mpa_6.tellg();
			mpa_10_f = new char[size];

			file_mpa_6.seekg(header, ios::beg);
			file_mpa_6.read(mpa_10_f, size);

			out_6.write(mpa_10_f, size);

			file_mpa_6.close();
		}



		if (proc_6.is_open())
		{

			//
			// segment 0-9, 10-99, 100-1024
			//

			int i;

			// for 0-9

			for (i = 0; i < 10; i++)
			{
				jump = 66;
				douta_0m_pos = 10;
				douta_1m_pos = 17;
				douta_2m_pos = 24;
				douta_3m_pos = 31;
				douta_4m_pos = 38;
				douta_5m_pos = 45;
				douta_6m_pos = 52;
				douta_7m_pos = 59;

				// mpa_0
				proc_6.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_6.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_6.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_6.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_6.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_6.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_6.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_6.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_6.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_6.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_6.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_6.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_6.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_6.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_6.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_6.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 10-99

			for (i = 0; i < 90; i++)
			{
				jump = 68;
				douta_0m_pos = 672;
				douta_1m_pos = 679;
				douta_2m_pos = 686;
				douta_3m_pos = 693;
				douta_4m_pos = 700;
				douta_5m_pos = 707;
				douta_6m_pos = 714;
				douta_7m_pos = 721;

				// mpa_0
				proc_6.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_6.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_6.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_6.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_6.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_6.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_6.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_6.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_6.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_6.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_6.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_6.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_6.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_6.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_6.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_6.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 100-999

			for (i = 0; i < 900; i++)
			{
				jump = 70;
				douta_0m_pos = 6794;
				douta_1m_pos = 6801;
				douta_2m_pos = 6808;
				douta_3m_pos = 6815;
				douta_4m_pos = 6822;
				douta_5m_pos = 6829;
				douta_6m_pos = 6836;
				douta_7m_pos = 6843;

				proc_6.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_6.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_6.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_6.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_6.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_6.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_6.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_6.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_6.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_6.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_6.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_6.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_6.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_6.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_6.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_6.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 1000-1023

			for (i = 0; i < 24; i++)
			{
				jump = 72;
				douta_0m_pos = 69796;
				douta_1m_pos = 69803;
				douta_2m_pos = 69810;
				douta_3m_pos = 69817;
				douta_4m_pos = 69824;
				douta_5m_pos = 69831;
				douta_6m_pos = 69838;
				douta_7m_pos = 69845;

				proc_6.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_6.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_6.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_6.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_6.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_6.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_6.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_6.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_6.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_6.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_6.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_6.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_6.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_6.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_6.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_6.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}


			proc_6.close();
		}


		//
		//
		//----- dtc.8.prn
		//
		//
		//

		ifstream file_mpa_7("dtc.8.prn", ios::in | ios::binary | ios::ate);
		ofstream out_7("out_7.txt");

		ifstream proc_7("out_7.txt", ios::in | ios::binary | ios::ate);

		if (file_mpa_7.is_open())
		{
			size = file_mpa_7.tellg();
			mpa_11_f = new char[size];

			file_mpa_7.seekg(header, ios::beg);
			file_mpa_7.read(mpa_11_f, size);

			out_7.write(mpa_7_f, size);

			file_mpa_3.close();
		}



		if (proc_7.is_open())
		{

			//
			// segment 0-9, 10-99, 100-1024
			//

			int i;

			// for 0-9

			for (i = 0; i < 10; i++)
			{
				jump = 66;
				douta_0m_pos = 10;
				douta_1m_pos = 17;
				douta_2m_pos = 24;
				douta_3m_pos = 31;
				douta_4m_pos = 38;
				douta_5m_pos = 45;
				douta_6m_pos = 52;
				douta_7m_pos = 59;

				// mpa_0
				proc_7.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_7.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_7.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_7.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_7.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_7.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_7.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_7.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_7.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_7.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_7.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_7.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_7.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_7.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_7.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_7.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 10-99

			for (i = 0; i < 90; i++)
			{
				jump = 68;
				douta_0m_pos = 672;
				douta_1m_pos = 679;
				douta_2m_pos = 686;
				douta_3m_pos = 693;
				douta_4m_pos = 700;
				douta_5m_pos = 707;
				douta_6m_pos = 714;
				douta_7m_pos = 721;

				// mpa_0
				proc_7.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_7.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_7.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_7.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_7.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_7.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_7.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_7.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_7.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_7.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_7.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_7.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_7.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_7.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_7.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_7.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 100-999

			for (i = 0; i < 900; i++)
			{
				jump = 70;
				douta_0m_pos = 6794;
				douta_1m_pos = 6801;
				douta_2m_pos = 6808;
				douta_3m_pos = 6815;
				douta_4m_pos = 6822;
				douta_5m_pos = 6829;
				douta_6m_pos = 6836;
				douta_7m_pos = 6843;

				proc_7.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_7.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_7.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_7.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_7.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_7.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_7.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_7.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_7.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_7.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_7.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_7.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_7.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_7.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_7.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_7.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}

			// for 1000-1023

			for (i = 0; i < 24; i++)
			{
				jump = 72;
				douta_0m_pos = 69796;
				douta_1m_pos = 69803;
				douta_2m_pos = 69810;
				douta_3m_pos = 69817;
				douta_4m_pos = 69824;
				douta_5m_pos = 69831;
				douta_6m_pos = 69838;
				douta_7m_pos = 69845;

				proc_7.seekg(douta_0m_pos + i*jump, ios::beg);
				proc_7.read(douta_0m, size_douta);

				mpa_0m_file.write(douta_0m, size_douta);
				mpa_0m_file << "\n";

				//mpa_1
				proc_7.seekg(douta_1m_pos + i*jump, ios::beg);
				proc_7.read(douta_1m, size_douta);

				mpa_1m_file.write(douta_1m, size_douta);
				mpa_1m_file << "\n";

				//mpa_2
				proc_7.seekg(douta_2m_pos + i*jump, ios::beg);
				proc_7.read(douta_2m, size_douta);

				mpa_2m_file.write(douta_2m, size_douta);
				mpa_2m_file << "\n";

				//mpa_3
				proc_7.seekg(douta_3m_pos + i*jump, ios::beg);
				proc_7.read(douta_3m, size_douta);

				mpa_3m_file.write(douta_3m, size_douta);
				mpa_3m_file << "\n";

				//mpa_4
				proc_7.seekg(douta_4m_pos + i*jump, ios::beg);
				proc_7.read(douta_4m, size_douta);

				mpa_4m_file.write(douta_4m, size_douta);
				mpa_4m_file << "\n";

				//mpa_5
				proc_7.seekg(douta_5m_pos + i*jump, ios::beg);
				proc_7.read(douta_5m, size_douta);

				mpa_5m_file.write(douta_5m, size_douta);
				mpa_5m_file << "\n";

				//mpa_6
				proc_7.seekg(douta_6m_pos + i*jump, ios::beg);
				proc_7.read(douta_6m, size_douta);

				mpa_6m_file.write(douta_6m, size_douta);
				mpa_6m_file << "\n";

				//mpa_7
				proc_7.seekg(douta_7m_pos + i*jump, ios::beg);
				proc_7.read(douta_7m, size_douta);

				mpa_7m_file.write(douta_7m, size_douta);
				mpa_7m_file << "\n";
			}


			proc_3.close();
		}
		mpa_0m_file.close();
		mpa_1m_file.close();
		mpa_2m_file.close();
		mpa_3m_file.close();
		mpa_4m_file.close();
		mpa_5m_file.close();
		mpa_6m_file.close();
		mpa_7m_file.close();



		//
		//
		// output only unique stubs 
		//
		//


		ifstream mpa_0m_fi("mpa_0.txt", ios::in | ios::ate | ios::binary);
		ofstream mpa_0m_fo("mpa_0_final.txt");

		ifstream mpa_1m_fi("mpa_1.txt", ios::in | ios::ate | ios::binary);
		ofstream mpa_1m_fo("mpa_1_final.txt");

		ifstream mpa_2m_fi("mpa_2.txt", ios::in | ios::ate | ios::binary);
		ofstream mpa_2m_fo("mpa_2_final.txt");

		ifstream mpa_3m_fi("mpa_3.txt", ios::in | ios::ate | ios::binary);
		ofstream mpa_3m_fo("mpa_3_final.txt");

		ifstream mpa_4m_fi("mpa_4.txt", ios::in | ios::ate | ios::binary);
		ofstream mpa_4m_fo("mpa_4_final.txt");

		ifstream mpa_5m_fi("mpa_5.txt", ios::in | ios::ate | ios::binary);
		ofstream mpa_5m_fo("mpa_5_final.txt");

		ifstream mpa_6m_fi("mpa_6.txt", ios::in | ios::ate | ios::binary);
		ofstream mpa_6m_fo("mpa_6_final.txt");

		ifstream mpa_7m_fi("mpa_7.txt", ios::in | ios::ate | ios::binary);
		ofstream mpa_7m_fo("mpa_7_final.txt");

		char * mpa_0;
		char * mpa_1;
		char * mpa_2;
		char * mpa_3;
		char * mpa_4;
		char * mpa_5;
		char * mpa_6;
		char * mpa_7;

		char * mem;
		int j;


		//----- dtc.1.prn -----
		//
		//
		// ----- mpa_0 -----
		//
		if (mpa_0m_fi.is_open())
		{
			mpa_0 = new char[size_douta];
			mem = new char[size_douta];


			for (j = 0; j < 24576; j++)
			{
				mpa_0m_fi.seekg(0 + j * 8, ios::beg);
				mpa_0m_fi.read(mpa_0, size_douta);


				if (strcmp(mpa_0, mem) == -1 || strcmp(mpa_0, mem) == 1)  // strings not same
				{
					mpa_0m_fo.write(mpa_0, size_douta);
					mpa_0m_fo << "\n";
				}

				/*
				cout << mpa_0 << endl;
				cout << mem << endl;
				cout << strcmp(mpa_0, mem) << endl << endl;
				*/

				strncpy(mem, mpa_0, size_douta);
			}
			
			mpa_0m_fi.close();

			mpa_0m_fo.close();
		}


		//
		// ----- mpa_1 -----
		//
		if (mpa_1m_fi.is_open())
		{
			mpa_1 = new char[size_douta];
			mem = new char[size_douta];


			for (j = 0; j < 24576; j++)
			{
				mpa_1m_fi.seekg(0 + j * 8, ios::beg);
				mpa_1m_fi.read(mpa_1, size_douta);

				/*
				if (j == 0)
				{
				mpa_0m_fo.write(mpa_0, size_douta);
				mpa_0m_fo << "\n";
				}
				*/
				if (strcmp(mpa_1, mem) == -1 || strcmp(mpa_1, mem) == 1)  // strings not same
				{
					mpa_1m_fo.write(mpa_1, size_douta);
					mpa_1m_fo << "\n";
				}

				/*
				cout << mpa_1 << endl;
				cout << mem << endl;
				cout << j << endl;
				cout << strcmp(mpa_1, mem) << endl << endl;
				*/

				strncpy(mem, mpa_1, size_douta);
			}

			mpa_1m_fi.close();

			mpa_1m_fo.close();
		}


		//
		// ----- mpa_2 -----
		//
		if (mpa_2m_fi.is_open())
		{
			mpa_2 = new char[size_douta];
			mem = new char[size_douta];


			for (j = 0; j < 24576; j++)
			{
				mpa_2m_fi.seekg(0 + j * 8, ios::beg);
				mpa_2m_fi.read(mpa_2, size_douta);

				/*
				if (j == 0)
				{
				mpa_0m_fo.write(mpa_0, size_douta);
				mpa_0m_fo << "\n";
				}
				*/
				if (strcmp(mpa_2, mem) == -1 || strcmp(mpa_2, mem) == 1)  // strings not same
				{
					mpa_2m_fo.write(mpa_2, size_douta);
					mpa_2m_fo << "\n";
				}

				/*
				cout << mpa_2 << endl;
				cout << mem << endl;
				cout << strcmp(mpa_2, mem) << endl << endl;
				*/

				strncpy(mem, mpa_2, size_douta);
			}

			mpa_2m_fi.close();

			mpa_2m_fo.close();
		}


		//
		// ----- mpa_3 -----
		//
		if (mpa_3m_fi.is_open())
		{
			mpa_3 = new char[size_douta];
			mem = new char[size_douta];


			for (j = 0; j < 24576; j++)
			{
				mpa_3m_fi.seekg(0 + j * 8, ios::beg);
				mpa_3m_fi.read(mpa_3, size_douta);

				/*
				if (j == 0)
				{
				mpa_0m_fo.write(mpa_0, size_douta);
				mpa_0m_fo << "\n";
				}
				*/
				if (strcmp(mpa_3, mem) == -1 || strcmp(mpa_3, mem) == 1)  // strings not same
				{
					mpa_3m_fo.write(mpa_3, size_douta);
					mpa_3m_fo << "\n";
				}

				/*
				cout << mpa_3 << endl;
				cout << mem << endl;
				cout << strcmp(mpa_3, mem) << endl << endl;
				*/
				strncpy(mem, mpa_3, size_douta);
			}

			mpa_3m_fi.close();

			mpa_3m_fo.close();
		}



		//
		// ----- mpa_4 -----
		//
		if (mpa_4m_fi.is_open())
		{
			mpa_4 = new char[size_douta];
			mem = new char[size_douta];


			for (j = 0; j < 24576; j++)
			{
				mpa_4m_fi.seekg(0 + j * 8, ios::beg);
				mpa_4m_fi.read(mpa_4, size_douta);

				/*
				if (j == 0)
				{
				mpa_0m_fo.write(mpa_0, size_douta);
				mpa_0m_fo << "\n";
				}
				*/
				if (strcmp(mpa_4, mem) == -1 || strcmp(mpa_4, mem) == 1)  // strings not same
				{
					mpa_4m_fo.write(mpa_4, size_douta);
					mpa_4m_fo << "\n";
				}

				/*
				cout << mpa_4 << endl;
				cout << mem << endl;
				cout << strcmp(mpa_3, mem) << endl << endl;
				*/

				strncpy(mem, mpa_4, size_douta);
			}

			mpa_4m_fi.close();

			mpa_4m_fo.close();

			delete[]mem;
		}



		//
		// ----- mpa_5 -----
		//
		if (mpa_5m_fi.is_open())
		{
			mpa_5 = new char[size_douta];
			mem = new char[size_douta];


			for (j = 0; j < 24576; j++)
			{
				mpa_5m_fi.seekg(0 + j * 8, ios::beg);
				mpa_5m_fi.read(mpa_5, size_douta);

				/*
				if (j == 0)
				{
				mpa_0m_fo.write(mpa_0, size_douta);
				mpa_0m_fo << "\n";
				}
				*/
				if (strcmp(mpa_5, mem) == -1 || strcmp(mpa_5, mem) == 1)  // strings not same
				{
					mpa_5m_fo.write(mpa_5, size_douta);
					mpa_5m_fo << "\n";
				}

				/*
				cout << mpa_5 << endl;
				cout << mem << endl;
				cout << strcmp(mpa_5, mem) << endl << endl;
				*/

				strncpy(mem, mpa_5, size_douta);
			}

			mpa_5m_fi.close();

			mpa_5m_fo.close();

			delete[]mem;
		}


		//
		// ----- mpa_6 -----
		//
		if (mpa_6m_fi.is_open())
		{
			mpa_6 = new char[size_douta];
			mem = new char[size_douta];


			for (j = 0; j < 24576; j++)
			{
				mpa_6m_fi.seekg(0 + j * 8, ios::beg);
				mpa_6m_fi.read(mpa_6, size_douta);

				/*
				if (j == 0)
				{
				mpa_0m_fo.write(mpa_0, size_douta);
				mpa_0m_fo << "\n";
				}
				*/
				if (strcmp(mpa_6, mem) == -1 || strcmp(mpa_6, mem) == 1)  // strings not same
				{
					mpa_6m_fo.write(mpa_6, size_douta);
					mpa_6m_fo << "\n";
				}

				/*
				cout << mpa_5 << endl;
				cout << mem << endl;
				cout << strcmp(mpa_5, mem) << endl << endl;
				*/

				strncpy(mem, mpa_6, size_douta);
			}

			mpa_6m_fi.close();

			mpa_6m_fo.close();

			delete[]mem;
		}


		//
		// ----- mpa_7 -----
		//
		if (mpa_7m_fi.is_open())
		{
			mpa_7 = new char[size_douta];
			mem = new char[size_douta];


			for (j = 0; j < 24576; j++)
			{
				mpa_7m_fi.seekg(0 + j * 8, ios::beg);
				mpa_7m_fi.read(mpa_7, size_douta);

				/*
				if (j == 0)
				{
				mpa_0m_fo.write(mpa_0, size_douta);
				mpa_0m_fo << "\n";
				}
				*/
				if (strcmp(mpa_7, mem) == -1 || strcmp(mpa_7, mem) == 1)  // strings not same
				{
					mpa_7m_fo.write(mpa_7, size_douta);
					mpa_7m_fo << "\n";
				}

				/*
				cout << mpa_5 << endl;
				cout << mem << endl;
				cout << strcmp(mpa_5, mem) << endl << endl;
				*/

				strncpy(mem, mpa_7, size_douta);
			}

			mpa_7m_fi.close();

			mpa_7m_fo.close();

			delete[]mem;
		}

	
	return 0;
}

#include<stdio.h>
#include<fstream>
#include<iostream>

using namespace std;

int main()
{
	ifstream dtcinput("dtc.prn", ios::in | ios::binary | ios::ate);
	ofstream dtcproc("dtcproc.txt");

	char *memblock;

	int size = 16889;

	// stripping away header and extracting first 263 samples
	// all stub information available in 263 samples by observation

	if (dtcinput.is_open())
	{
		memblock = new char[size];

		dtcinput.seekg(122, ios::beg);
		dtcinput.read(memblock, size);

		dtcproc.write(memblock, size);

		dtcinput.close();
		dtcproc.close();
	}

	// processing dtcproc to file stub information according to chip ID

	ofstream mpa0_f("mpa0_int.txt");
	ofstream mpa1_f("mpa1_int.txt");
	ofstream mpa2_f("mpa2_int.txt");
	ofstream mpa3_f("mpa3_int.txt");
	ofstream mpa4_f("mpa4_int.txt");
	ofstream mpa5_f("mpa5_int.txt");
	ofstream mpa6_f("mpa6_int.txt");
	ofstream mpa7_f("mpa7_int.txt");


	ifstream dtcproc_o("dtcproc.txt", ios::in | ios::ate | ios::binary);

	char * chipID;
	char * douta_0;
	char * douta_1;
	char * douta_2;
	char * douta_3;
	char * douta_4;
	char * douta_5;
	char * douta_6;
	char * douta_7;

	int i;

	int jump_douta = 68;
	int jump_chipID;



	if (dtcproc_o.is_open())
	{
		douta_0 = new char[6];
		douta_1= new char[6];
		douta_2= new char[6];
		douta_3 = new char[6];
		douta_4 = new char[6];
		douta_5 = new char[6];
		douta_6 = new char[6];
		douta_7 = new char[6];


		// 
		//  for i 0 - 9 
		//

		for (i = 1; i < 10; i++)
		{
			jump_douta = 68;
			jump_chipID = 68;

			//-----chip0
			// read
			dtcproc_o.seekg(9 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_0, 6);
			//write
			mpa0_f.write(douta_0, 6);
			mpa0_f << "\n";


			//-----chip1
			// read
			dtcproc_o.seekg(16 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_1, 6);
			//write
			mpa1_f.write(douta_1, 6);
			mpa1_f << "\n";

			//-----chip2
			// read
			dtcproc_o.seekg(23 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_2, 6);
			//write
			mpa2_f.write(douta_2, 6);
			mpa2_f << "\n";

			//-----chip3
			// read
			dtcproc_o.seekg(30 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_3, 6);
			//write
			mpa3_f.write(douta_3, 6);
			mpa3_f << "\n";

			//-----chip4
			// read
			dtcproc_o.seekg(37 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_4, 6);
			//write
			mpa4_f.write(douta_4, 6);
			mpa4_f << "\n";

			//-----chip5
			// read
			dtcproc_o.seekg(44 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_5, 6);
			//write
			mpa5_f.write(douta_5, 6);
			mpa5_f << "\n";

			//-----chip6
			// read
			dtcproc_o.seekg(51 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_6, 6);
			//write
			mpa6_f.write(douta_6, 6);
			mpa6_f << "\n";

			//-----chip7
			// read
			dtcproc_o.seekg(58 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_7, 6);
			//write
			mpa7_f.write(douta_7, 6);
			mpa7_f << "\n";

		}

		// 
		//  for i 10 - 99 
		//

		for (i = 0; i < 90; i++)
		{
			jump_douta = 70;
			jump_chipID = 70;

			//-----chip0
			// read
			dtcproc_o.seekg(691 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_0, 6);
			//write
			mpa0_f.write(douta_0, 6);
			mpa0_f << "\n";


			//-----chip1
			// read
			dtcproc_o.seekg(698 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_1, 6);
			//write
			mpa1_f.write(douta_1, 6);
			mpa1_f << "\n";

			//-----chip2
			// read
			dtcproc_o.seekg(705 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_2, 6);
			//write
			mpa2_f.write(douta_2, 6);
			mpa2_f << "\n";

			//-----chip3
			// read
			dtcproc_o.seekg(712 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_3, 6);
			//write
			mpa3_f.write(douta_3, 6);
			mpa3_f << "\n";

			//-----chip4
			// read
			dtcproc_o.seekg(719 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_4, 6);
			//write
			mpa4_f.write(douta_4, 6);
			mpa4_f << "\n";

			//-----chip5
			// read
			dtcproc_o.seekg(726 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_5, 6);
			//write
			mpa5_f.write(douta_5, 6);
			mpa5_f << "\n";

			//-----chip6
			// read
			dtcproc_o.seekg(733 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_6, 6);
			//write
			mpa6_f.write(douta_6, 6);
			mpa6_f << "\n";

			//-----chip7
			// read
			dtcproc_o.seekg(740 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_7, 6);
			//write
			mpa7_f.write(douta_7, 6);
			mpa7_f << "\n";

		}

		// 
		//  for i 100 - 240 
		//

		for (i = 0; i < 141; i++)
		{
			jump_douta = 72;
			jump_chipID = 72;

			//-----chip0
			// read
			dtcproc_o.seekg(6993 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_0, 6);
			//write
			mpa0_f.write(douta_0, 6);
			mpa0_f << "\n";


			//-----chip1
			// read
			dtcproc_o.seekg(7000 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_1, 6);
			//write
			mpa1_f.write(douta_1, 6);
			mpa1_f << "\n";

			//-----chip2
			// read
			dtcproc_o.seekg(7007 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_2, 6);
			//write
			mpa2_f.write(douta_2, 6);
			mpa2_f << "\n";

			//-----chip3
			// read
			dtcproc_o.seekg(7014 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_3, 6);
			//write
			mpa3_f.write(douta_3, 6);
			mpa3_f << "\n";

			//-----chip4
			// read
			dtcproc_o.seekg(7021 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_4, 6);
			//write
			mpa4_f.write(douta_4, 6);
			mpa4_f << "\n";

			//-----chip5
			// read
			dtcproc_o.seekg(7028 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_5, 6);
			//write
			mpa5_f.write(douta_5, 6);
			mpa5_f << "\n";

			//-----chip6
			// read
			dtcproc_o.seekg(7035 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_6, 6);
			//write
			mpa6_f.write(douta_6, 6);
			mpa6_f << "\n";

			//-----chip7
			// read
			dtcproc_o.seekg(7042 + i*jump_douta, ios::beg);
			dtcproc_o.read(douta_7, 6);
			//write
			mpa7_f.write(douta_7, 6);
			mpa7_f << "\n";

		}

		dtcproc_o.close();

		mpa0_f.close();
		mpa1_f.close();
		mpa2_f.close();
		mpa3_f.close();
		mpa4_f.close();
		mpa5_f.close();
		mpa6_f.close();
		mpa7_f.close();

	}

	

	//
	//  extracting unique stubs
	//  assumption: every stub info corresponding to a chipID is unique
	//

	ifstream m0("mpa0_int.txt", ios::in | ios::ate | ios::binary);
	ifstream m1("mpa1_int.txt", ios::in | ios::ate | ios::binary);
	ifstream m2("mpa2_int.txt", ios::in | ios::ate | ios::binary);
	ifstream m3("mpa3_int.txt", ios::in | ios::ate | ios::binary);
	ifstream m4("mpa4_int.txt", ios::in | ios::ate | ios::binary);
	ifstream m5("mpa5_int.txt", ios::in | ios::ate | ios::binary);
	ifstream m6("mpa6_int.txt", ios::in | ios::ate | ios::binary);
	ifstream m7("mpa7_int.txt", ios::in | ios::ate | ios::binary);


	ofstream mpa0_fo("mpa0.txt");
	ofstream mpa1_fo("mpa1.txt");
	ofstream mpa2_fo("mpa2.txt");
	ofstream mpa3_fo("mpa3.txt");
	ofstream mpa4_fo("mpa4.txt");
	ofstream mpa5_fo("mpa5.txt");
	ofstream mpa6_fo("mpa6.txt");
	ofstream mpa7_fo("mpa7.txt");

	char * mem, *mem2;
	int cond;
	int j;

	//
	//---mpa0---
	//

	if (m0.is_open())
	{
		mem = new char[6];
		mem2 = new char[6];

		for (j = 0; j < 240; j++)
		{
			m0.seekg(0 + j*8, ios::beg);
			m0.read(mem2, 6);

			cond = strcmp(mem, mem2);

			if (cond == 1 || cond == -1)
			{
				mpa0_fo.write(mem2, 6);
				mpa0_fo << "\n";
			}

			strcpy(mem, mem2);

			/*
			cout << mem2 << endl;
			cout << mem << endl;
			cout << cond << endl << endl;
			*/
		}


		m0.close();
	}

	//
	//---mpa0---
	//

	if (m1.is_open())
	{
		mem = new char[6];
		mem2 = new char[6];

		for (j = 0; j < 240; j++)
		{
			m1.seekg(0 + j * 8, ios::beg);
			m1.read(mem2, 6);

			cond = strcmp(mem, mem2);

			if (cond == 1 || cond == -1)
			{
				mpa1_fo.write(mem2, 6);
				mpa1_fo << "\n";
			}

			strcpy(mem, mem2);

			/*
			cout << mem2 << endl;
			cout << mem << endl;
			cout << cond << endl << endl;
			*/
		}

		m1.close();
	}

	//
	//---mpa2---
	//

	if (m2.is_open())
	{
		mem = new char[6];
		mem2 = new char[6];

		for (j = 0; j < 240; j++)
		{
			m2.seekg(0 + j * 8, ios::beg);
			m2.read(mem2, 6);

			cond = strcmp(mem, mem2);

			if (cond == 1 || cond == -1)
			{
				mpa2_fo.write(mem2, 6);
				mpa2_fo << "\n";
			}

			strcpy(mem, mem2);

			/*
			cout << mem2 << endl;
			cout << mem << endl;
			cout << cond << endl << endl;
			*/
		}

		m2.close();
	}

	//
	//---mpa3---
	//

	if (m3.is_open())
	{
		mem = new char[6];
		mem2 = new char[6];

		for (j = 0; j < 240; j++)
		{
			m3.seekg(0 + j * 8, ios::beg);
			m3.read(mem2, 6);

			cond = strcmp(mem, mem2);

			if (cond == 1 || cond == -1)
			{
				mpa3_fo.write(mem2, 6);
				mpa3_fo << "\n";
			}

			strcpy(mem, mem2);

			/*
			cout << mem2 << endl;
			cout << mem << endl;
			cout << cond << endl << endl;
			*/
		}

		m3.close();
	}


	//
	//---mpa4---
	//

	if (m4.is_open())
	{
		mem = new char[6];
		mem2 = new char[6];

		for (j = 0; j < 240; j++)
		{
			m4.seekg(0 + j * 8, ios::beg);
			m4.read(mem2, 6);

			cond = strcmp(mem, mem2);

			if (cond == 1 || cond == -1)
			{
				mpa4_fo.write(mem2, 6);
				mpa4_fo << "\n";
			}

			strcpy(mem, mem2);

			/*
			cout << mem2 << endl;
			cout << mem << endl;
			cout << cond << endl << endl;
			*/
		}

		m4.close();
	}

	//
	//---mpa5---
	//

	if (m5.is_open())
	{
		mem = new char[6];
		mem2 = new char[6];

		for (j = 0; j < 240; j++)
		{
			m5.seekg(0 + j * 8, ios::beg);
			m5.read(mem2, 6);

			cond = strcmp(mem, mem2);

			if (cond == 1 || cond == -1)
			{
				mpa5_fo.write(mem2, 6);
				mpa5_fo << "\n";
			}

			strcpy(mem, mem2);

			/*
			cout << mem2 << endl;
			cout << mem << endl;
			cout << cond << endl << endl;
			*/
		}

		m5.close();
	}

	//
	//---mpa6---
	//

	if (m6.is_open())
	{
		mem = new char[6];
		mem2 = new char[6];

		for (j = 0; j < 240; j++)
		{
			m6.seekg(0 + j * 8, ios::beg);
			m6.read(mem2, 6);

			cond = strcmp(mem, mem2);

			if (cond == 1 || cond == -1)
			{
				mpa6_fo.write(mem2, 6);
				mpa6_fo << "\n";
			}

			strcpy(mem, mem2);

			/*
			cout << mem2 << endl;
			cout << mem << endl;
			cout << cond << endl << endl;
			*/
		}

		m6.close();
	}

	//
	//---mpa7---
	//

	if (m7.is_open())
	{
		mem = new char[6];
		mem2 = new char[6];

		for (j = 0; j < 240; j++)
		{
			m7.seekg(0 + j * 8, ios::beg);
			m7.read(mem2, 6);

			cond = strcmp(mem, mem2);

			if (cond == 1 || cond == -1)
			{
				mpa7_fo.write(mem2, 6);
				mpa7_fo << "\n";
			}

			strcpy(mem, mem2);

			/*
			cout << mem2 << endl;
			cout << mem << endl;
			cout << cond << endl << endl;
			*/
		}

		m7.close();
	}

	mpa0_fo.close();
	mpa1_fo.close();
	mpa2_fo.close();
	mpa3_fo.close();
	mpa4_fo.close();
	mpa5_fo.close();
	mpa6_fo.close();
	mpa7_fo.close();


	return 0;
}
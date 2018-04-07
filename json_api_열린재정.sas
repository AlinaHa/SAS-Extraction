%let dir=C:\json\;
%let lib=C:\json\; 
%let filename=SeriesDataOut.txt;
%let year_s=1997;  
%let year_e=2017;
%let data_final=data_sex_both;
%let var_want=PRD_DE/*����*/ C1 C1_NM C2/*����*/ C3_NM/*����*/ DT/*��*/;/*���ϴ� ������ �����*/
libname json "&lib"; 



/*���̺� �ϳ� �����(�ʱ� ������)_start*/
%let url=
http://openapi.openfiscaldata.go.kr/DepartRevenExpenSettle?FSCL_YY=2013
;

filename out "&dir&filename" recfm=v lrecl=999999999;
proc http out=out url="&url" method="post" ct="application/json";
run;

data "&lib.raw";
 infile "&dir&filename" dsd  lrecl=999999999 dlm='{}[]:,';
 input raw : $2000.@@;
run;

data "&lib.temp";
 merge "&lib.raw" "&lib.raw"(firstobs=2 rename=(raw=_raw));
 if mod(_n_,2) eq 1;
run;

data "&lib.temp";
 set "&lib.temp";
 if raw='' then group+1;
run;

proc transpose data="&lib.temp" out="&lib.data_one"(drop=_:);
by group;
id raw;
var _raw;
run;

data "&lib.data_one";set "&lib.data_one"(keep=&var_want);run;
/*���̺� �ϳ� �����(�ʱ� ������)_end*/



data "&lib.&data_final";set "&lib.data_one";run;/*�ʱ� ������(���� Ȯ�ο�) ������ ���̺�� �ٲٱ�*/



	/*�ʱ� �����Ϳ� ���ϴ� �������� ������ ��ġ��_start*/
	%macro json;
	%do year=&year_s %to &year_e;

	/*�ּ�*/
	%let url=
	http://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=NjdhZTg3ZTM1OGEzZGMyOGIyZWE0ZmIxZTBiMDg0ZTg=&format=json&jsonVD=Y&userStatsId=idencosmos/101/DT_1B040M1/2/1/20180323115347&prdSe=Y&startPrdDe=&year&endPrdDe=&year
	;
	/*�ּ�*/

	filename out "&dir&filename" recfm=v lrecl=999999999;
	proc http out=out url="&url" method="post" ct="application/json";
	run;

	data "&lib.raw";
	infile "&dir&filename" dsd lrecl=999999999 dlm='{}[]:,';
	input raw : $2000.@@;
	run;

	data "&lib.temp";
	merge "&lib.raw" "&lib.raw"(firstobs=2 rename=(raw=_raw));
	if mod(_n_,2) eq 1;
	run;

	data "&lib.temp";
	set "&lib.temp";
	if raw='' then group+1;
	run;

	proc transpose data="&lib.temp" out="&lib.data_one"(drop=_:);
	by group;
	id raw;
	var _raw;
	run;

	data "&lib.data_one";set "&lib.data_one"(keep=&var_want);run;

	data "&lib.&data_final";
	set "&lib.&data_final" "&lib.data_one";
	run;

	%end;
	%mend json;
	%json
	/*�ʱ� �����Ϳ� ���ϴ� �������� ������ ��ġ��_end*/



/*������, ���� ���� ����_start*/
data "&lib.&data_final";
set "&lib.&data_final";
Year=PRD_DE+0;/*����*/
Div_num=C1;
Div=C1_NM;
Sex=C2+0;/*����*/
Old=C3_NM;/*����*/
Num=DT+0;/*��*/
keep Year Div_num Div Old Num;
run;
/*������, ���� ���� ����_end*/

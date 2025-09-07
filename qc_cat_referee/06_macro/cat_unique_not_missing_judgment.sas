/*** HELP START ***//*

Macro:      cat_unique_not_missing_judgment

 Purpose:    Apply a PRIMARY KEY integrity constraint on one or more key variables in a 
             dataset and judge whether the dataset satisfies both uniqueness and 
             non-missing requirements.

 Parameters:
   lib=                Library name (default=WORK).
   ds=                 Dataset name (required).
   key=                Key variable(s) to be checked for uniqueness and non-missing 
                       (default=NAME).
   rule_no=            Rule number identifier. If omitted, &SYSINDEX is used.
   auto_delete_rule=   Y/N. If Y (default), the integrity constraint is deleted 
                       automatically after the check.

 Process:
   1. Create a temporary PRIMARY KEY integrity constraint on the specified key(s).
      (PRIMARY KEY enforces both uniqueness and NOT NULL.)
   2. Check if the constraint is successfully applied.
   3. Output judgment results (OK/NG) with icons and formatted print.
   4. Optionally delete the integrity constraint.
   5. Write results to the SAS log for documentation.

 Output:
   - A dataset named CAT_JUDGE_<rule_no> containing the judgment result.
   - ODS HTML/PRINT output with visual OK/NG indicators.
   - NOTE messages in the SAS log for traceability.

 Example:

	data class2;
	set sashelp.class;
	if _N_=2 then call missing(NAME);
	run;

	%cat_unique_not_missing_judgment(lib=work,ds=class2, key=age sex,rule_no= )

*//*** HELP END ***/

%macro cat_unique_not_missing_judgment(lib=work,ds=, key=NAME,rule_no= ,auto_delete_rule=Y );
%if %length(&rule_no) = 0 %then %do;
 %let rule_no=&sysindex;
%end;
%if %length(&ds) = 0 %then %do;
 %put ERROR:ds parameter is null;
 %return;
%end;
proc datasets lib=&lib. nolist;
 modify &ds.;
 ic create rule&rule_no.=primary key(&key.);
run;
quit;

proc sql noprint;
  select count(*) into:cats_obs
  from sashelp.vtabcon
  where constraint_name ="rule&rule_no." and table_name ="%upcase(&ds)" and table_catalog="%upcase(&lib.)";
quit;

%if &cats_obs ne 0 %then %do;
ods escapechar="~";
data cat_judge_&rule_no.;
cat="~{style [color=green] ~{unicode '1F638'x}}";
judge="~{style [color=green] OK}";
result="OK";
rule="uniqued by (&key) and not missing ";
lib="&lib";
dataset="&ds";
rule_no="rule&rule_no.";
run;

ods results;
ods html;
proc print data=cat_judge_&rule_no. noobs;
 var cat / style(data)=[fontsize=20pt];
 var judge/ style(data)=[fontsize=20pt];
 var rule lib dataset rule_no;
run;

%end;

%if &cats_obs eq 0 %then %do;
data cat_judge_&rule_no.;
cat="~{style [color=red] ~{unicode '1F640'x}}";
judge="~{style [color=red] NG}";
result="NG";
rule="uniqued by (&key) and not missing ";
lib="&lib";
dataset="&ds";
rule_no="rule&rule_no.";
run;


ods results;
ods html;
proc print data=cat_judge_&rule_no. noobs;
 var cat / style(data)=[fontsize=20pt];
 var judge/ style(data)=[fontsize=20pt];
 var rule lib dataset rule_no;
run;
%end;

%if %upcase(&auto_delete_rule) eq Y %then %do;
 proc datasets lib=&lib. nolist;
 modify &ds.;
 ic delete rule&rule_no.;
run;
quit;
%end;

data _null_;
set cat_judge_&rule_no.;
put "NOTE:=============";
put "NOTE:" result= ;
put "NOTE:" rule= ;
put "NOTE:" lib= ;
put "NOTE:" dataset= ;
put "NOTE:" rule_no= ;
put "NOTE:=============";
run;

%mend;

/*** HELP START ***//*

Macro:      cat_rule_judgment

 Purpose:    Apply a user-defined rule as a temporary integrity constraint (CHECK) on a 
             dataset and judge whether the dataset satisfies the rule.

 Parameters:
   lib=                Library name (default=WORK).
   ds=                 Dataset name (required).
   rule=               Rule expression to be checked (default: %nrstr(14 < AGE)).
   rule_no=            Rule number identifier. If omitted, &SYSINDEX is used.
   auto_delete_rule=   Y/N. If Y (default), the integrity constraint is deleted 
                       automatically after the check.

 Process:
   1. Create a temporary integrity constraint on the dataset.
   2. Check if the rule can be successfully applied.
   3. Output judgment results (OK/NG) with icons and formatted print.
   4. Optionally delete the integrity constraint.
   5. Write results to the log for transparency.

 Output:
   - A dataset named CAT_JUDGE_<rule_no> containing the judgment result.
   - ODS HTML/PRINT output with visual OK/NG.
   - NOTE messages in the SAS log.

 Example:
 data class;
	set sashelp.class;
 run;
 %cat_rule_judgment(lib=work,ds=class, rule=%nrstr(18>age and 50 <weight) )
 %cat_rule_judgment(lib=work,ds=class, rule=%nrstr(18>age and 60 <weight) )

*//*** HELP END ***/

%macro cat_rule_judgment(lib=work,ds=, rule=%nrstr(14 < AGE),rule_no= ,auto_delete_rule=Y );
%if %length(&rule_no) = 0 %then %do;
 %let rule_no=&sysindex;
%end;
%if %length(&ds) = 0 %then %do;
 %put ERROR:ds parameter is null;
 %return;
%end;
proc datasets lib=&lib. nolist;
 modify &ds.;
 ic create rule&rule_no.=check(where=(&rule));
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
rule="&rule";
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
rule="&rule";
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

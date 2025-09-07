# qc_cat_referee
A SAS macro toolkit for automated data quality control. Applies integrity constraints to judge datasets (OK/NG) and outputs clear, visual QC results — with a cat referee making the call.  

<img width="360" height="360" alt="Image" src="https://github.com/user-attachments/assets/847d3d66-674e-4502-92d5-21259b7072d2" />

## `%cat_rule_judgment()` macro <a name="catrulejudgment-macro-1"></a> ######
 Purpose:    Apply a user-defined rule as a temporary integrity constraint (CHECK) on a dataset and judge whether the dataset satisfies the rule.  

 Parameters:  
 ~~~text
   lib=                Library name (default=WORK).
   ds=                 Dataset name (required).
   rule=               Rule expression to be checked (default: %nrstr(14 < AGE)).
   rule_no=            Rule number identifier. If omitted, &SYSINDEX is used.
   auto_delete_rule=   Y/N. If Y (default), the integrity constraint is deleted 
                       automatically after the check.
~~~~

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
 ~~~sas
 data class;
	set sashelp.class;
 run;
 %cat_rule_judgment(lib=work,ds=class, rule=%nrstr(18>age and 50 <weight) )
~~~

<img width="313" height="71" alt="Image" src="https://github.com/user-attachments/assets/27e0aad9-8717-4d37-923e-5bff5beab9b3" />

~~~sas
 %cat_rule_judgment(lib=work,ds=class, rule=%nrstr(18>age and 60 <weight) )
~~~

<img width="304" height="70" alt="Image" src="https://github.com/user-attachments/assets/bbf9e137-dec6-46d1-bb6a-414482b1e76c" />
  
---

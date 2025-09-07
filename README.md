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

<img width="616" height="142" alt="Image" src="https://github.com/user-attachments/assets/27e0aad9-8717-4d37-923e-5bff5beab9b3" />

~~~sas
 %cat_rule_judgment(lib=work,ds=class, rule=%nrstr(18>age and 60 <weight) )
~~~

<img width="608" height="140" alt="Image" src="https://github.com/user-attachments/assets/bbf9e137-dec6-46d1-bb6a-414482b1e76c" />
  
---

## `%cat_unique_judgment()` macro <a name="catuniquejudgment-macro-2"></a> ######
 Purpose:    Apply a UNIQUE integrity constraint on one or more key variables in a dataset and judge whether the dataset satisfies uniqueness.  
  
 Parameters:  
 ~~~text
   lib=                Library name (default=WORK).
   ds=                 Dataset name (required).
   key=                Key variable(s) to be checked for uniqueness (default=NAME).
   rule_no=            Rule number identifier. If omitted, &SYSINDEX is used.
   auto_delete_rule=   Y/N. If Y (default), the integrity constraint is deleted 
                       automatically after the check.
~~~
 Process:  
   1. Create a temporary UNIQUE integrity constraint on the specified key(s).  
   2. Check if the constraint is successfully applied.  
   3. Output judgment results (OK/NG) with icons and formatted print.  
   4. Optionally delete the integrity constraint.  
   5. Write results to the SAS log for documentation.  
  
 Output:  
   - A dataset named CAT_JUDGE_<rule_no> containing the uniqueness judgment result.  
   - ODS HTML/PRINT output with visual OK/NG indicators.  
   - NOTE messages in the SAS log for traceability.  
  
 Example:  
~~~sas
 data class;
	set sashelp.class;
 run;
%cat_unique_judgment(lib=work,ds=class, key=age sex )
~~~

<img width="606" height="140" alt="Image" src="https://github.com/user-attachments/assets/8bd9b3f9-37a4-4346-a065-ec43d38b435d" />

~~~sas
%cat_unique_judgment(lib=work,ds=class, key=age height weight sex )
~~~

<img width="698" height="124" alt="image" src="https://github.com/user-attachments/assets/49620cf9-918c-4b12-93dd-7ccb53b81a91" />


---

## `%cat_unique_not_missing_judgment()` macro <a name="catuniquenotmissingjudgment-macro-3"></a> ######
 Purpose:    Apply a PRIMARY KEY integrity constraint on one or more key variables in a dataset and judge whether the dataset satisfies both uniqueness and non-missing requirements.  

 Parameters:  
 ~~~text
   lib=                Library name (default=WORK).
   ds=                 Dataset name (required).
   key=                Key variable(s) to be checked for uniqueness and non-missing 
                       (default=NAME).
   rule_no=            Rule number identifier. If omitted, &SYSINDEX is used.
   auto_delete_rule=   Y/N. If Y (default), the integrity constraint is deleted 
                       automatically after the check.
~~~
  
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
~~~sas
data class2;
set sashelp.class;
if _N_=2 then call missing(NAME);
run;

%cat_unique_not_missing_judgment(lib=work,ds=class2, key=name)
~~~

<img width="722" height="136" alt="image" src="https://github.com/user-attachments/assets/e42113a8-a852-4c15-8f4b-9fc3de1d8033" />

  
---

## Notes on versions history

- 0.1.0(08September2025): Initial version.

---

## What is SAS Packages?

The package is built on top of **SAS Packages Framework(SPF)** developed by Bartosz Jablonski.

For more information about the framework, see [SAS Packages Framework](https://github.com/yabwon/SAS_PACKAGES).

You can also find more SAS Packages (SASPacs) in the [SAS Packages Archive(SASPAC)](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)

### 1. Set-up SAS Packages Framework

First, create a directory for your packages and assign a `packages` fileref to it.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
filename packages "\path\to\your\packages";
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Secondly, enable the SAS Packages Framework.
(If you don't have SAS Packages Framework installed, follow the instruction in 
[SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) 
to install SAS Packages Framework.)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%include packages(SPFinit.sas)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### 2. Install SAS package

Install SAS package you want to use with the SPF's `%installPackage()` macro.

- For packages located in **SAS Packages Archive(SASPAC)** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located in **PharmaForest** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, mirror=PharmaForest)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located at some network location run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, sourcePath=https://some/internet/location/for/packages)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (e.g. `%installPackage(ABC, sourcePath=https://github.com/SomeRepo/ABC/raw/main/)`)


### 3. Load SAS package

Load SAS package you want to use with the SPF's `%loadPackage()` macro.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%loadPackage(packageName)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### Enjoy!


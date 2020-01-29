Libname School "C:\DATA\MSBAN 2018\4.Fall2019\SAS Symposium\School Violence\Data";
Libname School "G:\Grad College Professional Development\Digital Badge Program\Tracking related\Professional Development Project\SSS\Data";


/*DATA SET OVERALL INFO*/
Proc contents data = School.School_violence_dataset;
run;
/*2,092 obs, 476 variables*/

Proc print data = School.School_violence_dataset (obs=50);
run;

Proc freq data=School.subset;
tables VIOINC16; /*Target variable*/
run;


/*VARIABLES GROUPING:

A. From Variable order 1 -> 57 (Table B-1. Variable List)
1. SCHID (Unique school identifier)-> KEEP
2. C0014_R; C0016_R (respondent information) -> DROP
3. C0110, C0116-C0126: (7 variables order 4, 7-12) -> KEEP AS ORIGINAL (binary)
4. C0112 (Building access controlled lock/monitored doors) + C0114 (Ground access controlled locked/ monitored gates
  -> COMBINE 2 binary variables into a 3-level ordinal variable (Access_Controlled)
5. C0128 + C0130 = Drug_Testing -> COMBINE 2 binary variables into a 3-level ordinal variable 
6. C0134 - C0153(14 BINARY variables from order 15-28) -> KEEP AS ORIGINAL
7. C0155, C0157, C0158, C0162, C0166, C0169, C0170, C0173 (8 binary variables from order 29-36)
   -> indicate whether school has written plans for different hazardous situations ranging from active shooter situation 
      to natural -> COMBINE 8 variables into a nine-level variable (Written_Plans)
8. C0163, C0165, C0167 (3 binary variables from order 37-39)
   -> indicate whether school drilled students on the use of different emergency procedures (Evacuation/ Lockdown/ Shelter-in-place)
   -> COMBINE 3 binary variables into a 4-level variable (Drilled_Plans)
9. C0174 - C0186 (11 binary variables order 40-50): indicate whether school has different formal programs intended 
                                                    to prevent or reduce violence
   -> KEEP AS ORIGINAL
10.C0600 - C0602 (order 51-52): indicate if school has threat assessment team (1=Y, 2=N); and
                  if Y, how often did the team meet (5 levels)
   -> KEEP
11.C0604, C0606, C0608 (order 53-55)-> presence of LGBTQ/ Disability/ Cultural diversity groups at school
   -> COMBINE 3 binary variables to a 4-level variable (Acceptance_Groups)
12. C0190-C0192 (order 56-57) -> KEEP AS ORIGINAL (binary)

--------------------------------------------------------------------------------------------------------------------------

B. From Variable order 58 -> 121(in Table B-1. Variable List)
1. Order 58-62: C0194 (binary), C0196 - C202 (4 ordinal variables) -> KEEP C0194; COMBINE C0196-C202 together (Parent_Participation)
2. Order 63-70: C0204-C0218 (8 binary variables): indicate whether different community and outside groups involved in 
                                                 school’s efforts to promote safe, disciplined, and drug-free schools
   -> COMBINE into 1 variable (Community_Involvement)

3. Order 71-89: C0610 - C0660 (26 variables) -> different aspects of sworn law enforcement officers
   The source variable is C0610 (order 71) which indicate if school has any sworn law enforcement officers present at school
   at least once a week (1=Y, 2=N) and if Y, that leads to all the different scenarios after that (variables order 72-96), 
   each of which consists of 3 levels: 1=Y, 2=N, -1=Legitimate skip
   The number of obs for (2=N) in C0610 will be equal to the number of obs for (-1 = Legitimate skip) in each of all other 
   questions from order 72-> 96.
   (i.e., if the sworn law enforcement officers is NOT PRESENT at school, then the next question is not applicable, thus SKIP)

-> First reverse the levels of C0612-C0646: 1-> 2 and 2->1 (new levels: -1=skip, 1=No, 2 = Y)
   Then combine C0610 (1=Y, 2=N) with each of the variables from C0612-C0646
-> 3 possible values:
            2 + (-1) = 1 (not present and thus skip)
   			1 + 1 = 2 (present and not used)
   			1 + 2 = 3 (present and used)
  After combining, the new variables can be further splitted into 3 groups of variables:
 
 a. C0612-C0618 (order 72-75) & C0648 (order 90) -> COMBINE 5 variables into Law_Enforcement_Presence using index
 b. C0620-C0626 (order 76-79) -> COMBINE 4 variables into Law_Enforcement_Equiped using index
 c. C0628-C0646 (order 80-89) -> COMBINE 10 variables into Law_Enforcement_Participation using index

4. Order 91-96: C0650-C0660: for this set of variables, it consists of 2-step combination: 
                             Y in C0610 = (Y + N) in C0650 and Y in C0650 = (Yes + No + Don't know) in C0652/.../C0660
    -> First reverse the levels of C0652-C0660: 1-> 3 and 3 -> 1
       The new order will be: -1 = Legitimate skip, 1=Don't know; 2=No; 3=Yes
    -> Then COMBINE C0610 + C0650 + each of the 5 variables from C0652 -> C0660 -> the combined one will have 5 levels:
		  0 = officers NOT present, policy NOT present, skip
		  2 = officers present, policy NOT present, skip
		  3 = officers present, policy present, policy DON'T KNOW
		  4 = officers present, policy present, policy NOT used
		  5 = officers present, policy present, policy Used
  Then COMBINE the 5 newly created variables into Law_Enforcement_Policies using index

4. Order 97-99: C0662-C0666 (3 binary variables) -> COMBINE into 1 variable (Mental_Health_Assesment)
5. Order 100-102: C0668-C0672 (3 binary variables) -> COMBINE into 1 variable (Mental_Health_Treatment)
6. Order 103-109: C0674-C0686 (7 ordinal with 3 level variables) -> COMBINE into 1 variable (Mental_Health_Efforts_Limits)
7. Order 110-121: C0265-C0277 (12 binary variables) -> COMBINE into 1 variable (Teacher_Training)


--------------------------------------------------------------------------------------------------------------------------

C. From Variable order 122 -> 184 (in Table B-1. Variable List)
1. From Order 122 - 134: 13 variables 
   (C0280, C0282, C0284, C0286, C0288, C0290, C0292, C0294, C0296, C0298, C0300, C0302, C0304)
   These variables indicate the extent of the impact of different factors (13 factors) that limit school's efforts
   to reduce or prevent crime, for example: lack of teacher training, lack of parent support, inadequate funds, etc.
   They are ORDINAL variables with 3 levels: 1 = Limits in major way; 2 = Limits in minor way; 3 = Does not limit
   -> COMBINE (Limitation_school_effort)

2. Order 135: C0306 (Any school deaths from homicides?): 	DROP
   Order 136: C0308 (Any school shooting incidents?):		DROP
   Order 137: C0688_R (Number of arrests at school): 		DROP
   Order 138: C0690_R (Any hate crimes): BINARY (1=Y,2=N)   DROP

3. From order 139 - 147: 9 variables
   (C0374, C0376, C0378, C0380, C0381, C0382, C0383, C0384, C0386)
   These variables indicate the frequency of different types of problems occur at school 
   (bullying, sexual harassment, cyberbullying, verbal abuse, etc)
   They are ORDINAL variables with 5 levels: 
		1 = Happens daily; 			2 = Happens at least once a week ; 3 = Happens at least once a month 
		4 = Happens on occasion ; 	5 = Never happens 
   -> KEEP AS ORIGINAL (ORDINAL)
 
4. From order 148 - 150: 3 variables (C0389, C0391, C0393) with same 5 levels as above
   -> COMBINE (Cyberbullying)

5. From order 151 - 184: 34 variables (C0390 - C0456) to indicate the presence of different disciplinary actions at school 
   and whether they are used -> can be grouped into 17 pairs

   For each pair, the 1st question asks if a specific disciplinary action is present (1=Y, 2=N); and
                  the 2nd question asks if it is present (Y), is it used (1=Y, 2=N, -1=Legitimate skip)
   The number of obs for (2=N) in 1st question will be equal to the number of obs for (-1 = Legitimate skip) in 2nd question.
   (i.e., if the disciplinary action is NOT PRESENT at school, then the 2nd question will be not applicable, then the 
    2nd question can be SKIP)
-> First reverse the levels of the 2nd question in each pair: 1-> 2 and 2->1 (new levels: -1=Legitimate skip, 1=N, 2=Y)
   Then combine each pair together: 
-> 3 possible values:
            2 + (-1) = 1 (not present and thus skip)
   			1 + 1 = 2 (present and not used)
   			1 + 2 = 3 (present and used)
    -> 34 variables reduced to 17 new ORDINAL variables with 3 levels  

------------------------------------------------------------------------------------------------------------------------------

D. From Variable order 185 -> 229 (in Table B-1. Variable List)
1.	C0518 (# of removals with no service for disciplinary reason): DROP
    C0520 (# of transfers to specialized schools - total): DROP

2. C0526 - C0536: (5 NUMERIC Variables)
	These variables are percentages of students in different academic categories
	(limited english proficient, special education students, below 15th percentile standardized tests, 
     likely to go to college, students find academic achievement important)
	-> KEEP AS ORIGINAL

3. C0538	Typical number of classroom changes (NUMERIC) -> KEEP AS ORIGINAL

4. C0560	Crime level where students live (ORDINAL): KEEP AS ORIGINAL
   C0562	Crime level where school located (ORDINAL): KEEP AS ORIGINAL
   C0568	Average percent daily attendance (NUMERIC):  KEEP AS ORIGINAL

5. C0570	# of students transferred to school (NUMERIC): DROP
   C0572	# of students transferred from school (NUMERIC): DROP

6. 	C0578, C0578_DD, C0578_MM, C0578_YY, C0580 (survey filled dates)
    -> Not needed - gives no information about violent incidents
    -> DROP

7. 	CRISIS16 (# of types of crisis covered in written plans): KEEP

8.	DISTOT16 (Total number of disciplinary actions recorded)
    INCID16	(Total number of incidents recorded)
	INCPOL16 (Total number of incidents reported to police)
    OTHACT16 
    OUTSUS16
    PROBWK16
    REMOVL16
    STRATA (Collapsed STRATUM code)
    STUOFF16
	SVINC16	(Total number of serious violent incidents recorded)
	SVPOL16	(Total number of serious violent incidents reported to police)
    TRANSF16
	VIOPOL16 (Total number of violent incidents reported to police)
	DISFIRE16
    DISDRUG16
    DISWEAP16
    DISRUPT
    DISATT16
    DISALC16
	-> all similiar or correlated to Target -> DROP

9.	Order 216:	VIOINC16 (Total number of violent incidents recorded)
	-> TARGET
 
10. SEC_FT16 (Total # of full-time security guards, SROs, or sworn law enforcement officers)
	SEC_PT16 (Total # of part-time security guards, SROs, or sworn law enforcement officers)
	These variables indicate the number of security gards on duty based on full-time and part-time.
    -> KEEP AS ORIGINAL (NUMERIC)

11.	FR_URBAN (Urbanicity - Based on Urban-centric location of school) (NOMINAL)
	FR_LVEL	 (Grade Level of school) (NOMINAL)
	FR_SIZE	 (Size of school) (ORDINAL) 
	PERCWHT	 (Percent non-Hispanic White enrollment-categorical) (NOMINAL)
	-> KEEP AS ORIGINAL
*/


Data School.Subset;
   Set School.School_violence_dataset 
       (Drop= C0014_R C0016_R C0306 C0308 C0518 C0520 C0570 C0572 
              C0578 C0578_DD C0578_MM C0578_YY C0580 C0688_R C0690_R
			  DISTOT16 DISFIRE16 DISDRUG16 DISWEAP16 DISRUPT DISATT16 DISALC16
              INCID16 INCPOL16 OTHACT16 OUTSUS16 PROBWK16 REMOVL16
			  STRATA STUOFF16 SVINC16 SVPOL16 TRANSF16 VIOPOL16  FINALWGT REPFWT: IC:);

/*for binary variables convert 2-No to 0-No*/
array A(*) $ C0204 C0206 C0208 C021: C0662-C0672 C0265-C0277 ;
do i=1 to dim(A);
if A(i)=2 or A(i)=5 then A(i)=0;
end;

/*Reverse order of ordinal variables that have label starting with 'Efforts limited by' (C0280-C0304)
  and variables ending with 'limits mental health' (C0674-C0686): convert 1-Majorlimit to 3-No limit and vice versa. 
  Also, reverse order of ordinal valriables that have labels starting with 'Policies for sworn law enforcement officers'(C0652-C0660)
  convert 1-Yes to 3-Don't Know and vice versa*/
array B(*) $ C0280 C0282 C0284 C0286 C0288 C0290 C0292 C0294 C0296 C0298 C0300 C0302 C0304 
             C0674-C0686 C0652-C0660;
do i=1 to dim(B);
if B(i)=1 then B(i)=3;
else if B(i)=3 then B(i)=1;
end;

/*Reverse order of Yes-No variables that have label ending with 'Sworn law enforcements officers present/with/participate'
  and the variables that ask whether each disciplinary action is used at school among those from C0392-C0456
  -> convert 1-Yes to 2-No and vice versa*/
array C(*) $ C0612-C0646
             C0392 C0396 C0400 C0404 C0408 C0412 C0416 C0420 C0424 C0428 C0432 C0436 C0440 C0444 C0448 C0452 C0456;
do i=1 to dim(C);
if C(i)=1 then C(i)=2;
else if C(i)=2 then C(i)=1;
end;

    Access_Controlled = sum(C0112, C0114);
	Drug_Testing = sum(C0128, C0130);
	Written_Plans = sum(C0155, C0157, C0158, C0162, C0166, C0169, C0170, C0173);
	Drilled_Plans = sum(C0163, C0165, C0167);	
	Acceptance_Groups= sum(C0604, C0606, C0608);

	if C0196=5 then C0196=0;
	if C0198=5 then C0198=0;
	if C0200=5 then C0200=0;
	if C0202=5 then C0202=0;
	Parent_participation= sum(of C0196-C0202)/4;

    Community_Involvement = sum(of C0204-C0218)/8;

	Law_Enforcement_Presence_1= C0610+C0612;
	Law_Enforcement_Presence_2= C0610+C0614;
	Law_Enforcement_Presence_3= C0610+C0616;
	Law_Enforcement_Presence_4= C0610+C0618;
	Law_Enforcement_Presence_5= C0610+C0648;
	Law_Enforcement_Presence = sum(of Law_Enforcement_Presence:)/5;

	Law_Enforcement_Equipped_1 = C0610+C0620;
	Law_Enforcement_Equipped_2 = C0610+C0622;
	Law_Enforcement_Equipped_3 = C0610+C0624;
	Law_Enforcement_Equipped_4 = C0610+C0626;
	Law_Enforcement_Equipped = sum(of Law_Enforcement_Equipped:)/4;

	Law_Enforcement_Participation_1 = C0610+C0628;
	Law_Enforcement_Participation_2 = C0610+C0630;
	Law_Enforcement_Participation_3 = C0610+C0632;
	Law_Enforcement_Participation_4 = C0610+C0634;
	Law_Enforcement_Participation_5 = C0610+C0636;
	Law_Enforcement_Participation_6 = C0610+C0638;
	Law_Enforcement_Participation_7 = C0610+C0640;
	Law_Enforcement_Participation_8 = C0610+C0642;
	Law_Enforcement_Participation_9 = C0610+C0644;
	Law_Enforcement_Participation_10 = C0610+C0646;
	Law_Enforcement_Participation = sum(of Law_Enforcement_Participation:)/10;

	Law_Enforcement_Policies_1= C0610+C0650+C0652;
	Law_Enforcement_Policies_2= C0610+C0650+C0654;
	Law_Enforcement_Policies_3= C0610+C0650+C0656;
	Law_Enforcement_Policies_4= C0610+C0650+C0658;
	Law_Enforcement_Policies_5= C0610+C0650+C0660;
	Law_Enforcement_Policies = sum(of Law_Enforcement_Policies:)/5;

	Mental_Health_Assessment = sum(of C0662-C0666)/3;
	Mental_Health_Treatment = sum(of C0668-C0672)/3;
	Mental_Health_Efforts_Limits = sum(of C0674-C0686)/7;

	Teacher_Training = sum(of C0265-C0277)/12;
	Limitation_school_effort= sum(of C0280-C0304)/13;
	Disruption_level= sum(of C0374-C0386)/9;
	Cyberbullying= sum(C0389, C0391, C0393)/3;

   	Removal_No_Services = sum(C0390, C0392);
	Removal_Tutoring = sum(C0394, C0396);
	Transfer_Specialize = sum(C0398, C0400);
	Transfer_Regular = sum(C0402, C0404);
	Outside_Suspend_No_Services = sum(C0406, C0408);
	Outside_Suspend_With_Services = sum(C0410, C0412);
	Inside_Suspend_No_Services = sum(C0414, C0416);
	Inside_Suspend_With_Services = sum(C0418, C0420);
    Referral_School_Counselor  = sum(C0422, C0424);
	Inside_Disciplinary_Plan = sum(C0426, C0428);
    Outside_Disciplinary_Plan = sum(C0430, C0432);
	BusPrivilege_Loss_Misbehavior = sum(C0434, C0436);
	Corporal_Punishment = sum(C0438, C0440);
	School_Probation = sum(C0442, C0444);
	Detention_Saturday_School = sum(C0446, C0448);
	Student_Privileges_Loss = sum(C0450, C0452);
	Require_Community_Service = sum(C0454, C0456);
	
	If VIOINC16 = 0 then VIOINC=0;
    Else VIOINC=1;

Drop C0112-C0114 C0128-C0130 C0155-C0173 C0196-C0218
     C0265-C0277 C0280-C0304 C0374-C0386 C0389-C0456 C0604-C0686 
     Law_Enforcement_Presence_: Law_Enforcement_Equipped_: Law_Enforcement_Participation_: Law_Enforcement_Policies_:
	 i
run;


Proc contents data=School.Subset;
run;
/*91 variables (original: 476 variables) */

Proc print data=School.Subset (obs=50);
run;

   
/* Data partition 75%-25% */
data temp;
set School.Subset;
n=ranuni(8);

proc sort data=temp;
  by n;

data school.train school.test;
   set temp nobs=nobs;
   if _n_<=.75*nobs then output school.train;
   else output school.test;
run;
/*Train = 1569 obs; Test = 523 obs*/

/* Oversampling using proc surveyselect  */
proc sort data=school.train;
by VIOINC;

proc surveyselect data=school.train(where=(VIOINC=0)) out=school.train_os N=1569 method=urs outhits;
run;

/* Creating the final training dataset */
proc append base=school.train  data=school.train_os force nowarn;
run;



%let categorical = C0110 C0116
C0120
C0121
C0122
C0124
C0126
C0134
C0136
C0138
C0139
C0140
C0141
C0142
C0143
C0144
C0146
C0148
C0150
C0151
C0153
C0174
C0175
C0176
C0177
C0178
C0179
C0180
C0181
C0182
C0183
C0186
C0190
C0192
C0194

C0600 
FRLEVEL
PERWHT
Acceptance_Groups
Access_Controlled
BusPrivilege_Loss_Misbehavior
C0389 C0391 C0393
C0602

Corporal_Punishment
Detention_Saturday_School
Drilled_Plans
Drug_Testing
FR_SIZE
FR_URBAN
Inside_Disciplinary_Plan
Inside_Suspend_No_Services
Inside_Suspend_With_Services
Outside_Disciplinary_Plan
Outside_Suspend_No_Services
Outside_Suspend_With_Services
Referral_School_Counselor
Removal_No_Services
Removal_Tutoring
Require_Community_Service
School_Probation
Student_Privileges_Loss
Transfer_Regular
Transfer_Specialize
Written_Plans
paren_participation;
%let numer= 


C0526
C0528
C0532
C0534
C0536

C0560
C0562
C0568


CRISIS16
Community_Involvement
Law_Enforcement_Equipped
Law_Enforcement_Participation
Law_Enforcement_Policies
Law_Enforcement_Presence
Mental_Health_Assessment
Mental_Health_Efforts_Limits
Mental_Health_Treatment

SEC_FT16
SEC_PT16
Teacher_Training
Disruption_level
Limitation_school_effort
;

/*proc varclus data=school.X2 centroid;
var &categorical &numer;
run;*/
/* attempted count models */
proc genmod data = school.X3 ;
  class &categorical
/param=glm;
  model VIOINC16 = &numer &categorical /dist=negbin type3 Scale=deviance;
  output out=school.pois1 predicted=pred resdev=res ;
  store p1;
run;

proc sgplot data = school.pois1;
  scatter x=VIOINC16 y=pred;
run;

proc genmod data = school.X2 ;
  class &categorical
/param=glm;
  model VIOINC16 = &numer &categorical /dist=zinb type3 scale=deviance;
  zeromodel C0138 C0143 C0153 C0198 Limitation_school_effort Cyberbullying Disruption_level C0688_R C0374 C0520 C0538 Sec_Ft16 Fr_size Community_involvement Law_Enforcement_Presence Law_Enforcement_Equipped Law_Enforcement_Participation Law_enforcement_policies Transfer_Specialize Outside_disciplinary_plan School_probation frlevel;
  output out=school.pois3 predicted=pred resdev=res ;
  store p2;
run;

proc sgplot data = school.pois3;
  scatter x=VIOINC16 y=pred;
run;

proc hpgenselect alpha=0.05 noclprint nostderr data= school.X3; 
class &categorical;
model VIOINC16 = &numer &categorical /dist=zinb;
selection method=stepwise details=all;
id schid;
output out=school.pois4 predicted=pred xbeta ;
run;

proc sgplot data = school.pois4;
  scatter x=VIOINC16 y=pred;
run;
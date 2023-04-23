
Proc Import Out = heart 
			datafile = "/home/u60718448/sasuser.v94/heart.csv" 
			DBMS= CSV  
			replace;	
    		Getnames = yes;
run;

*data where exercised induced angina, chest pain type, high fasting blood sugar, and resting ecg translated into words;  
data heartcleaned;
set heart;
length gender $ 6.0 ExerciseInducedAng $ 3.0 ChestPainType $ 12.0 HighFBS $ 5.0 RestingECG $ 10.0;
if sex = 1 then gender = "Male";
if sex = 0 then gender = "Female";

if exng = 1 then ExerciseInducedAng = "Yes";
if exng = 0 then ExerciseInducedAng = "No";

if cp = 0 then ChestPainType = "Typical";
if cp = 1 then ChestPainType = "Atypical";
if cp = 2 then ChestPainType = "Non-Anginal";
if cp = 3 then ChestPainType = "Asymptomatic";

if fbs = 1 then HighFBS = "True";
if fbs = 0 then HighFBS = "False";

if restecg = 0 then RestingECG = "Normal";
if restecg = 1 then RestingECG = "Abnormal";
if restecg = 2 then RestingECG = "Hypertophic";
run;

*
Age : Age of the patient
Sex : Sex of the patient
exang: exercise induced angina (1 = yes, 0 = no)
ca: number of major vessels (0-3)
cp : Chest Pain type chest pain type
	Value 1: typical angina
	Value 2: atypical angina
	Value 3: non-anginal pain
	Value 4: asymptomatic
trtbps : resting blood pressure (in mm Hg)
chol : cholestoral in mg/dl fetched via BMI sensor
fbs : (fasting blood sugar > 120 mg/dl) (1 = true, 0 = false)
rest_ecg : resting electrocardiographic results
	Value 0: normal
	Value 1: having ST-T wave abnormality (T wave inversions and/or ST elevation or depression of > 0.05 mV)
	Value 2: showing probable or definite left ventricular hypertrophy by Estes' criteria
thalach : maximum heart rate achieved
target/output : 0= less chance of heart attack 1= more chance of heart attack
;


*data sorted by age, ascending;
proc sort data = heartcleaned;
by age;
run;

*data where chance of heart attack is high (output = 1);
data heartattack;
set heartcleaned;
where output = 1;
run;

*data where chance of heart attack is low (output = 0);
data noheartattack;
set heartcleaned;
where output = 0;
run;



*find the mean resting bps and mean cholesterol level of those with high and low chance of heart attack;
	*by gender;
proc means data = heartattack;
title "Mean Resting BPS and Cholesterol of those with high chance of Heart attack by gender";
class gender;
var trtbps chol;
run;
*95% C.I of resting heart rate of individuals with high chance of heart attack;
Proc Means data = heartattack clm;
Var trtbps;
Run;
*distribution of resting heart rate of individuals with high chance of heart;
proc univariate data = heartattack noprint;
title "Histogram";
histogram trtbps / normal;
run;
*95% C.I of cholestrol of individuals with high chance of heart attack;
Proc Means data = heartattack clm;
Var chol;
Run;
*distribution of cholosterol of individuals with high chance of heart;
proc univariate data = heartattack noprint;
title "Histogram";
histogram chol / normal;
run;



proc means data = noheartattack;
title "Mean Resting BPS and Cholesterol of those with low chance of Heart attack by gender";
class gender;
var trtbps chol;
run;
*95% C.I of resting heart rate of individuals with low chance of heart attack;
Proc Means data = noheartattack clm;
Var trtbps;
Run;
*distribution of resting heart rate of individuals with low chance of heart;
proc univariate data = noheartattack noprint;
title "Histogram";
histogram trtbps / normal;
run;
*95% C.I of cholestrol of individuals with low chance of heart attack;
Proc Means data = noheartattack clm;
Var chol;
Run;
*distribution of cholosterol of individuals with low chance of heart;
proc univariate data = noheartattack noprint;
title "Histogram";
histogram chol / normal;
run;










*scatter plot of resting heart rate on age;
Proc gplot data = heartcleaned;
title "scatter plot of resting heart rate on age";
plot trtbps*age ;
run;

*scatter plot cholesterol on age of individuals with high chance of heart attack;
symbol value = diamondfilled color = blueviolet;
proc gplot data = heartattack;
title "scatter plot of cholesterol on age (individuals with high chance of heart attack)";
plot chol*age;
run;

*scatter plot cholesterol on age of individuals with low chance of heart attack;
symbol value = diamondfilled color = blueviolet;
proc gplot data = noheartattack;
title "scatter plot of cholesterol on age (individuals with low chance of heart attack)";
plot chol*age;
run;










*frequency tables;
proc sort data = heartattack;
by gender;

*frequency of individuals with high chance of heart attack based chest pain type;
proc freq data = heartattack;
by gender;
table chestpaintype;
run;
proc gchart data = heartattack;
by gender;
vbar chestpaintype;
run;

*frequency of individuals with high chance of heart attack based on if
	their fasting blood sugar was greater than 120 mg/dl;
proc freq data = heartattack;
by gender;
table highfbs;
run;
proc gchart data = heartattack;
by gender;
vbar highfbs;
run;

*frequency of individuals with high chance of heart attack based on 
	resting electrocardiographic results;
proc freq data = heartattack;
by gender;
table restingecg;
run;
proc gchart data = heartattack;
by gender;
vbar restingecg;
run;



Proc Import Out = heart 
			datafile = "/home/u60718448/sasuser.v94/heart.csv" 
			DBMS= CSV  
			replace;	
    		Getnames = yes;
run;

data heartcleaned;
set heart;
length gender $ 6.0 ExerciseInducedAng $ 3.0 ChestPainType $ 12.0 HighFBS $ 5.0 RestingECG $ 10.0;
if sex = 1 then gender = "Male";
if sex = 0 then gender = "Female";

if cp = 0 then ChestPainType = "Typical";
if cp = 1 then ChestPainType = "Atypical";
if cp = 2 then ChestPainType = "Non-Anginal";
if cp = 3 then ChestPainType = "Asymptomatic";

if fbs = 1 then HighFBS = "True";
if fbs = 0 then HighFBS = "False";

run;


*visualize the distribution of each categorical variable in our dataset;
title "Analysis of Sex";
proc sgplot data=heartcleaned;
vbar gender / group= output stat=percent missing;
label gender = "Sex";
run;
title "Analysis of Chest Pain";
proc sgplot data=heartcleaned;
vbar ChestPainType / group= output stat=percent missing;
label ChestPainType = "Chest Pain";
run;
title "Analysis of High Fasting Blood Sugar";
proc sgplot data=heartcleaned;
vbar highfbs / group= output stat=percent missing;
label highfbs = "High Fasting Blood Sugar";
run;



*scatter plot of our numerical varaibles on output, check to see if there is 
	complete separation between output and out numerical variables of interest;
proc gplot data = heart;
title "Plot of Age on Output";
plot output*age;
run;
proc gplot data = heart;
title "Plot of Age on Resting Blood Pressure";
plot output*trtbps;
run;
proc gplot data = heart;
title "Plot of Age on Cholesterol Level";
plot output*chol;
run;
proc gplot data = heart;
title "Plot of Age on Maximum Heart Rate Achieved";
plot output*thalachh;
run;
*No complete seperation detected;




*frequency of each categorical data in our dataset;
proc sort data = heartcleaned;
by output;
run;
proc freq data = heartcleaned;
title "Frequency of Categorical Variables in our Dataset";
table output*(gender ChestPainType highfbs output);
run;



*analyze the mean values of numerical variables;
proc sort data = heart;
by output;
run;
proc means data = heart ;
by output;
title "Mean Values of Age, Resting Blood Pressure, Cholesterol Level, and Maximum Heart Rate Achieved by Output";
var age trtbps chol thalachh;
run;





*Building our first model;
proc logistic data = heart plots(only)=roc;
model output = age cp trtbps chol fbs thalachh;
run;
*removed age, chol, and fbs because the p-valued were not statistically significant at alpha = 0.05.

Create new model with variables that are statistically significant and run a stepwise selection;
proc logistic data = heart plots(only)=roc;
model output = cp trtbps thalachh / selection = stepwise;
run;



*Building a full model and repeating the process;
proc logistic data = heart plots(only)=roc;
model output = age trtbps chol thalachh oldpeak cp fbs restecg exng slp caa thall;
run;
*removed Age, trtbps, chol, fbs, restecg, slp;
proc logistic data = heart plots(only)=roc;
model output = thalachh oldpeak cp exng caa thall / selection = stepwise;
run;





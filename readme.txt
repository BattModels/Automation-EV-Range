----------------------------------------
GENERAL INFORMATION
----------------------------------------

1. Title of Dataset:  Tradeoffs between automation and light vehicle electrification

2. Author Information

Author Contact Information
    Name: Aniruddh Mohan
    Institution: Carnegie Mellon University
    Address: 5000 Forbes Avenue, Pittsburgh, Pennsylvania, USA, 15213
    Email: aniruddh@cmu.edu

Author Contact Information
    Name: Shashank Sripad
    Institution: Carnegie Mellon University
    Address: 5000 Forbes Avenue, Pittsburgh, Pennsylvania, USA, 15213
    Email: ssripad@cmu.edu

Author Contact Information 
    Name: Parth Vaishnav 
    Institution: Carnegie Mellon University
    Address: 5000 Forbes Avenue, Pittsburgh, Pennsylvania, USA, 15213
    Email: parthv@cmu.edu

Author Contact Information 
    Name: Venkat Viswanathan 
    Institution: Carnegie Mellon University
    Address: 5000 Forbes Avenue, Pittsburgh, Pennsylvania, USA, 15213
    Email: venkvis@cmu.edu

---------------------------------------
DATA & FILE OVERVIEW
---------------------------------------

Directory of Files:

   A. Filename:  EPA_LA92cycle.csv
   
      Short description:  This CSV file contains the velocity profile data for the composite cycle and is required to run the Monte Carlo code provided.


   B. Filename:  udds.csv
   
      Short description:  This CSV file contains the velocity profile data for the city cycle and is required to run the Monte Carlo code provided.  


        
   C. Filename:  montecarlorange.m 
   
      Short description: This .m file contains the code for the Monte Carlo simulations for the impact of automation on EV range for the Tesla Model 3 as presented in the paper. 


----------------------------------------------------------------------------------------------------------
DATA DESCRIPTION FOR: EPA_LA92cycle.csv
----------------------------------------------------------------------------------------------------------

1. Number of variables: 2


2. Number of cases/rows:1436


3. Variable List

    A. Name: Time  
	
       Description: Denotes the time in seconds.

    B. Name: Velocity  
	
       Description: Denotes the velocity in m/s.
					
					
--------------------------------------------------------------------------------------------------------------
DATA DESCRIPTION FOR: udds.csv
--------------------------------------------------------------------------------------------------------------

1. Number of variables: 2


2. Number of cases/rows: 1373


3. Variable List

    A. Name: Time  
	
       Description: Denotes the time in seconds.

    B. Name: Velocity  
	
       Description: Denotes the velocity in miles/hour.

-------------------------------------------------------
METHODOLOGICAL INFORMATION
-------------------------------------------------------

1. Software-specific information:

Name: Microsoft Excel
Version: 2016 
System Requirements: Windows or macOS
Open Source? (Y/N):  N

Additional Notes: The data were initially entered into Microsoft Excel and can be input into Excel. However, for stability and access, the files have been saved in CSV format and can be viewed and analyzed across all operating systems, including Linux. 

Name: MATLAB
Version: 2019 
System Requirements: Windows or macOS
Open Source? (Y/N):  N

Additional Notes: MATLAB or Octave can both run the Monte Carlo code provided. 

3. Date of data collection: 20181001 - 20190801

--------------------------------------------------
NOTES ON REPRODUCIBILITY 
--------------------------------------------------

The results of the Monte Carlo analysis presented in the paper can be reproduced by running the Monte Carlo code provided in MATLAB/Octave. Simply save the velocity profiles in the same directory as the provided code and run the code in MATLAB/Octave. On a MacBook Air the simulations take roughly 30 minutes to complete in MATLAB.


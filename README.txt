uiAFM

Authors
Lukas Kain
Orestis G. Andriotis

Year 2017
This project is licensed under the terms of the GNU General Public License v3.0.

1. Open MATLAB and go to the working directory 
where the .m files are saved

2. In the MATLAB command window type 'mainscript'
(without the apostrophes) and press Enter

3. In the pop-up window, navigate and go to the 
file directory where the force curves are saved 

4. In the pop-up window, input the variables: 
a. indenter radius (integer) 
b. reference slope (integer) taken on glass slide
[1+/-0.1 from calibration force curves recorded 
on a stiff substrate eg. glass, mica]
c. the Poisson’s ratio of the sample (integer) 
d. filename (structure)
e. type ‘Y’ or ‘N’ (without the apostrophes, structure) 
for whether a holding time was applied or not, respectively 

and press ‘OK’

5. Review and select the force curves for further analysis. 
In the pop-up window you will be able to review all the force 
curves and in a second pop-up window select ‘Yes’ or ‘No’ for 
whether to include or exclude the force curve in the analysis. 
If ‘Yes’ then the axes are coloured blue and if ‘No’ then the 
axes are coloured red. The user need to justify the reason why
a force curve has been discarded from analysis (i.e. contact point
has been wrongly defined etc.) 

6. Type the size of the figures in centimeters to be archived.
These are figures of force curves for post-process reviewing

7. Type the portion of the upper part of the unloading curve to 
be analysed with least-squares linear fit to calculate the DZ 
slope. Usually 0.25, i.e. 25% of the curve, is selected. 

8. The user is finally asked to select the desirable units 
(kPa, MPa or GPa) of the elastic modulus

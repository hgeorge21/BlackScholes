BlackScholes

A course project in CSC446 Numerical Methods for PDE UofT Winter 2019

Implemented in Matlab.
The following programs are contained here

=============================================
## Euporean Options
=============================================
- BS_eur_impl_fd.m  European options implemented with implicit FD
- BS_eur_cn.m       European options implemented with Crank-Nicolson FD
- BS_eur_cn_sor.m   European options with Crank-Nicolson and SOR method
- BS_eur_actual.m   European options with explicit formula
- BS_eur_spread.m   European options with bullish vertical spread
- eur.c             European options with CN & SOR in C with -O2 opt.

=============================================
## American Options
=============================================
- BS_am_cn.m        American options implemented with Crank-Nicolson FD
- BS_am_cn_psor.m   American options with Crank-Nicolson and PSOR method

=============================================
## Additional Functions
=============================================
- SOR.m             SOR method for European options
- PSOR.m            PSOR method for American options
- graph_surface.m   Generates surface given a [X,Y] mesh

=============================================
## Scripts
=============================================
- scriptEurPayoff.m Creates payoff diagrams for Eur. options (has spread)
- scriptEurMeth.m   Compares European option with CN using A\b and SOR
- scriptEurComp.m   Creates table for comparison between implicit and CN
- scriptEurAm.m     Compares European option and American option 
- scriptAmPayoff    Creates payoff diagrams for American options
- scriptAmComp.m    Compares American options using SOR and without


INSTRUCTIONS
=================================================================
1. scripts can be run directly and graphs will be generated.
2. Note that scriptEurPayoff can uncomment BS_eur_spread to run the bullish
    vertical spread program
3. main.m is script that will run ALL programs and should use publish
    option to view all diagrams and data that are presented in report
    Can easily modified to view other possible data configuration
4. eur.c can be compiled and run will the following
        gcc -o eur -O2 eur.c
        ./eur
5. All scripts and programs (including eur.c) have predefined values
    already which can be easily changed


Comments and Further Possible Improvements
================================================================
- I was not entirely sure about American call option since there was little
    information found on the internet. From what I could gather, it was
    apparently that on no divident-paying basis, the American call option 
    is no diferrent from European option since it's better to hold it until
    maturity.
- The bullish vertical spread seems slightly off compared to the values
    (the graph) that is presented in the book as well as the theorectical
    values found on internet (e.g. at S=E, V=A/2)
- I figured that it may be have been a good idea to investigate the option
    delta a little bit after reading many literatures that make reference
    to it. However, time was running out so it was not possible to do that.
    



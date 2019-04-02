# BlackScholes
A course project in CSC446 Numerical Methods for PDE UofT Winter 2019

Implemented in Matlab.
The following programs are contained here

=============================================
## Euporean Options
=============================================
- BS_eur_impl_fd.m European options implemented with implicit FD
- BS_eur_cn.m      European options implemented with Crank-Nicolson FD
- BS_eur_cn_sor.m  European options with Crank-Nicolson and SOR method
- BS_eur_actual.m  European options with explicit formula

=============================================
## American Options
=============================================
- BS_am_cn.m       American options implemented with Crank-Nicolson FD
- BS_am_cn_psor.m  American options with Crank-Nicolson and PSOR method

=============================================
## Scripts
=============================================
- scriptEurPayoff.m Creates payoff diagrams for European options
- scriptEurComp.m   Creates table for comparison between implicit and CN
- scriptEurAm.m     Compares European option and American option 
- scriptAmPayoff    Creates payoff diagrams for American options
- scriptAmComp.m    Compares American options using SOR and without
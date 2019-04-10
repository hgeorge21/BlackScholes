format compact
a = 0;  b = 50;
sigma = 0.40;
E = 10; T = 1;
r = 0.1;
ns = 599; nt = 599;
type = "put";

values_eu = BS_eur_cn(a, b, E, r, sigma, T, type, ns, nt);
values_am = BS_am_cn(a, b, E, r, sigma, T, type, ns, nt);

num_tests = {2,4,6,8,10,12,14,16};

disp('Asset  Payoff  3m  Amer.      Euro.     6m  Amer.      Euro.');
for i = 1:length(num_tests)
    si = fix(num_tests{i} / (b-a) * (ns+1));
    ti3 = fix(0.75 / T * (nt+1));
    ti6 = fix(0.5 / T * (nt+1));

    eu3 = values_eu((ti3-2) * ns + si);
    am3 = values_am((ti3-2) * ns + si);
    
    eu6 = values_eu((ti6-2) * ns + si);
    am6 = values_am((ti6-2) * ns + si);

    fprintf('%4d   %4.2f        %8.6f   %8.6f      %8.6f   %8.6f \n', ...
                num_tests{i}, max(10-num_tests{i},0), am3, eu3, am6, eu6);
end
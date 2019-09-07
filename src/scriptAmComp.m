format compact
a = 0;  b = 50;
sigma = 0.40;
E = 10; T = 1;
r = 0.1;
ns = 599; nt = 599;
type = "put";

values_cn   = BS_am_cn(a, b, E, r, sigma, T, type, ns, nt, 0);
values_psor = BS_am_PSOR(a, b, E, r, sigma, T, type, ns, nt, 0);

num_tests = {2,4,6,8,10,12,14,16};
actual = {8, 6, 4, 2.0951, 0.9211, 0.3622, 0.1320, 0.0460};

disp("Price(S)  Book      Matlab                      PSOR");
for i = 1:length(num_tests)
    si = fix(num_tests{i} / (b-a) * (ns+1));
    ti = fix(0.5 / T * (nt+1));

    cn = values_cn((ti-2) * ns + si);
    psor = values_psor((ti-2) * ns + si);

    fprintf("%4d      %5.4f    %10.9f   %8.6e  %10.9f   %8.6e \n", ...
                num_tests{i}, actual{i}, cn, abs(actual{i}-cn), psor, ...
                abs(actual{i}-psor));
end
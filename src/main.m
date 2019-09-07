%% main.m
% runs all scripts using step-size 1/600
ns = 599; nt = 599;

r   = 0.1; sig = 0.2;
E   = 1;   T   = 2;
a = 0; b = 2;
ts  = {0.5, 1.0, 1.5, 2.0};

%% Eur. Call Options with surface and payoff diagrams impl. FD
type = "call";
values_im = BS_eur_impl_fd(a, b, E, r, sig, T, type, ns, nt);

plots = zeros(ns, 4);
for i = 1:4
    ti = fix(ts{i} / T * (nt+1));
    plots(: ,i) = values_im((ti-2)*ns+1 : (ti-1)*ns);
end

s = b/ns:b/ns:b;
figure
p1 = plot(s, plots(:,1)', 'LineWidth', 2); hold on
p2 = plot(s, plots(:,2)', 'LineWidth', 2); hold on
p3 = plot(s, plots(:,3)', 'LineWidth', 2); hold on
p4 = plot(s, plots(:,4)', 'LineWidth', 2);
legend([p1,p2,p3,p4], "T-t=1.5", "T-t=1.0", "T-t=0.5", "T-t=0");
ylabel('V'); xlabel('S');
title('Payoff Diagram at Various Times of Call Option');


%% Eur. Put Options with surface and payoff diagrams impl. FD
type = "put"; 
figure
values_im = BS_eur_impl_fd(a, b, E, r, sig, T, type, ns, nt);

plots = zeros(ns, 4);
for i = 1:4
    ti = fix(ts{i} / T * (nt+1));
    plots(: ,i) = values_im((ti-2)*ns+1 : (ti-1)*ns);
end

s = b/ns:b/ns:b;
figure
p1 = plot(s, plots(:,1)', 'LineWidth', 2); hold on
p2 = plot(s, plots(:,2)', 'LineWidth', 2); hold on
p3 = plot(s, plots(:,3)', 'LineWidth', 2); hold on
p4 = plot(s, plots(:,4)', 'LineWidth', 2);
legend([p1,p2,p3,p4], "T-t=1.5", "T-t=1.0", "T-t=0.5", "T-t=0");
ylabel('V'); xlabel('S');
title('Payoff Diagram at Various Times of Put Option');


%% Compare Eur Call Option Methods (Impl. FD vs Crank-Nicolson accuracy)
% Note that 0 <= S <= 50 is omitted here
a = 0;  b = 20;
E = 10; T = 1;
sigma = 0.20; r = 0.05; type = "put";
figure("visible", "off")
values_im = BS_eur_impl_fd(a, b, E, r, sig, T, type, ns, nt);
figure("visible", "off")
values_cn = BS_eur_cn(a, b, E, r, sigma, T, type, ns, nt);
num_tests = {2,4,6,7,8,9,10,11,12,13,14,15,16};

disp("Price(S)  Actual     Crank-N.   Error          Impl. FD   Error");
for i = 1:length(num_tests)
    si = fix(num_tests{i} / (b-a) * (ns+1));
    ti = fix(0.5 / T * (nt+1));

    cn = values_cn((ti-2) * ns + si);
    im = values_im((ti-2) * ns + si);
    actual = BS_eur_actual(num_tests{i}, E, r, sigma, T, 0.5, type);

    fprintf("%4d      %8.6f   %8.6f   %8.6e   %8.6f   %8.6e \n", ...
                num_tests{i}, actual, cn, abs(actual-cn), im, ...
                abs(actual-im));
end


%% Comparing European Call Option Solved using A\b and SOR
% Note: we use 0 <= S <= 20 here which is slightly different from report
type = "put";
figure("visible", "off");
values_sor = BS_eur_SOR(a, b, E, r, sigma, T, type, ns, nt);
num_tests = {2,4,6,7,8,9,10,11,12,13,14,15,16};

disp("Price(S)  Actual     Crank-N.   Error          SOR        Error");
for i = 1:length(num_tests)
    si = fix(num_tests{i} / (b-a) * (ns+1));
    ti = fix(0.5 / T * (nt+1));

    cn = values_cn((ti-2) * ns + si);
    sor = values_sor((ti-2) * ns + si);
    actual = BS_eur_actual(num_tests{i}, E, r, sigma, T, 0.5, type);

    fprintf("%4d      %8.6f   %8.6f   %8.6e   %8.6f   %8.6e \n", ...
                num_tests{i}, actual, cn, abs(actual-cn), sor, ...
                abs(actual-sor));
end


%% Compares the American and European Payoffs for both Call and Put Options
clear values_sor;
r = 0.1; sig = 0.2;
E = 1;   T   = 2;
a = 0; b = 2;
type = "put";
figure("visible", "off");
values_cn = BS_eur_cn(a, b, E, r, sigma, T, type, ns, nt);
figure("visible", "off");
values_am = BS_am_cn(a, b, E, r, sig, T, type, ns, nt, 0);
plots = zeros(ns, 1);
plots(:, 1) = values_cn(1 : ns);
plots(:, 2) = values_am(1 : ns);

s = b/ns:b/ns:b;
figure
p1 = plot(s, plots(:,1)', 'LineWidth', 2); hold on
p2 = plot(s, plots(:,2)', 'LineWidth', 2);
legend([p1,p2], "European Option", "American Option");
ylabel('V'); xlabel('S');
title('Payoff Diagram of European vs American of Put Option');

type = "call";
figure("visible", "off");
values_cn = BS_eur_cn(a, b, E, r, sigma, T, type, ns, nt);
figure("visible", "off");
values_am = BS_am_cn(a, b, E, r, sig, T, type, ns, nt, 0);
plots = zeros(ns, 1);
plots(:, 1) = values_cn(1 : ns);
plots(:, 2) = values_am(1 : ns);

s = b/ns:b/ns:b;
figure
p1 = plot(s, plots(:,1)', 'LineWidth', 2); hold on
p2 = plot(s, plots(:,2)', 'LineWidth', 2);
legend([p1,p2], "European Option", "American Option");
ylabel('V'); xlabel('S');
title('Payoff Diagram of European vs American of Call Option');


%% Compares American and European Put Options Values
a = 0;  b = 50;
sigma = 0.40;
E = 10; T = 1;
r = 0.1;
type = "put";
figure("visible", "off")
values_cn = BS_eur_cn(a, b, E, r, sigma, T, type, ns, nt);
figure("visible", "off")
values_am = BS_am_cn(a, b, E, r, sigma, T, type, ns, nt, 0);
num_tests = {2,4,6,8,10,12,14,16};

disp('Asset  Payoff  3m  Amer.      Euro.     6m  Amer.      Euro.');
for i = 1:length(num_tests)
    si = fix(num_tests{i} / (b-a) * (ns+1));
    ti3 = fix(0.75 / T * (nt+1));
    ti6 = fix(0.5 / T * (nt+1));

    eu3 = values_cn((ti3-2) * ns + si);
    am3 = values_am((ti3-2) * ns + si);
    
    eu6 = values_cn((ti6-2) * ns + si);
    am6 = values_am((ti6-2) * ns + si);

    fprintf('%4d   %4.2f        %8.6f   %8.6f      %8.6f   %8.6f \n', ...
                num_tests{i}, max(10-num_tests{i},0), am3, eu3, am6, eu6);
end


%% American Option Payoffs Call and Put
% Comparison between A\b and PSOR is omitted
r   = 0.1; sig = 0.2;
E   = 1; T   = 2;
a = 0; b = 2;
s = b/ns:b/ns:b;

type= "put";
figure("visible", "off")
values_am = BS_am_cn(a, b, E, r, sig, T, type, ns, nt, 0);

plots = zeros(ns, 4);
for i = 1:4
    ti = fix(ts{i} / T * (nt+1));
    plots(: ,i) = values_am((ti-2)*ns+1 : (ti-1)*ns);
end

figure
p1 = plot(s, plots(:,1)', 'LineWidth', 2); hold on
p2 = plot(s, plots(:,2)', 'LineWidth', 2); hold on
p3 = plot(s, plots(:,3)', 'LineWidth', 2); hold on
p4 = plot(s, plots(:,4)', 'LineWidth', 2);
legend([p1,p2,p3,p4], "T-t=1.5", "T-t=1.0", "T-t=0.5", "T-t=0");
ylabel('V'); xlabel('S');
title('Payoff Diagram at Various Times of Put Option');

type= "call";
figure("visible", "off")
values_am = BS_am_cn(a, b, E, r, sig, T, type, ns, nt, 0.05);

plots = zeros(ns, 4);
for i = 1:4
    ti = fix(ts{i} / T * (nt+1));
    plots(: ,i) = values_am((ti-2)*ns+1 : (ti-1)*ns);
end

figure
p1 = plot(s, plots(:,1)', 'LineWidth', 2); hold on
p2 = plot(s, plots(:,2)', 'LineWidth', 2); hold on
p3 = plot(s, plots(:,3)', 'LineWidth', 2); hold on
p4 = plot(s, plots(:,4)', 'LineWidth', 2);
legend([p1,p2,p3,p4], "T-t=1.5", "T-t=1.0", "T-t=0.5", "T-t=0");
ylabel('V'); xlabel('S');
title('Payoff Diagram at Various Times of Call Option');


%% European Bullish Vertical Call Spread
r  = 0.1; sig = 0.2;
E1 = 1; E2 = 1.5; T = 2;
a = 0; b = 2;
type= "call";
figure
values = BS_eur_spread(a, b, E1, E2, r, sig, T, type, ns, nt);

plots = zeros(ns, 4);
for i = 1:4
    ti = fix(ts{i} / T * (nt+1));
    plots(: ,i) = values((ti-2)*ns+1 : (ti-1)*ns);
end

figure
p1 = plot(s, plots(:,1)', 'LineWidth', 2); hold on
p2 = plot(s, plots(:,2)', 'LineWidth', 2); hold on
p3 = plot(s, plots(:,3)', 'LineWidth', 2); hold on
p4 = plot(s, plots(:,4)', 'LineWidth', 2);
legend([p1,p2,p3,p4], "T-t=1.5", "T-t=1.0", "T-t=0.5", "T-t=0");
ylabel('V'); xlabel('S');
title('Payoff Diagram at Various Times of Call Option');


%% European Bullish Vertical Put Spread
r  = 0.1; sig = 0.2;
E1 = 1; E2 = 1.5; T = 2;
a = 0; b = 2;
type= "put";
figure
values = BS_eur_spread(a, b, E1, E2, r, sig, T, type, ns, nt);

plots = zeros(ns, 4);
for i = 1:4
    ti = fix(ts{i} / T * (nt+1));
    plots(: ,i) = values((ti-2)*ns+1 : (ti-1)*ns);
end

figure
p1 = plot(s, plots(:,1)', 'LineWidth', 2); hold on
p2 = plot(s, plots(:,2)', 'LineWidth', 2); hold on
p3 = plot(s, plots(:,3)', 'LineWidth', 2); hold on
p4 = plot(s, plots(:,4)', 'LineWidth', 2);
legend([p1,p2,p3,p4], "T-t=1.5", "T-t=1.0", "T-t=0.5", "T-t=0");
ylabel('V'); xlabel('S'); axis([0,b,0,(E2-E1)]);
title('Payoff Diagram at Various Times of Put Option');


%% Finished
clear
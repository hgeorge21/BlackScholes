r = 0.1; sig = 0.2;
E = 1;   T   = 2;
type= "put";

a = 0; b = 2;
ns = 599; nt = 599;
values_eu = BS_eur_cn(a, b, E, r, sig, T, type, ns, nt);
values_am = BS_am_cn(a, b, E, r, sig, T, type, ns, nt, 0);

plots = zeros(ns, 1);
plots(:, 1) = values_eu(1 : ns);
plots(:, 2) = values_am(1 : ns);

s = b/ns:b/ns:b;
figure
p1 = plot(s, plots(:,1)', 'LineWidth', 2); hold on
p2 = plot(s, plots(:,2)', 'LineWidth', 2);
legend([p1,p2], "European Option", "American Option");
ylabel('V'); xlabel('S');
if type == "call"
    title('Payoff Diagram of European vs American of Call Option');
elseif type == "put"
    title('Payoff Diagram of European vs American of Put Option');
end
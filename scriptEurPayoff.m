r   = 0.1;
sig = 0.2;
E   = 1;
T   = 2;
type= "call";
ts  = {0.5, 1.0, 1.5, 2.0};

a = 0; b = 2;
ns = 599; nt = 599;
values = BS_eur_impl_fd(a, b, E, r, sig, T, type, ns, nt);

plots = zeros(ns, 4);
for i = 1:4
    ti = fix(ts{i} / T * (nt+1));
    plots(: ,i) = values((ti-2)*ns+1 : (ti-1)*ns);
end

s = b/ns:b/ns:b;
figure
p1 = plot(s, plots(:,1)', 'LineWidth', 2);
hold on
p2 = plot(s, plots(:,2)', 'LineWidth', 2);
hold on
p3 = plot(s, plots(:,3)', 'LineWidth', 2);
hold on
p4 = plot(s, plots(:,4)', 'LineWidth', 2);
legend([p1,p2,p3,p4], "T-t=1.5", "T-t=1.0", "T-t=0.5", "T-t=0");
ylabel('V');
xlabel('S');
if type == "call"
    title('Payoff Diagram at Various Times of Call Option');
elseif type == "put"
    title('Payoff Diagram at Various Times of Put Option');
end
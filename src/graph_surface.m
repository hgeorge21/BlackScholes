function graph_surface(values, ns, nt, T, Sa, Sb, type)
u_matrix = reshape(values, ns, nt);
[X,Y] = meshgrid(0:(T/(nt-1)):T, Sa:((Sb-Sa)/(ns-1)):Sb);

mesh(X, Y, u_matrix);
ylabel("Stock Price [$]");
zlabel("Option Value [$]");
if type == "put"
    xlabel("Time [Year]", "Rotation", 20);
    title("European Put Option Value with Black-Scholes Model");
elseif type == "call"
    xlabel("Time [Year]", "Rotation", 20);
    title("European Call Option Value with Black-Scholes Model");
end
end


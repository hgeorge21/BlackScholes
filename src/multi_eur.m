function values = multi_eur(Sa, Sb, E, r, sigma, T, type, ns, nt, initial)
%BS_EUR_FD 
%   Implicit Finite Difference for Black-Scholes with European Option
%   Va, Vb are boundary condition functions of time at S=Sa and S=Sb
%   E: exercise price r: risk-free interest rate
%   sigma: volatility function of time
%   T: expiry date      type: call or put option
hs = (Sb-Sa) / (ns+1);
ht = T / (nt+1);

values = zeros(ns*nt, 1);
if type == "put"
    for i = 1:ns, values((nt-1)*ns+i,1) = max(E2-i*hs,0)-max(E1-i*hs,0); end
elseif type == "call"
    for i = 1:ns, values((nt-1)*ns+i,1) = initial(i);
end

% calculates for put option
for i = nt-1:-1:1
    Aj = sparse(ns, ns);
    bj = zeros(ns, 1);
    for j = 1:ns
        center = 1 + sigma^2*j^2*ht + r*ht;
        left = 1/2*r*j*ht - 1/2*sigma^2*j^2*ht;
        right = -1/2*r*j*ht - 1/2*sigma^2*j^2*ht;

        Aj(j,j) = center;
        if j < ns, Aj(j, j+1) = right; end
        if j > 1,  Aj(j, j-1) = left;  end
       
        % bj vector
        if j == 1
            bj(j, 1) = values(i*ns+j, 1);
            if type == "put"    
                bj(j, 1) = bj(j, 1) - left*(E2-E1); 
            end
        elseif j == ns
            bj(j, 1) = values(i*ns+j,1);
            if type == "call"
                bj(j, 1) = bj(j, 1) -right*(j*hs-E*exp(-r*(T-i*ht)));
            end
        else
            bj(j, 1) = values(i*ns+j, 1); 
        end
    end
    uj = Aj\bj;
    values((i-1)*ns+1 : i*ns, 1) = uj;
end

graph_surface(values, ns, nt, T, Sa, Sb, type);
hold on;
end


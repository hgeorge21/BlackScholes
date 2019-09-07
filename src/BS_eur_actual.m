function value = BS_eur_actual(S, E, r, sigma, T, t, type)
%BS_eur_actual
%   Actual solution of Black-Scholes of European Option given by
%   explicit formula V(S, t) with following initial and boundary conditions
%     - Call Option
%       C(S, t)~S as S->Inf   C(S,T) = max(S-E, 0)  C(0, t) = 0 
%     - Put Option
%       P(S, t)->0 as S->Inf  P(S,T) = max(E-S, 0)  P(0, t) = E*e^(-r(T-t)) 

d1 = (log(S/E) + (r+1/2*(sigma)^2)*(T-t)) / sigma / sqrt(T-t);
d2 = (log(S/E) + (r-1/2*(sigma)^2)*(T-t)) / sigma / sqrt(T-t);

func = @(x) 1/sqrt(2*pi)*exp(-(x.^2)/2);

N = @(x) integral(func, -Inf, x);

N_d1 = N(d1);
N_d2 = N(d2);

% C, P satisfy put-call parity C-P = S-E*exp(-r*(T-t))

if type == "call"
    value = S*N_d1 - E*exp(-r*(T-t))*N_d2;
elseif type == "put"
    value = E*exp(-r*(T-t))*(1-N_d2) - S*(1-N_d1);
end

end


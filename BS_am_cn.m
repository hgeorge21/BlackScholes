function values = BS_am_cn(Sa, Sb, E, r, sigma, T, type, ns, nt)

dt = T / (nt+1);
ds = (Sb-Sa) / (ns+1);
sig2 = sigma^2;

values = zeros(ns*nt, 1);
if type == "put"
    for i = 1:ns, values((nt-1)*ns+i,1) = max(E-i*ds, 0); end
elseif type == "call"
    for i = 1:ns, values((nt-1)*ns+i,1) = max(i*ds-E, 0); end
end

for i = nt-1:-1:1
    Aj = sparse(ns, ns);
    bj = zeros(ns, 1);
    
    for j = 1:ns
        center = -2/dt-sig2*j^2-2*r;
        left   = 1/2*(sig2*j^2-r*j);
        right  = 1/2*(sig2*j^2+r*j);
        
        Aj(j,j) = center;
        if j > 1,  Aj(j, j-1) = left;  end
        if j < ns, Aj(j, j+1) = right; end
        
        % bj vector for the system
        index = i*ns+j;
        if j == 1
            bj(j,1) = (-2/dt+sig2*j^2)*values(index,1)...
                        - right*values(index+1, 1);
            if type == "put" 
                bj(j,1) = bj(j,1) - left*E;
            end
        elseif j == ns
            bj(j,1) = (-2/dt+sig2*j^2)*values(index,1) - left*values(index-1,1);
            if type == "call"
               bj(j,1) = bj(j,1) - right*(j*ds-E*exp(-r*(T-i*dt))); 
            end
        else
            bj(j,1) = (-2/dt+sig2*j^2)*values(index, 1) ...
                       - left*values(index-1, 1) - right*values(index+1, 1);
        end
    end
    uj = Aj\bj;
    
    for j = 1:ns
       uj(j, 1) = max(uj(j,1), E-j*ds);
    end
    
    values((i-1)*ns+1 : i*ns, 1) = uj;
end

u_matrix = reshape(values, ns, nt);
[X,Y] = meshgrid(0:(T/(nt-1)):T, Sa:((Sb-Sa)/(ns-1)):Sb);

mesh(X, Y, u_matrix);
xlabel("Time [Year]", "Rotation", -20);
ylabel("Stock Price [$]");
zlabel("Option Value [$]");
title("European Put Option Value with Black-Scholes Model");
end


function values = BS_am_cn(Sa, Sb, E, r, sigma, T, type, ns, nt, d)

dt = T / (nt+1); ds = (Sb-Sa) / (ns+1);
sig2 = sigma^2;
values = zeros(ns*nt, 1);

if type == "put"
    for i = 1:ns, values((nt-1)*ns+i,1) = max(E-i*ds, 0); end
elseif type == "call"
    for i = 1:ns, values((nt-1)*ns+i,1) = max(i*ds-E, 0); end
end

for i = nt-1:-1:1
    Aj = sparse(ns, ns); bj = zeros(ns, 1);
    
    for j = 1:ns
        center = -2/dt-sig2*j^2-2*r;
        left   = 1/2*(sig2*j^2-(r-d)*j);
        right  = 1/2*(sig2*j^2+(r-d)*j);
        
        Aj(j,j) = center;
        if j > 1,  Aj(j, j-1) = left;  end
        if j < ns, Aj(j, j+1) = right; end
        
        % bj vector for the system
        index = i*ns+j;
        bj(j,1) = (-2/dt+sig2*j^2) * values(index,1);
        if j == 1
            bj(j,1) = bj(j,1) - right*values(index+1, 1);
            if type == "put", bj(j,1) = bj(j,1) - 2*left*E; end
        elseif j == ns
            bj(j,1) = bj(j,1) - left * values(index-1,1);
            if type == "call"
                bj(j,1) = bj(j,1) - 2*right*(j*ds-E); 
            end
        else
            bj(j,1) = bj(j,1) - left * values(index-1, 1)...
                        - right * values(index+1, 1);
        end
    end
    uj = Aj\bj;
    if type == "put"
        for j = 1:ns, uj(j, 1) = max(uj(j,1), E-j*ds); end
    elseif type == "call"
        for j = 1:ns, uj(j, 1) = max(uj(j,1), j*ds-E); end
    end
    
    values((i-1)*ns+1 : i*ns, 1) = uj;
end

graph_surface(values, ns, nt, T, Sa, Sb, type);
end


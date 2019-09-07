function x = SOR(A, b, x0, omega)

nIter = 0; maxIter = 5000;
error = 1; epi = 1E-6;
x = zeros(size(x0)); n = length(b);

while ((error > epi) && (nIter < maxIter))
    nIter = nIter + 1;
    for i = 1:n
        x(i) = b(i);
        if i > 1, x(i) = x(i) - A(i, i-1) * x(i-1);  end
        if i < n, x(i) = x(i) - A(i, i+1) * x0(i+1); end
        
        if (abs(A(i, i)) > 1E-10)
            x(i) = x(i)/A(i, i);
            x(i) = omega * x(i) + (1-omega)*x0(i); 
        end
    end
    error = norm(x - x0);
    x0 = x;
end

end
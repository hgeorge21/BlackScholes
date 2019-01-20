function five_point_stencil(n)

% Solve a poisson equation with specific boundary conditions
% u_{xx} = -u(x+2h) + 16u(x+h) - 30u(x) + 16(x-h) -u(x-2h)

% h = 1/(n+1);
% A = zeros(n, n);
% 
% for i = 3 : n-4
%     for j = 3 : n-4
%         A(i-2, j) = A(i-2, j) - 1;
%         A(i-1, j) = A(i-1, j) + 16;
%         A(i, j) = A(i, j) - 30;
%         A(i+1, j) = A(i+1, j) + 16;
%         A(i+2, j) = A(i+2, j) - 1;
%     end
% end



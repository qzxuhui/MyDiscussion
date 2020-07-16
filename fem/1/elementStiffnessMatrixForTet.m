function K = elementStiffnessMatrixForTet(x, y, z, E, nu)
% calculate element stiffness matrix of tetrahedron element
% x : node x coordinate
% y : node y coordinate
% z : node z coordinate
% E : elastic module
% nu: possion ratio

% reference:
% [1] A first course in the finite element method six edition@ Logan

% material
% [1] table 11.1.5
D = zeros(6, 6);
ecofficient = E / (1 + nu) / (1 - 2 * nu);
ecofficient_a = (1 - nu) * ecofficient;
ecofficient_b = nu * ecofficient;
ecofficient_c = (1 - 2 * nu) / 2 * ecofficient;
D(1, 1) = ecofficient_a;
D(1, 2) = ecofficient_b;
D(1, 3) = ecofficient_b;
D(2, 1) = ecofficient_b;
D(2, 2) = ecofficient_a;
D(2, 3) = ecofficient_b;
D(3, 1) = ecofficient_b;
D(3, 2) = ecofficient_b;
D(3, 3) = ecofficient_a;
D(4, 4) = ecofficient_c;
D(5, 5) = ecofficient_c;
D(6, 6) = ecofficient_c;

x1 = x(1);
x2 = x(2);
x3 = x(3);
x4 = x(4);
y1 = y(1);
y2 = y(2);
y3 = y(3);
y4 = y(4);
z1 = z(1);
z2 = z(2);
z3 = z(3);
z4 = z(4);

% volume
% [1] equ (11.2.4)
V = det([1, x1, y1, z1; ...
    1, x2, y2, z2; ...
    1, x3, y3, z3; ...
    1, x4, y4, z4]) / 6;

if V < 0
   error('V less than zero, check node index in element may be wrong.')
end

% [1] equation (11.2.5)
b1 = -det([1, y2, z2; ...
    1, y3, z3; ...
    1, y4, z4]);

c1 = det([1, x2, z2; ...
    1, x3, z3; ...
    1, x4, z4]);

d1 = -det([1, x2, y2; ...
    1, x3, y3; ...
    1, x4, y4]);

% [1] equation (11.2.6)
b2 = det([1, y1, z1; ...
    1, y3, z3; ...
    1, y4, z4]);

c2 = -det([1, x1, z1; ...
    1, x3, z3; ...
    1, x4, z4]);

d2 = det([1, x1, y1; ...
    1, x3, y3; ...
    1, x4, y4]);

% [1] equation (11.2.7)
b3 = -det([1, y1, z1; ...
    1, y2, z2; ...
    1, y4, z4]);

c3 = det([1, x1, z1; ...
    1, x2, z2; ...
    1, x4, z4]);

d3 = -det([1, x1, y1; ...
    1, x2, y2; ...
    1, x4, y4]);

% [1] equation (11.2.8)
b4 = det([1, y1, z1; ...
    1, y2, z2; ...
    1, y3, z3]);

c4 = -det([1, x1, z1; ...
    1, x2, z2; ...
    1, x3, z3]);

d4 = det([1, x1, y1; ...
    1, x2, y2; ...
    1, x3, y3]);

% [1] equation (11.2.13)(11.2.15)
B = [b1, 0, 0, b2, 0, 0, b3, 0, 0, b4, 0, 0; ...
    0, c1, 0, 0, c2, 0, 0, c3, 0, 0, c4, 0; ...
    0, 0, d1, 0, 0, d2, 0, 0, d3, 0, 0, d4; ...
    c1, b1, 0, c2, b2, 0, c3, b3, 0, c4, b4, 0; ...
    0, d1, c1, 0, d2, c2, 0, d3, c3, 0, d4, c4; ...
    d1, 0, b1, d2, 0, b2, d3, 0, b3, d4, 0, b4] / 6 / V;
% [1] 11.2.18
K = B' * D * B * V;
end

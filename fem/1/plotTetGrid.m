function plotTetGrid(node_coordinate, element_node_table)
num_node = size(node_coordinate, 1);
x = node_coordinate(:, 1);
y = node_coordinate(:, 2);
z = node_coordinate(:, 3);
scatter3(x, y, z, '.');
xlabel('x');
ylabel('y');
zlabel('z');
for i = 1:1:num_node
    text(x(i), y(i), z(i), num2str(i));
end
num_element = size(element_node_table, 1);
for i = 1:1:num_element
    node_1 = element_node_table(i, 1);
    node_2 = element_node_table(i, 2);
    node_3 = element_node_table(i, 3);
    node_4 = element_node_table(i, 4);
    x1 = x(node_1);
    x2 = x(node_2);
    x3 = x(node_3);
    x4 = x(node_4);
    y1 = y(node_1);
    y2 = y(node_2);
    y3 = y(node_3);
    y4 = y(node_4);
    z1 = z(node_1);
    z2 = z(node_2);
    z3 = z(node_3);
    z4 = z(node_4);
    % edge
    % (1,2)(1,3)(1,4)(2,3)(2,4),(3,4)
    % reform
    % (1,2,3,4,1) (1,3)(2,4)
    plot3([x1, x2, x3, x4, x1], [y1, y2, y3, y4, y1], [z1, z2, z3, z4, z1], 'k-');
    plot3([x1, x3], [y1, y3], [z1, z3], 'k-');
    plot3([x2, x4], [y2, y4], [z2, z4], 'k-');
end
end
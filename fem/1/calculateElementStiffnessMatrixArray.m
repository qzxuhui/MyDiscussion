function [element_matrix_array] = calculateElementStiffnessMatrixArray(node_coordinate_table, element_node_table)
num_element = size(element_node_table, 1);
element_matrix_array = cell(num_element, 1);
for i = 1:1:num_element
    node_a_id = element_node_table(i, 1);
    node_b_id = element_node_table(i, 2);
    node_c_id = element_node_table(i, 3);
    node_d_id = element_node_table(i, 4);
    x = zeros(4, 1);
    x(1) = node_coordinate_table(node_a_id, 1);
    x(2) = node_coordinate_table(node_b_id, 1);
    x(3) = node_coordinate_table(node_c_id, 1);
    x(4) = node_coordinate_table(node_d_id, 1);
    y = zeros(4, 1);
    y(1) = node_coordinate_table(node_a_id, 2);
    y(2) = node_coordinate_table(node_b_id, 2);
    y(3) = node_coordinate_table(node_c_id, 2);
    y(4) = node_coordinate_table(node_d_id, 2);
    z = zeros(4, 1);
    z(1) = node_coordinate_table(node_a_id, 3);
    z(2) = node_coordinate_table(node_b_id, 3);
    z(3) = node_coordinate_table(node_c_id, 3);
    z(4) = node_coordinate_table(node_d_id, 3);
    E=2.1e9;
    nu=0.3;
    element_matrix_array{i} = elementStiffnessMatrixForTet(x, y,z, E, nu);
end
end
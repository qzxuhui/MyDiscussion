% assemble global matrix
% this function can be used to assemble element stiffness matrix and
% element mass matrix

function K = assembleGlobalMatrix(node_coordinate_table, element_node_table, DOF, element_matrix_array)
num_node = size(node_coordinate_table, 1);
K = zeros(DOF*num_node);
num_element = size(element_node_table, 1);
for i = 1:1:num_element
    K0 = element_matrix_array{i};
    node_global_index_array = element_node_table(i, :);
    for node_i = 1:1:4
        for node_j = 1:1:4
            node_global_index_i = node_global_index_array(node_i);
            node_global_index_j = node_global_index_array(node_j);
            for i1 = 1:1:DOF
                for j1 = 1:1:DOF
                    row = (node_i - 1) * DOF + i1;
                    col = (node_j - 1) * DOF + j1;
                    ROW = (node_global_index_i - 1) * DOF + i1;
                    COL = (node_global_index_j - 1) * DOF + j1;
                    K(ROW, COL) = K(ROW, COL) + K0(row, col);
                end
            end
        end
    end
end

end

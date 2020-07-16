% this is the example of tet element fem analysis
% the standard solution can be found the [1] Chapter15
% Reference:
% [1] MATLAB guide to finite elements @ Kattan

clc
clear
close all

node_coordinate_table=[0,0,0
    0.025,0,0
    0,0.5,0
    0.025,0.5,0
    0,0,0.25
    0.025,0,0.25
    0,0.5,0.25
    0.025,0.5,0.25
    ];

element_node_table=[
    1,2,4,6
    1,4,3,7
    6,5,7,1
    6,7,8,4
    1,6,4,7];

dof_per_node=3;
num_node = 8;
num_dof = num_node * dof_per_node;

% constrain configure
constrain_value = zeros(num_dof,1);
is_constrain = zeros(num_dof,1);
for node_index=[1,2,5,6]
    for dof_index = 1:3
        dof_global_index = (node_index - 1) * dof_per_node + dof_index;
        constrain_value(dof_global_index)=0;
        is_constrain(dof_global_index)=1;
    end
end

% load configure
load_value = zeros(num_dof,1);
load_value((3-1)*3+2)=3.125;
load_value((4-1)*3+2)=6.25;
load_value((7-1)*3+2)=6.25;
load_value((8-1)*3+2)=3.125;

% assemble global stiffness matrix
element_stiffness_matrix_array = calculateElementStiffnessMatrixArray(node_coordinate_table, element_node_table);
K = assembleGlobalMatrix(node_coordinate_table, element_node_table, dof_per_node, element_stiffness_matrix_array);

% constrain discrete system
P=load_value;
for i=1:1:num_dof
    if is_constrain(i)
        K(i,:)=0;
        K(:,i)=0;
        K(i,i)=1;
        P(i)=0;
    end
end

% solution
U=K\P;

% check solution
expect_U=1e-6*[
    0
    0
    0
    0
    0
    0
    -0.0004
    0.6082
    0.0090
    -0.0127
    0.6078
    0.0056
    0
    0
    0
    0
    0
    0
    0.0127
    0.6078
    -0.0056
    0.0004
    0.6082
    -0.0090];
error = sum(abs(U- expect_U));
if error > 1e-8
    error('solution not equal.')
end

% post process
displacement=(reshape(U,dof_per_node,num_node))';
new_node_coordinate_table=node_coordinate_table+displacement*1e5;

figure
hold on
plotTetGrid(node_coordinate_table,element_node_table);
scatter3(new_node_coordinate_table(:,1),new_node_coordinate_table(:,2),new_node_coordinate_table(:,3));
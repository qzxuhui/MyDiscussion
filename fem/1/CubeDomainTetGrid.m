classdef CubeDomainTetGrid
    properties (SetAccess = private)
        num_x_node
        num_y_node
        num_z_node
        x_range
        y_range
        z_range
        dx
        dy
        dz
    end

    methods
        function obj = CubeDomainTetGrid(num_x_node, num_y_node, num_z_node, x_range, y_range, z_range)
            validateattributes(num_x_node, {'double'}, {'size', [1, 1]});
            validateattributes(num_y_node, {'double'}, {'size', [1, 1]});
            validateattributes(num_z_node, {'double'}, {'size', [1, 1]});
            validateattributes(x_range, {'double'}, {'size', [1, 1]});
            validateattributes(y_range, {'double'}, {'size', [1, 1]});
            validateattributes(z_range, {'double'}, {'size', [1, 1]});
            obj.num_x_node = num_x_node;
            obj.num_y_node = num_y_node;
            obj.num_z_node = num_z_node;
            obj.x_range = x_range;
            obj.y_range = y_range;
            obj.z_range = z_range;
            obj.dx = obj.x_range / (obj.num_x_node - 1);
            obj.dy = obj.y_range / (obj.num_y_node - 1);
            obj.dz = obj.z_range / (obj.num_z_node - 1);
        end

        function num_node = numNode(obj)
            num_node = obj.num_x_node * obj.num_y_node * obj.num_z_node;
        end

        function node_coordinate_table = nodeCoordinateTable(obj)
            num_node = obj.numNode();
            node_coordinate_table = zeros(num_node, 3);
            for i = 1:1:obj.num_x_node
                for j = 1:1:obj.num_y_node
                    for k = 1:1:obj.num_z_node
                        x = (i - 1) * obj.dx;
                        y = (j - 1) * obj.dy;
                        z = (k - 1) * obj.dz;
                        node_index = obj.nodeIndex(i, j, k);
                        node_coordinate_table(node_index, :) = [x, y, z];
                    end
                end
            end
        end

        function node_index = nodeIndex(obj, x_index, y_index, z_index)
            if (x_index > obj.num_x_node)
                error('x_index overflow');
            end
            if (y_index > obj.num_y_node)
                error('y_index overflow');
            end
            if (z_index > obj.num_z_node)
                error('z_index overflow');
            end
            node_index = (z_index - 1) * (obj.num_x_node * obj.num_y_node) + ...
                (x_index - 1) * (obj.num_y_node) + y_index;
        end

        function element_node_table = elementNodeTable(obj)
            % Reference:
            % [1] MATLAB guide to finite elements @ Kattan
            %     Chapter 15, table 15-1, figure 15-3
            % [2] Introduction to finite elements in engineering @ Chadrupatla
            %     chinese version: 工程中的有限元方法 @ 曾攀
            %     Chapter 9, section 4 figure 9.4, table 9.2
            element_node_table = zeros(obj.numElement(), 4);
            % tranvers all sub cube
            % sub cube index:

            % layer 1     o---> y axis  (o is z axis stand for out of plane axis
            %  1 --- 3    |
            %  |     |    |
            %  2 --- 4    V  x axis

            % layer 2
            %  5 --- 7
            %  |     |
            %  6 --- 8
            offset = 1;
            for i = 1:1:obj.num_x_node - 1
                for j = 1:1:obj.num_y_node - 1
                    for k = 1:1:obj.num_z_node - 1
                        node_1_index = obj.nodeIndex(  i,  j,  k);
                        node_2_index = obj.nodeIndex(i+1,  j,  k);
                        node_3_index = obj.nodeIndex(  i,j+1,  k);
                        node_4_index = obj.nodeIndex(i+1,j+1,  k);
                        node_5_index = obj.nodeIndex(  i,  j,k+1);
                        node_6_index = obj.nodeIndex(i+1,  j,k+1);
                        node_7_index = obj.nodeIndex(  i,j+1,k+1);
                        node_8_index = obj.nodeIndex(i+1,j+1,k+1);
                        % tet 1 in sub cube
                        element_node_table(offset, :) = [node_1_index, node_2_index, node_4_index, node_6_index];
                        offset = offset + 1;
                        % tet 2 in sub cube
                        element_node_table(offset, :) = [node_1_index, node_4_index, node_3_index, node_7_index];
                        offset = offset + 1;
                        % tet 3 in sub cube
                        element_node_table(offset, :) = [node_6_index, node_5_index, node_7_index, node_1_index];
                        offset = offset + 1;
                        % tet 4 in sub cube
                        element_node_table(offset, :) = [node_6_index, node_7_index, node_8_index, node_4_index];
                        offset = offset + 1;
                        % tet 5 in sub cube
                        element_node_table(offset, :) = [node_1_index, node_6_index, node_4_index, node_7_index];
                        offset = offset + 1;
                    end
                end
            end
        end

        function num_element = numElement(obj)
            num_sub_cube = (obj.num_x_node - 1) * (obj.num_y_node - 1) * (obj.num_z_node - 1);
            % 5 for divide a subcell into 5 tet
            num_element = num_sub_cube * 5;
        end
    end
end
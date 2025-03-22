classdef Hand3DPlot
    properties
        version
        view_mode
        filesloc
        Vertices
        Shifts
        
    end
    properties (Hidden)
        R55
        R22
        AroundAxis
        PatchObjects
        Jidx
    end
    methods
        % Construct Function ----------------------------------------------
        function self = Hand3DPlot(version, opts)
            arguments
                version = 0 % 0(small version), 1(big version, real artificial hand)
                opts.view_mode = "front" % 'front' | 'below'
                opts.stepFilesLoc = ".\stepFiles"
            end
            addpath(opts.stepFilesLoc)
            self.version = version;
            self.view_mode = opts.view_mode;
            self.filesloc = opts.stepFilesLoc;
            self = self.createPlot;
        end

        % Update ----------------------------------------------------------
        function update(self, angles_or_gestname)
            if isstring(angles_or_gestname) || ischar(angles_or_gestname)
                % "fist", "pinch", ...
                % predefined angles
                op=0; re=10; cl=90; cl5=30; % open, rest, close, thumbClose angle
                if self.version==0, cl5=cl; end
                switch lower(string(angles_or_gestname))
                    case "rest",                angles = [re re re re re];
                    case "open",                angles = [op op op op op];
                    case "fist",                angles = [cl cl cl cl cl5];
                    case "pinch",               angles = [op op op 60 20]; 
                    case "win",                 angles = [cl cl op op cl5];
                    case "pinky_down",          angles = [cl op op op op];
                    case {"pinky_up", "pinky"}, angles = [op cl cl cl cl5];
                    case "ring_down",           angles = [op cl op op op];
                    case {"ring_up", "ring"},   angles = [cl op cl cl cl5];
                    case "middle_down",         angles = [op op cl op op];
                    case {"middle_up","middle"},angles = [cl cl op cl cl5];
                    case "index_down",          angles = [op op op cl op];
                    case {"index_up", "point"}, angles = [cl cl cl op cl5];
                    case "thumb_down",          angles = [op op op op cl5];
                    case {"thumb_up", "like"},  angles = [cl cl cl cl op];
                    otherwise; error("Invalid gesture.")
                end
            else
                % angles [pinky, ring, middle, index, thumb] (degree)
                angles = angles_or_gestname;
            end
            
            for i = 1:4
                self.PatchObjects(i).Vertices = rot(self.Vertices{i}, angles(i), self.AroundAxis) ...
                    + self.Shifts(i,:);
            end
            self.PatchObjects(5).Vertices = (self.R55*self.R22(rot(self.Vertices{5}, angles(5)/1, self.AroundAxis))')' ...
                + self.Shifts(5,:);
        
            for i = 6:9
                self.PatchObjects(i).Vertices = rot(self.Vertices{i}, angles(i-5)*2.2, self.AroundAxis) ...
                    + self.PatchObjects(i-5).Vertices(self.Jidx(i-5),:);
            end
            self.PatchObjects(10).Vertices = (self.R55*self.R22(rot(self.Vertices{10}, angles(5)/1*2.2, self.AroundAxis))')' ...
                + self.PatchObjects(5).Vertices(self.Jidx(5),:);
            drawnow;

            % ------------nested function---------------
            function v = rot(v,angle,axis)
                angle = deg2rad(angle);
                switch axis
                    case 'x'
                        R = [1, 0, 0;
                          0, cos(angle), -sin(angle);
                          0, sin(angle), cos(angle)];
                    case 'y'
                        R = [cos(angle), 0, sin(angle);
                              0, 1, 0;
                              -sin(angle), 0, cos(angle)];
                    case 'z'
                        R = [cos(angle), -sin(angle), 0;
                              sin(angle), cos(angle), 0;
                              0, 0, 1];
                end
                v = (R*v')';
            end
        end
    end
    % *********************************************************************
    methods (Access=private)
        % create plot -----------------------------------------------------
        function self = createPlot(self)
        
            ax = axes(figure,Position=[0,0,1,1]);
            % hold(ax, 'on');
            % % grid(ax, 'on');
            axis(ax, 'equal');
            xlabel(ax, 'X');
            ylabel(ax, 'Y');
            zlabel(ax, 'Z');
            ax.XColor = 'none';
            ax.YColor = 'none';
            ax.ZColor = 'none';
            ax.Color = "none";
            ax.CameraViewAngle = 7;
            view(ax, [1, 1, 1]);

            if self.view_mode == "below"
                % rotation around this axis
                self.AroundAxis = 'z';
                R = @(V) ([0 -1 0;1 0 0;0 0 1]'*([1 0 0;0 0 -1;0 1 0]*V'))'; % rotate along X then Z
                R2 = @(V) ([0 -1 0;1 0 0;0 0 1]'*([1 0 0;0 0 -1;0 1 0]'*V'))'; % rotate along X then Z
            elseif self.view_mode == "front"
                % rotation around this axis
                self.AroundAxis = 'y';
                R = @(V) V;
                R2 = @(V) V;
            end

            if self.version == 0
                filenames = ["P0","P1","P1", ...
                    "P1","P1","P1","P2", ...
                    "P2","P2","P2","P2"];
                % shift fingers from base
                shifts = R([8 -7.6 0;
                    8 -5.2 0;
                    8 -2.8 0;
                    8 -0.4 0;
                    1 0 0]);
                % rotation of finger 5
                R5 = [0 -1 0;1 0 0;0 0 1];
                % xyz limit
                if self.view_mode == "below"
                    ylim(ax, [-20 5])
                    zlim(ax, [-12 8])
                    xlim(ax, [-5 10])
                elseif self.view_mode == "front"
                    xlim(ax, [-4 18])
                    ylim(ax, [-12 10])
                    zlim(ax, [-8 4])
                end
                % end point index of middle PHALANX from 'parts.Points'
                joint_idx = [2,2,2,2,2];

            elseif self.version == 1
                filenames = ["base","finger1","finger24", ...
                    "finger3","finger24","finger5","finger1_2", ...
                    "finger24_2","finger3_2","finger24_2","finger5_2"];
                % shift fingers from base
                shifts = R([108.26 -32.84 21.98;
                    109.96 -10.77 21.97;
                    110.50 11.36 21.97;
                    109.88 33.48 21.97;
                    32.39 29.12 -14.06]);
                % rotation of finger 5
                R5 = [39.76 70.11 122.79;
                    105.61 126.59 139.16;
                    125.47 43.34 111.51];
                R5 = cos(deg2rad(R5))';
                % xyz limit
                if self.view_mode == "below"
                    xlim(ax, [-100 200])
                    ylim(ax, [-100 100])
                    zlim(ax, [-100 60])
                elseif self.view_mode == "front"  
                    xlim(ax, [-60 210])
                    ylim(ax, [-100 120])
                    zlim(ax, [-150 100])
                end
                % end point index of middle PHALANX from 'parts.Points'
                joint_idx = [8342,8510,8500,8510,5091];
            end

            filenames = fullfile(self.filesloc,"version_"+self.version,filenames+".stl");

            % [base, finger(1,...,5), finger(1_2,...,5_2)]
            parts = arrayfun(@(i)stlread(filenames(i)), 1:11, UniformOutput=false);
            % [finger(1,...,5), finger(1_2,...,5_2)]
            vertices = arrayfun(@(i)R(parts{i}.Points), 2:11, UniformOutput=false);
            faces = arrayfun(@(i)parts{i}.ConnectivityList, 2:11, UniformOutput=false);
    
            colors = [0.65,0.65,0.65;
                0.00,0.45,0.74;
                0.93,0.69,0.13];
                        
            patchfun = @(F,V,C) patch(Faces=F, Vertices=V, FaceColor=C, ...
                LineStyle=":", LineWidth=0.1, EdgeAlpha=.5, FaceAlpha=1);
            
            h0 = patchfun(parts{1}.ConnectivityList, R(parts{1}.Points), colors(1,:));

            h = gobjects(10,1);
            h(1) = patchfun(faces{1}, vertices{1}+shifts(1,:), colors(2,:));
            h(2) = patchfun(faces{2}, vertices{2}+shifts(2,:), colors(2,:));
            h(3) = patchfun(faces{3}, vertices{3}+shifts(3,:), colors(2,:));
            h(4) = patchfun(faces{4}, vertices{4}+shifts(4,:), colors(2,:));
            h(5) = patchfun(faces{6}, (R5*R2(vertices{5})')'+shifts(5,:), colors(2,:));

            h(6) = patchfun(faces{6}, vertices{6}+h(1).Vertices(joint_idx(1),:), colors(3,:));
            h(7) = patchfun(faces{7}, vertices{7}+h(2).Vertices(joint_idx(2),:), colors(3,:));
            h(8) = patchfun(faces{8}, vertices{8}+h(3).Vertices(joint_idx(3),:), colors(3,:));
            h(9) = patchfun(faces{9}, vertices{9}+h(4).Vertices(joint_idx(4),:), colors(3,:));
            h(10) = patchfun(faces{10}, (R5*R2(vertices{10})')'+h(5).Vertices(joint_idx(5),:), colors(3,:));

            self.PatchObjects = h;
            self.Vertices = vertices;
            self.Shifts = shifts;
            self.R55 = R5;
            self.R22 = R2;
            self.Jidx = joint_idx;
        end
    end
end
% Read the STL file
filenames = ["base","finger1","finger24", ...
    "finger3","finger24","finger5","finger1_2", ...
    "finger24_2","finger3_2","finger24_2","finger5_2"];
filenames = filenames + ".stl";

R = @(V) ([0 -1 0;1 0 0;0 0 1]'*([1 0 0;0 0 -1;0 1 0]*V'))'; % rotate along X then Z
R2 = @(V) ([0 -1 0;1 0 0;0 0 1]*([1 0 0;0 0 -1;0 1 0]*V'))'; % rotate along X then Z

% [base, finger(1,...,5), finger(1_2,...,5_2)]
parts = arrayfun(@(i)stlread(filenames(i)), 1:11, UniformOutput=false);
% [finger(1,...,5), finger(1_2,...,5_2)]
vertices = arrayfun(@(i)R(parts{i}.Points), 2:11, UniformOutput=false);
faces = arrayfun(@(i)parts{i}.ConnectivityList, 2:11, UniformOutput=false);

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

colors = [0.65,0.65,0.65;
    0.00,0.45,0.74;
    0.93,0.69,0.13];

close all
ax = axes;
hold(ax, 'on');
grid(ax, 'on');
axis(ax, 'equal');
xlabel(ax, 'X');
ylabel(ax, 'Y');
zlabel(ax, 'Z');
view(ax, [1, 1, 1]);
% xlim(ax, [-100 200])
% ylim(ax, [-100 100])
% zlim(ax, [-100 60])
xlim(ax, [-100 100])
ylim(ax, [-250 100])
zlim(ax, [-100 100])
patchfun = @(F,V,C) patch(Faces=F, Vertices=V, FaceColor=C, LineStyle=":", LineWidth=0.1, EdgeAlpha=.5, FaceAlpha=1);
h0 = patchfun(parts{1}.ConnectivityList, R(parts{1}.Points), colors(1,:));
h = gobjects(10,1);
h(1) = patchfun(faces{1}, vertices{1}+shifts(1,:), colors(2,:));
h(2) = patchfun(faces{2}, vertices{2}+shifts(2,:), colors(2,:));
h(3) = patchfun(faces{3}, vertices{3}+shifts(3,:), colors(2,:));
h(4) = patchfun(faces{4}, vertices{4}+shifts(4,:), colors(2,:));
h(5) = patchfun(faces{6}, (R5*R2(vertices{5})')'+shifts(5,:), colors(2,:));
joint_idx = [8342,8510,8500,8510,5091];
h(6) = patchfun(faces{6}, vertices{6}+h(1).Vertices(joint_idx(1),:), colors(3,:));
h(7) = patchfun(faces{7}, vertices{7}+h(2).Vertices(joint_idx(2),:), colors(3,:));
h(8) = patchfun(faces{8}, vertices{8}+h(3).Vertices(joint_idx(3),:), colors(3,:));
h(9) = patchfun(faces{9}, vertices{9}+h(4).Vertices(joint_idx(4),:), colors(3,:));
h(10) = patchfun(faces{10}, (R5*R2(vertices{10})')'+h(5).Vertices(joint_idx(5),:), colors(3,:));


% Set up the figure
hold(ax, 'on');
grid(ax, 'on');
axis(ax, 'equal');
xlabel(ax, 'X');
ylabel(ax, 'Y');
zlabel(ax, 'Z');
view(ax, [1, 1, 1]);


% Loop for updating the rotation
for ang = 1:90
    % Update the rotated object's vertices
tic
    for i = 1:4
        h(i).Vertices = rot(vertices{i}, ang, 'z') + shifts(i,:);
    end
    h(5).Vertices = (R5*R2(rot(vertices{5}, ang/5, 'z'))')' + shifts(5,:);

    for i = 6:9
        h(i).Vertices = rot(vertices{i}, ang*2.2, 'z') + h(i-5).Vertices(joint_idx(i-5),:);
    end
    h(10).Vertices = (R5*R2(rot(vertices{10}, ang/5*2.2, 'z'))')' + h(5).Vertices(joint_idx(5),:);
    drawnow;
end


%%
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
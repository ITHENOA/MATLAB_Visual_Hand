% Read the STL file
p0 = stlread('p1.stl');
p1 = stlread('p2.stl');
p2 = stlread('p2.stl');
p3 = stlread('p2.stl');
p4 = stlread('p2.stl');
p5 = stlread('p2.stl');

v0 = p0.Points;
v1 = p1.Points;
v2 = p2.Points;
v3 = p3.Points;
v4 = p4.Points;
v5 = p5.Points;

f0 = p0.ConnectivityList;
f1 = p1.ConnectivityList;
f2 = p2.ConnectivityList;
f3 = p3.ConnectivityList;
f4 = p4.ConnectivityList;
f5 = p5.ConnectivityList;

%
% v1 = v1 + [10 -8 0];

%

%% Plot the original and transformed STL model
close all;
figure;

% Create patch objects once
h0 = patch('Faces', f0, 'Vertices', v0, 'FaceColor', 'b'); 
h1 = patch('Faces', f1, 'Vertices', v1, 'FaceColor', 'r'); 

% Set up the figure
hold on;
grid on;
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
view([1, 1, 1]);
xlim([-10 20])
ylim([-20 10])
zlim([-10 5])

% Initial shift for the rotated object
shift = [10, -8, 0];

% Loop for updating the rotation
for ang = 1:120
    % Update the rotated object's vertices
    h1.Vertices = rot(v1, ang, 'y') + shift;
    
    % Pause for animation effect
    pause(0.01);
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
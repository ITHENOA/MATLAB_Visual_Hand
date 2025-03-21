% Read the STL file
p0 = stlread('base.stl');
p1 = stlread('finger1.stl');
p11 = stlread('finger1_2.stl');
p2 = stlread('finger24.stl');
p22 = stlread('finger24_2.stl');
p3 = stlread('finger3.stl');
p33 = stlread('finger3_2.STL');
p4 = stlread('finger24.stl');
p44 = stlread('finger24_2.stl');
p5 = stlread('finger5.stl');
p55 = stlread('finger5_2.stl');

v0 = p0.Points;
v1 = p1.Points;
v2 = p2.Points;
v3 = p3.Points;
v4 = p4.Points;
v5 = p5.Points;
v11 = p11.Points;
v22 = p22.Points;
v33 = p33.Points;
v44 = p44.Points;
v55 = p55.Points;

f0 = p0.ConnectivityList;
f1 = p1.ConnectivityList;
f2 = p2.ConnectivityList;
f3 = p3.ConnectivityList;
f4 = p4.ConnectivityList;
f5 = p5.ConnectivityList;
f11 = p11.ConnectivityList;
f22 = p22.ConnectivityList;
f33 = p33.ConnectivityList;
f44 = p44.ConnectivityList;
f55 = p55.ConnectivityList;

%
shift1 = [108.26 -32.84 21.98];
shift2 = [109.96 -10.77 21.97];
shift3 = [110.50 11.36 21.97];
shift4 = [109.88 33.48 21.97];
shift5 = [32.39 29.12 -14.06];

R5 = [39.76 70.11 122.79;
    105.61 126.59 139.16;
    125.47 43.34 111.51];
R5 = cos(deg2rad(R5))';
%

% Plot the original and transformed STL model
close all;
figure;

% Create patch objects once
h0 = patch('Faces', f0, 'Vertices', v0, 'FaceColor', 'b'); 
h1 = patch('Faces', f1, 'Vertices', v1+shift1, 'FaceColor', 'r'); 
h2 = patch('Faces', f2, 'Vertices', v2+shift2, 'FaceColor', 'r'); 
h3 = patch('Faces', f3, 'Vertices', v3+shift3, 'FaceColor', 'r', EdgeColor='none'); 
h4 = patch('Faces', f4, 'Vertices', v4+shift4, 'FaceColor', 'r'); 
h5 = patch('Faces', f5, 'Vertices', (R5*v5')'+shift5, 'FaceColor', 'r'); 

shift11 =  h1.Vertices(8342,:);
h11 = patch('Faces', f11, 'Vertices', v11+shift11, 'FaceColor', 'g'); 
shift22 =  h2.Vertices(8510,:);
h22 = patch('Faces', f22, 'Vertices', v22+shift22, 'FaceColor', 'g'); 
shift33 =  h3.Vertices(8500,:);
h33 = patch('Faces', f33, 'Vertices', v33+shift33, 'FaceColor', 'g'); 
shift44 =  h4.Vertices(8510,:);
h44 = patch('Faces', f44, 'Vertices', v44+shift44, 'FaceColor', 'g'); 
shift55 =  h5.Vertices(5091,:);
h55 = patch('Faces', f55, 'Vertices', (R5*v55')'+shift55, 'FaceColor', 'g'); 

% Set up the figure
hold on;
grid on;
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
view([1, 1, 1]);
xlim([-100 200])
ylim([-100 100])
zlim([-100 60])

% Loop for updating the rotation
for ang = 1:90
    % Update the rotated object's vertices
    h1.Vertices = rot(v1, ang, 'y') + shift1;
    h2.Vertices = rot(v2, ang, 'y') + shift2;
    h3.Vertices = rot(v3, ang, 'y') + shift3;
    h4.Vertices = rot(v4, ang, 'y') + shift4;
    h5.Vertices = (R5*rot(v5, ang, 'y')')' + shift5;

    h11.Vertices = rot(v11, ang*2.2, 'y') + h1.Vertices(8342,:);
    h22.Vertices = rot(v22, ang*2.2, 'y') + h2.Vertices(8510,:);
    h33.Vertices = rot(v33, ang*2.2, 'y') + h3.Vertices(8500,:);
    h44.Vertices = rot(v44, ang*2.2, 'y') + h4.Vertices(8510,:);
    h55.Vertices = (R5*rot(v55, ang*2.2, 'y')')' + h5.Vertices(5091,:);
    % Pause for animation effect
    pause(0.001);
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
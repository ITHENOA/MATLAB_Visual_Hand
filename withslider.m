% Read the STL files (same as your original code)
p0 = stlread('p0.stl');
p1 = stlread('p1.stl');
p11 = stlread('p11.stl');
p2 = stlread('p2_2.stl');
p22 = stlread('p22.stl');
p3 = stlread('p3_2.stl');
p33 = stlread('p32.stl');
p4 = stlread('p2_2.stl');
p44 = stlread('p22.stl');
p5 = stlread('p5_2.stl');
p55 = stlread('p55.stl');

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

shift1 = [108.26 -32.84 21.98];
shift2 = [109.96 -10.77 21.97];
shift3 = [110.50 11.36 21.97];
shift4 = [109.88 33.48 21.97];
shift5 = [32.39 29.12 -14.06];

R5 = [39.76 70.11 122.79;
    105.61 126.59 139.16;
    125.47 43.34 111.51];
R5 = cos(deg2rad(R5))';

% Create the figure for GUI and sliders
fig = uifigure('Name', 'Interactive Rotation', 'Position', [100, 100, 800, 600]);

% Create an axes to plot the models
ax = axes(fig, 'Position', [0.1, 0.3, 0.8, 0.6]);

% Create 5 sliders for controlling the angle of each part
slider1 = uislider(fig, 'Position', [150, 200, 500, 3], 'Limits', [0 360], 'Value', 0);
slider2 = uislider(fig, 'Position', [150, 160, 500, 3], 'Limits', [0 360], 'Value', 0);
slider3 = uislider(fig, 'Position', [150, 120, 500, 3], 'Limits', [0 360], 'Value', 0);
slider4 = uislider(fig, 'Position', [150, 80, 500, 3], 'Limits', [0 360], 'Value', 0);
slider5 = uislider(fig, 'Position', [150, 40, 500, 3], 'Limits', [0 360], 'Value', 0);

% Create labels for each slider
label1 = uilabel(fig, 'Position', [50, 50, 100, 22], 'Text', 'Part 1 Angle');
label2 = uilabel(fig, 'Position', [50, 80, 100, 22], 'Text', 'Part 2 Angle');
label3 = uilabel(fig, 'Position', [50, 110, 100, 22], 'Text', 'Part 3 Angle');
label4 = uilabel(fig, 'Position', [50, 140, 100, 22], 'Text', 'Part 4 Angle');
label5 = uilabel(fig, 'Position', [50, 170, 100, 22], 'Text', 'Part 5 Angle');

% Plot the original model with the initial settings
h0 = patch('Faces', f0, 'Vertices', v0, 'FaceColor', 'b', 'Parent', ax);
h1 = patch('Faces', f1, 'Vertices', v1+shift1, 'FaceColor', 'r', 'Parent', ax);
h2 = patch('Faces', f2, 'Vertices', v2+shift2, 'FaceColor', 'r', 'Parent', ax);
h3 = patch('Faces', f3, 'Vertices', v3+shift3, 'FaceColor', 'r', 'Parent', ax);
h4 = patch('Faces', f4, 'Vertices', v4+shift4, 'FaceColor', 'r', 'Parent', ax);
h5 = patch('Faces', f5, 'Vertices', (R5*v5')' + shift5, 'FaceColor', 'r', 'Parent', ax);
shift11 =  h1.Vertices(8342,:);
shift22 =  h2.Vertices(8510,:);
shift33 =  h3.Vertices(8500,:);
shift44 =  h4.Vertices(8510,:);
shift55 =  h5.Vertices(5091,:);
h11 = patch('Faces', f11, 'Vertices', v11+shift11, 'FaceColor', 'g', 'Parent', ax);
h22 = patch('Faces', f22, 'Vertices', v22+shift22, 'FaceColor', 'g', 'Parent', ax);
h33 = patch('Faces', f33, 'Vertices', v33+shift33, 'FaceColor', 'g', 'Parent', ax);
h44 = patch('Faces', f44, 'Vertices', v44+shift44, 'FaceColor', 'g', 'Parent', ax);
h55 = patch('Faces', f55, 'Vertices', (R5*v55')' + shift55, 'FaceColor', 'g', 'Parent', ax);

% Set up the figure properties
hold(ax, 'on');
grid(ax, 'on');
axis(ax,"equal");
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
view(ax,[1, 1, 1]);
xlim(ax,[-100 200]);
ylim(ax,[-100 100]);
zlim(ax,[-100 60]);

% Update the plot whenever a slider is adjusted
addlistener(slider1, 'ValueChanged', @(src, event) updatePlot(slider1, slider2, slider3, slider4, slider5, h1, h2, h3, h4, h5, h11, h22, h33, h44, h55, v1, v2, v3, v4, v5, v11, v22, v33, v44, v55, shift1, shift2, shift3, shift4, shift5, R5));
addlistener(slider2, 'ValueChanged', @(src, event) updatePlot(slider1, slider2, slider3, slider4, slider5, h1, h2, h3, h4, h5, h11, h22, h33, h44, h55, v1, v2, v3, v4, v5, v11, v22, v33, v44, v55, shift1, shift2, shift3, shift4, shift5, R5));
addlistener(slider3, 'ValueChanged', @(src, event) updatePlot(slider1, slider2, slider3, slider4, slider5, h1, h2, h3, h4, h5, h11, h22, h33, h44, h55, v1, v2, v3, v4, v5, v11, v22, v33, v44, v55, shift1, shift2, shift3, shift4, shift5, R5));
addlistener(slider4, 'ValueChanged', @(src, event) updatePlot(slider1, slider2, slider3, slider4, slider5, h1, h2, h3, h4, h5, h11, h22, h33, h44, h55, v1, v2, v3, v4, v5, v11, v22, v33, v44, v55, shift1, shift2, shift3, shift4, shift5, R5));
addlistener(slider5, 'ValueChanged', @(src, event) updatePlot(slider1, slider2, slider3, slider4, slider5, h1, h2, h3, h4, h5, h11, h22, h33, h44, h55, v1, v2, v3, v4, v5, v11, v22, v33, v44, v55, shift1, shift2, shift3, shift4, shift5, R5));

function updatePlot(slider1, slider2, slider3, slider4, slider5, h1, h2, h3, h4, h5, h11, h22, h33, h44, h55, v1, v2, v3, v4, v5, v11, v22, v33, v44, v55, shift1, shift2, shift3, shift4, shift5, R5)
    % Update the rotation for each part based on the slider values
    ang1 = slider1.Value;
    ang2 = slider2.Value;
    ang3 = slider3.Value;
    ang4 = slider4.Value;
    ang5 = slider5.Value;

    % Rotate main parts
    h1.Vertices = rot(v1, ang1, 'y') + shift1;
    h2.Vertices = rot(v2, ang2, 'y') + shift2;
    h3.Vertices = rot(v3, ang3, 'y') + shift3;
    h4.Vertices = rot(v4, ang4, 'y') + shift4;
    h5.Vertices = (R5 * rot(v5, ang5, 'y')')' + shift5;

    % Update secondary parts (11, 22, 33, 44, 55) based on main parts' rotations
    h11.Vertices = rot(v11, ang1 * 2.2, 'y') + h1.Vertices(8342,:);
    h22.Vertices = rot(v22, ang2 * 2.2, 'y') + h2.Vertices(8510,:);
    h33.Vertices = rot(v33, ang3 * 2.2, 'y') + h3.Vertices(8500,:);
    h44.Vertices = rot(v44, ang4 * 2.2, 'y') + h4.Vertices(8510,:);
    h55.Vertices = (R5 * rot(v55, ang5 * 2.2, 'y')')' + h5.Vertices(5091,:);
end

% Rotation function as in your original code
function v = rot(v, angle, axis)
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
    v = (R * v')';
end
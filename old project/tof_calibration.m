clear all;
clc;
close all;

theta = 45; % theta = -180~180
baseline = 100;
unique_measurement_range = 2;
alpha = 2;

x_d = 0;
y_d = 0;
z_d = 0;

z_c = 500;


z_p = 0;
x_p = baseline*cos(theta/180*pi);
y_p = baseline*sin(theta/180*pi);

theta_z = atan(baseline/z_c)/pi*180

[x_c,y_c] = meshgrid(-150:1:150,-150:1:150);

measure_depth_c = (((x_c-x_p).^2+(y_c-y_p).^2+(z_c-z_p)^2).^0.5 + ...
    ((x_c-x_d).^2+(y_c-y_d).^2+(z_c-z_d)^2).^0.5)/2 - z_c;
figure;imagesc(measure_depth_c); title('bias')


object_depth = (1-im2double(imresize(imread('cameraman.tif'),[301,301])))*unique_measurement_range*alpha + z_c;
figure;imagesc(object_depth); title('gt')


x_o = x_c;
y_o = y_c;
z_o = object_depth;
measure_depth = (((x_o-x_p).^2+(y_o-y_p).^2+(z_o-z_p).^2).^0.5 + ...
    ((x_o-x_d).^2+(y_o-y_d).^2+(z_o-z_d).^2).^0.5)/2;
figure;imagesc(measure_depth); title('uncalibrated')


calibrated_measure_depth = measure_depth-measure_depth_c;
figure;imagesc(calibrated_measure_depth); title('calibrated')


relative_depth = calibrated_measure_depth - z_c;
figure;imagesc(relative_depth); title('relative depth')

depth_map = mod(relative_depth,unique_measurement_range)/unique_measurement_range*2*pi-pi;
figure;imagesc(depth_map); title('depth map')
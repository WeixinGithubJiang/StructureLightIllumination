close all;
clear;
clc;

target = 'single sinusoid'
input_folder = './measurements/test_20180829/'
cycle_num = 20
phase_shift = [0,pi/2,pi,pi/2*3]

% load images
for i = 0:3
    file_name = [num2str(cycle_num),'_',num2str(i),'_m_1.bmp'];
    measurements(:,:,i+1) = im2double(imread([input_folder,file_name]));
end

for i = 0:3
    file_name = [num2str(cycle_num),'_',num2str(i),'_r.bmp'];
    reference(:,:,i+1) = im2double(imread([input_folder,file_name]));
end
im_size = size(measurements)


% display
% figure; imshow(sum(reference,3),[]); title('reference plane');
% figure; imshow(sum(measurements,3),[]); title('scene 3')
% figure; imshow(reference(:,:,1),[])
% return

% display
% figure;
% for i = 1:4
%     subplot(2,4,i); imshow(measurements(:,:,i),[]); hold on; plot([1,2448],[1024,1024],'r-','LineWidth',5)
%     subplot(2,4,i+4); plot(measurements(1024,:,i))
% end


% figure;
% for i = 1:4
%     subplot(2,4,i); imshow(measurements(:,:,i),[]); hold on; plot([1,2448],[1700,1700],'r-','LineWidth',5)
%     subplot(2,4,i+4); plot(measurements(1700,:,i))
% end



% calculat the cycle
phase_map_m = cal_phase_map(measurements);
phase_map_r = cal_phase_map(reference);
% phase_map_m = atan(1./((measurements(:,:,2)-measurements(:,:,4))./(measurements(:,:,1)-measurements(:,:,3))));
% phase_map_r = atan(1./((reference(:,:,2)-reference(:,:,4))./(reference(:,:,1)-reference(:,:,3))));
% figure;
% imagesc((phase_map_m))
% figure;
% imagesc(phase_map_r)
% depth_map = phase_map/sin(10/180*pi);
% 
% figure;
% imagesc(phase_map_m-phase_map_r)

% background illumination
background_ill_m = mean(measurements,3);
background_ill_r = mean(reference,3);

figure; 
subplot(1,2,1); imshow(background_ill_m,[]); title('measurements background illumination')
subplot(1,2,2); imshow(background_ill_r,[]); title('reference background illumination')

% measurements w/o background illumination
for i = 1:4
    measurements_no_background(:,:,i) = measurements(:,:,i)-background_ill_m;
    reference_no_background(:,:,i) = reference(:,:,i) - background_ill_r;
end



reflectivity_m = sqrt(sum(measurements_no_background.^2,3)/2);
reflectivity_r = sqrt(sum(reference_no_background.^2,3)/2);
figure; 
subplot(1,2,1); imshow(reflectivity_m,[]); title('measurements reflectivity')
subplot(1,2,2); imshow(reflectivity_r,[]); title('reference reflectivity')

% display
figure;
for i = 1:4
    subplot(2,4,i); imshow(measurements(:,:,i),[]); hold on; plot([1,2448],[1024,1024],'r-','LineWidth',5)
    subplot(2,4,i+4); plot(measurements(1024,:,i))
end



% phase map
% B = (measurements(:,:,1)+measurements(:,:,3))./2;
% A = sqrt((measurements(:,:,2)-B).^2+((measurements(:,:,1)-measurements(:,:,3))/2).^2);
% phase_map_m = acos((measurements(:,:,2)-B)./(A+eps));
figure; imagesc(phase_map_m);


% B = (reference(:,:,1)+reference(:,:,3))./2;
% A = sqrt((reference(:,:,2)-B).^2+((reference(:,:,1)-reference(:,:,3))/2).^2);
% phase_map_r = acos((reference(:,:,2)-B)./(A+eps));
figure; imagesc(phase_map_r);

disp_phase = phase_map_m-phase_map_r;
small_costant = 1e-1;
disp_phase(disp_phase>small_costant) = disp_phase(disp_phase>small_costant)-2*pi;
figure; imagesc(disp_phase)
% % eliminate background illumination and reflectivity
% for i = 1:4
%     tmp_m(:,:,i) = measurements_no_background(:,:,i)./reflectivity_m;
% end
% 
% figure;
% for i = 1:4
%     subplot(1,4,i); imagesc(tmp_m(:,:,i));
% end

% % phase map
% phase_map_m = atan(((measurements(:,:,1)-measurements(:,:,3))./(measurements(:,:,2)-measurements(:,:,4))));
% phase_map_r = atan(((reference(:,:,1)-reference(:,:,3))./(reference(:,:,2)-reference(:,:,4))));
% 
% figure;
% subplot(1,2,1); imshow(phase_map_m,[]); title('measurements phase map')
% subplot(1,2,2); imshow(phase_map_r,[]); title('reference phase map')
% 
% 
% 
% % back propagation
% for i = 1:4
%     re_measurements(:,:,i) = reflectivity_m.*sin(phase_map_m+phase_shift(i))+background_ill_m;
%     re_reference(:,:,i) = reflectivity_r.*sin(phase_map_r+phase_shift(i))+background_ill_r;
% end
% 
% 
% 
% figure;
% for i = 1:4
%     subplot(2,4,i); imshow(measurements(:,:,i),[]); 
%     subplot(2,4,i+4); imshow(re_measurements(:,:,i),[])
% end
% 
% 
% figure;
% for i = 1:4
%     subplot(2,4,i); imshow(reference(:,:,i),[]); 
%     subplot(2,4,i+4); imshow(re_reference(:,:,i),[])
% end




% display
% select_measurement = measurements_no_background(500:1000,500:1000,:);
% select_reference = reference_no_background(500:1000,500:1000,:);
% tmp = select_measurement(:,:,1)./reflectivity_m(500:1000);
% tmp_phase = asin(tmp/max(tmp(:)));

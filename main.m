%% Bilateral filtered image of ambient image (A_Base)
%input = './sol_images/carpet_noflash.tif';
%output = './sol_images/carpet_ambient_bilateral.tif';
input = './my_input/bottle4_ambient.tif';
output = './my_output/bottle4_ambient_bilateral.tif';
A = im2double(imread(input));
A_base = bfilter2(A, 11, [9 0.1]);
imwrite(A_base, output);

%% Bilateral filtered image of flash image (F_Base)
%input = './sol_images/carpet_flash.tif';
%output = './sol_images/carpet_flash_bilateral.tif';
input = './my_input/bottle4_flash.tif';
output = './my_output/bottle4_flash_bilateral.tif';
F = im2double(imread(input));
F_base = bfilter2(F, 11, [7 0.1]);
imwrite(F_base, output);

%% Joint Bilateral filtered image of ambient image (A_NR)
%A =  im2double(imread('./sol_images/carpet_noflash.tif'));
%F = im2double(imread('./sol_images/carpet_flash.tif'));
inputA = './my_input/bottle4_ambient.tif';
inputF = './my_input/bottle4_flash.tif';
outputANR = './my_output/bottle4_joint_bilateral.tif'
A = im2double(imread(inputA));
F = im2double(imread(inputF));
A_NR = jbfilter2(A, F, 5, 3, 0.1);
imwrite(A_NR, outputANR);

%% Calculate F_detail to obtain a detail layer
epsilon = 0.02;
inputFbase = './my_output/bottle4_flash_bilateral.tif';
inputF = './my_input/bottle4_flash.tif';
outputFdetail = './my_output/bottle4_flash_detail.tif';
%F_base = im2double(imread('./sol_images/carpet_flash_bilateral.tif'));
%F = im2double(imread('./sol_images/carpet_flash.tif'));
F_base = im2double(imread(inputFbase));
F = im2double(imread(inputF));
F_detail = (F+epsilon) ./ (F_base+epsilon);
%imwrite(F_detail, './sol_images/carpet_flash_detail.tif');
imwrite(F_detail, outputFdetail);

%% Call function to create flag to remove shadows and specularities from image
%A = im2double(imread('./sol_images/carpet_noflash.tif'));
%F = im2double(imread('./sol_images/carpet_flash.tif'));
inputA = './my_input/bottle4_ambient.tif';
inputF = './my_input/bottle4_flash.tif';
outputFlag = './my_output/bottle4_mask.tif';
A = im2double(imread(inputA));
F = im2double(imread(inputF));
flag = remSpecShad(A, F);
%imwrite(flag, './sol_images/carpet_mask_good.tif');
imwrite(flag, outputFlag);


%% Final function to produce detail transfer/noise-removed image
%M = im2double(imread('./sol_images/carpet_mask_good.tif'));
%A_NR = im2double(imread('./sol_images/carpet_joint_bilateral.tif'));
%A_Base = im2double(imread('./sol_images/carpet_ambient_bilateral.tif'));
%F_Detail = im2double(imread('./sol_images/carpet_flash_detail.tif'));
M = im2double(imread('./my_output/bottle4_mask.tif'));
A_NR = im2double(imread('./my_output/bottle4_joint_bilateral.tif'));
A_Base = im2double(imread('./my_output/bottle4_ambient_bilateral.tif'));
F_Detail = im2double(imread('./my_output/bottle4_flash_detail.tif'));
allM = zeros([size(M), 3]);
for i=1:3
    allM(:,:,i) = M;
end
A_Final = (1-allM) .* A_NR .* F_Detail + allM .* A_Base;
%imwrite(A_Final, './sol_images/carpet_final.tif');
imwrite(A_Final, './my_output/bottle4_final.tif');

% convert tiff images to jpegs to create a poster
imwrite(imread('./my_output/bottle4_ambient_bilateral.tif'), './my_output/jpeg/bottle4_ambient_bilateral.jpg');
imwrite(imread('./my_output/bottle4_final.tif'), './my_output/jpeg/bottle4_final.jpg');
imwrite(imread('./my_output/bottle4_joint_bilateral.tif'), './my_output/jpeg/bottle4_joint_bilateral.jpg');
imwrite(imread('./my_output/bottle4_flash_bilateral.tif'), './my_output/jpeg/bottle4_flash_bilateral.jpg');
imwrite(imread('./my_output/bottle4_flash_detail.tif'), './my_output/jpeg/bottle4_flash_detail.jpg');
imwrite(imread('./my_output/bottle4_ambient.tif'), './my_output/jpeg/bottle4_ambient.jpg');
imwrite(imread('./my_output/bottle4_mask.tif'), './my_output/jpeg/bottle4_mask.jpg');
imwrite(imread('./my_output/bottle4_flash.tif'), './my_output/jpeg/bottle4_flash.jpg');







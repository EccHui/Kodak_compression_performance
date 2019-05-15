clc;
clear;

path_now = mfilename('fullpath');
i = strfind(path_now,'\');
cd(path_now(1:i(end)))

addpath('.\msssim\')
img_root = [pwd '\Kodak\'];
imgs = dir([img_root '*.png']);
save_root = [pwd '\files\'];

bpp_count = 0;
ssim_count = 0;
%% bpg
bpg_root = [pwd '\others\bpg-0.9.8-win64\'];
bpg_enc = 'bpgenc.exe';
bpg_dec = 'bpgdec.exe';
if ~isdir([save_root, 'bpg'])
    mkdir([save_root, 'bpg']);
end
for quality = 29:1:51
    bpp_count = 0;
    ssim_count = 0;
    psnr_count = 0;
    for i = 1:1:length(imgs)
        img_name = imgs(i).name(1:end-4);
        if ~isdir([save_root, 'bpg\', img_name, '\'])
            mkdir([save_root, 'bpg\', img_name, '\']);
        end
        I = imread([img_root imgs(i).name]);
        % encode
        cmd = [bpg_root, bpg_enc, ' -o ', save_root, 'bpg\', img_name, '\', img_name, '_', ...
            num2str(quality), '.bpg',  ' -q ', num2str(quality), ' ', img_root, ...
            img_name, '.png'];
        system(cmd);
        img = dir([ save_root, 'bpg\', img_name, '\', img_name, '_', num2str(quality), '.bpg']);
        bpp_count = bpp_count + img.bytes*8/(512*768);
        % decode
        cmd = [bpg_root, bpg_dec, ' -o ', save_root, 'bpg\', img_name, '\', img_name, '_', ...
            num2str(quality), '.jpg', ' ', save_root, 'bpg\', img_name, '\', img_name, '_', ...
            num2str(quality), '.bpg'];
        system(cmd);
        im = imread([save_root, 'bpg\', img_name, '\', img_name, '_', num2str(quality), '.jpg']);
        ssim_count = ssim_count + msssim(I, im);
        psnr_count = psnr_count + psnr(im, I);
    end
    bpg(quality-28).bpp = bpp_count/length(imgs);
    bpg(quality-28).ssim = ssim_count/length(imgs);
    bpg(quality-28).psnr = psnr_count/length(imgs);
end

%% webp
webp_root = [pwd '\others\libwebp-1.0.0-windows-x64\bin\'];
webp_enc = 'cwebp.exe';
webp_dec = 'dwebp.exe';
if ~isdir([save_root, 'webp'])
    mkdir([save_root, 'webp']);
end
for quality = 1:1:80
    bpp_count = 0;
    ssim_count = 0;
    psnr_count = 0;
    for i = 1:1:length(imgs)
        img_name = imgs(i).name(1:end-4);
        if ~isdir([save_root, 'webp\', img_name, '\'])
            mkdir([save_root, 'webp\', img_name, '\']);
        end
        I = imread([img_root imgs(i).name]);
        % encode
        cmd = [webp_root, webp_enc, ' -q ', num2str(quality), ' ', img_root, ...
            img_name, '.png', ' -o ', save_root, 'webp\', img_name, '\', img_name, '_', ...
            num2str(quality), '.webp'];
        system(cmd);
        img = dir([save_root, 'webp\', img_name, '\', img_name, '_', num2str(quality), '.webp']);
        bpp_count = bpp_count + img.bytes*8/(512*768);
        % decode
        cmd = [webp_root, webp_dec, ' ', save_root, 'webp\', img_name, '\', img_name, '_', ...
            num2str(quality), '.webp', ' -o ', save_root, 'webp\', img_name, '\', img_name,...
            '_', num2str(quality), '.jpg'];
        system(cmd);
        im = imread([save_root, 'webp\', img_name, '\', img_name, '_', num2str(quality), '.jpg']);
        ssim_count = ssim_count + msssim(I, im);
        psnr_count = psnr_count + psnr(im, I);
    end
    webp(quality).bpp = bpp_count/length(imgs);
    webp(quality).ssim = ssim_count/length(imgs);
    webp(quality).psnr = psnr_count/length(imgs);
end

%% jpeg2000
jp2_root = [pwd '\others\openjpeg-v2.3.0-windows-x64\bin\'];
jp2_enc = 'opj_compress.exe';
jp2_dec = 'opj_decompress.exe';
if ~isdir([save_root, 'jpeg2000'])
    mkdir([save_root, 'jpeg2000']);
end
for quality = 20:1:40
    bpp_count = 0;
    ssim_count = 0;
    psnr_count = 0;
    for i = 1:1:length(imgs)
        img_name = imgs(i).name(1:end-4);
        if ~isdir([save_root, 'jpeg2000\', img_name, '\'])
            mkdir([save_root, 'jpeg2000\', img_name, '\']);
        end
        I = imread([img_root imgs(i).name]);
        % encode
        cmd = [jp2_root, jp2_enc, ' -i ', img_root, img_name, '.bmp',...
            ' -o ', save_root, 'jpeg2000\', img_name, '\', img_name, '_', num2str(quality),...
            '.j2k', ' -q ', num2str(quality)];
        system(cmd);
        img = dir([save_root, 'jpeg2000\', img_name, '\', img_name, '_', num2str(quality), '.j2k']);
        bpp_count = bpp_count + img.bytes*8/(512*768);
        % decode
        cmd = [jp2_root, jp2_dec, ' -o ', save_root, 'jpeg2000\', img_name, '\',...
            img_name, '_', num2str(quality), '.tif', ' -i ', save_root,...
            'jpeg2000\', img_name, '\', img_name, '_', num2str(quality), '.j2k'];
        system(cmd);
        im = imread([save_root, 'jpeg2000\', img_name, '\', img_name, '_', num2str(quality), '.tif']);
        ssim_count = ssim_count + msssim(I, im);
        psnr_count = psnr_count + psnr(im, I);
    end
    jpg2k(quality-19).bpp = bpp_count/length(imgs);
    jpg2k(quality-19).ssim = ssim_count/length(imgs);
    jpg2k(quality-19).psnr = psnr_count/length(imgs);
end

%% jpeg
jpeg_root = [pwd '\others\jpeg-9c\'];
jpeg_enc = 'cjpeg.exe';
jpeg_dec = 'djpeg.exe';
if ~isdir([save_root, 'jpeg'])
    mkdir([save_root, 'jpeg']);
end
for quality = 1:1:30
    bpp_count = 0;
    ssim_count = 0;
    psnr_count = 0;
    for i = 1:1:length(imgs)
        img_name = imgs(i).name(1:end-4);
        if ~isdir([save_root, 'jpeg\', img_name, '\'])
            mkdir([save_root, 'jpeg\', img_name, '\']);
        end
        I = imread([img_root imgs(i).name]);
        % encode
        cmd = [jpeg_root, jpeg_enc, ' -quality ', num2str(quality), ' ', ...
            img_root, img_name, '.bmp', ' ', save_root, 'jpeg\', img_name, '\', img_name, ...
            '_', num2str(quality), '.jpg'];
        system(cmd);
        img = dir([save_root, 'jpeg\', img_name, '\', img_name, '_', num2str(quality), '.jpg']);
        bpp_count = bpp_count + img.bytes*8/(512*768);
        im = imread([save_root, 'jpeg\', img_name, '\', img_name, '_', num2str(quality), '.jpg']);
        ssim_count = ssim_count + msssim(I, im);
        psnr_count = psnr_count + psnr(im, I);
    end
    jpeg(quality).bpp = bpp_count/length(imgs);
    jpeg(quality).ssim = ssim_count/length(imgs);
    jpeg(quality).psnr = psnr_count/length(imgs);
end

save('results.mat', 'bpg', 'jpeg', 'jpg2k', 'webp')
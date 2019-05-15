# Kodak_compression_approaches
This project is aiming on comparing image compression performance of different approaches on Kodak dataset.

The current compared approaches contain:
1) BPG (bpg-0.9.8 / https://bellard.org/bpg/)
2) Webp (libwebp-1.0.0 / https://github.com/webmproject/libwebp/releases)
3) JPEG (jpeg-9c / https://www.ijg.org/)
4) JPEG2000 (openjpeg-v2.3.0 / https://www.openjpeg.org/)

The compression with these methods is implemented on Matlab, and the details are in cmp_bpg_jpeg_jpg2000_webp.m .
A rate-distortion-curve which measured by MS-SSIM is shown in ssim_comp.m .

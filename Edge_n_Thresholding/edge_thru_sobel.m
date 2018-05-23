
% fortwnw thn eikona
xtx = imread('XT660X.jpg') ;
% vriskw ton fourier ths binary eikonas
xtx_Fou = fft2( im2bw(xtx), 375, 500) ;

% dhmiourgw to parathyro sobel
sobel = fspecial('sobel') ;
sob_Fou = fft2( sobel, 375, 500) ;
% vriskw ton fourier kai tou anastrofou sobel gia na vrw kai tis kathetes
% akmes
sob_FouVert = fft2( sobel', 375, 500) ;

figure(1); imshow(xtx);

% vriskw ton antistrofo fourier tou ginomenou eikonas kai sobel
xtx_sob = ifft2( sob_Fou.*xtx_Fou, 375, 500 ) ;
figure(2); imshow(xtx_sob) ; title('Image Filtered by Sobel');

% vriskw ton ant. fourier eikonas kai anastrofou sobel
xtx_sob_Vert = ifft2( sob_FouVert.*xtx_Fou, 375, 500) ; 
figure(3); imshow(xtx_sob_Vert); title('Image Filtered by Reverse Sobel');


% fortwnw thn eikona 
[ roloi ] = im2double( imread('images/clock.jpg')) ;
% rgn -> gray scale
roloi = rgb2gray(roloi) ;

% --------- 1a - anixneysh akmwn me Laplacian of Gaussian maska -----------

% 5x5 Laplacian of Gaussian mask
LapOG = [ 0, 0, -1, 0, 0; 0, -1, -2, -1, 0; -1, -2, 16, -2, -1; ...
    0, -1, -2, -1, 0; 0, 0, -1, 0, 0] ;

% anixneysh akmwn me Laplacian of Gaussian maska
roloiLOG = conv2( roloi( :, 1:300), LapOG, 'same') ;


figure(1)
subplot( 2, 1, 1)
imshow( roloi )
title('Original Image') ;
subplot( 2, 1, 2)
imshow( roloiLOG )
title('After LoG filtering') ;

% --------------- 1b - anixneysh akmwn me Sobel maska ---------------------
% https://www.tutorialspoint.com/dip/sobel_operator.htm

% horizontal mask of Sobel operator - highlights the horizontal edges
Sob_Hor = [ -1, -2, -1; 0, 0, 0; 1, 2, 1] ;
% vertical mask of Sobel operator - highlights the vertical edges
Sob_Ver = [ -1, 0, 1; -2, 0, 2; -1, 0, 1] ;


% efarmogh orizontias & katheths maskas
roloiSH( :, :, 1) = conv2( (roloi( :, 1:300, 1)), Sob_Hor, 'same');
roloiSV( :, :, 1) = conv2( roloi( :, 1:300, 1), Sob_Ver, 'same') ;

% elegxw kathe ena pixel kai pairnw to kanonikopoihmeno gradient magnitude
for i=1:size( roloi, 1)
    for j=1:size( roloi, 2)-1
        % normalized gradient magnitude -> G = sqrt( Gx^2 + Gy^2 )
        roloiS( i, j) = sqrt( roloiSH( i, j)^2 + roloiSV( i, j).^2 ) ;
    end
end

figure(2)
subplot( 2, 1, 1)
imshow( roloi )
title('Original Image') ;
subplot( 2, 1, 2)
imshow( roloiS )
title('After Sobel Filtering') ;

figure(3)
subplot( 2, 1, 1)
imshow( roloiLOG )
title('LoG Filtering') ;
subplot( 2, 1, 2)
imshow( roloiS )
title('Sobel Filtering') ;


%% ---------------- Olikh Katwfliwsh Filtrarismenwn Eikonwn ----------------


% ypologismos istogrammatos gia evresh katallhlhs timhs katwfliou
istoRL = imhist(roloiLOG( :, :, 1)) ;
istoRS = imhist(roloiS( :, :, 1)) ;

% katwfli ~ mesh timh kanonikopoihmenou istogrammatos + kati
roloiL_BW = roloiLOG > (mean(istoRL/(300*300)) + 0.21) ;
%roloiL_BW = im2bw( roloiL, mean(istoRL/(300*300)) + 0.08) ;
roloiS_BW = roloiS > (mean(istoRS/(300*300)) + 0.28) ;
%roloiS_BW = im2bw( roloiS, mean(istoRS/(300*300)) + 0.08) ;

figure(4)
subplot( 2, 1, 1)
imshow( roloiL_BW )
title('Thresholding using Laplacian Filter') ;
subplot( 2, 1, 2)
imshow( roloiS_BW )
title('Thresholding using Sobel Filtering') ;

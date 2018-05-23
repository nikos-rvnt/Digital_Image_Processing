% fortwnw thn eikona
[ fct ] = im2double( imread('images/factory.jpg')) ;
% rgb -> gray scale
fct = rgb2gray( fct ) ;

% ------------------------- Bhma 1 ----------------------------------------

% dhmiourgia leykou gaoussianou thoryvu me m.t. 0 & diaspora wste SNR = 10 
SNR_dB = 10 ;
% SNR = 10log(1/var) => var = 10^(-SNR/10)
diaspora_n = 10^(-SNR_dB/10);
leykos = sqrt(diaspora_n)*randn( size( fct ) ) + 0 ;

% ypovathmizw thn eikona me thn prosthiki thoryvou
fctWGN = fct + leykos ;

% thelw tetragwniko pinaka, kanw zero padding
% fctWGN = [ fctWGN; zeros( size( fctWGN, 2) - size( fctWGN, 1), size( fctWGN, 2))] ;
% leykos = [ leykos; zeros( size( leykos, 2) - size( leykos, 1), size( leykos, 2))] ;


% xwros syxnothtwn
fctWGN_F = fft( fft( fftshift( fctWGN ), [], 2), [], 1) ;
leykos_F = fft( fft( ( leykos ), [], 2), [], 1) ;

% fasma isxyos eikonas 
fctWGN_PS = (fctWGN_F).^2/(630*420) ;
% fasma isxyos thoryvou
leykos_PS = abs(leykos_F).^2/(630*420) ;
% fasma isxyos gia agnwsto thoryvo
white_PS = mean( mean( abs(fctWGN_F(3:32,3:32)).^2./(30*30))) ;

% fasma isxyos arxikhs eikonas me gnwsto to thoryvo
fct_PS = abs(fctWGN_PS - leykos_PS) ;
%fct_PS = (fctWGN_PS - diaspora_n^2) ;

% fasma isxyos arxikhs eikonas me agnwsto to thoryvo
fctUN_PS = abs(fctWGN_PS - white_PS) ;

% synarthsh metaforas Wiener
Hw = fct_PS./(fct_PS + leykos_PS) ;
%Hw = fct_PS./(fct_PS + diaspora_n^2) ;
HwUN = fctUN_PS./(fctUN_PS + white_PS ) ;

HW = Hw ;
HWUN = HwUN ;

% % antistrofos fourier + zero padding sthn kontinoterh dynamh tou 2
% hw = ifft( ifft( Hw, [], 2), [], 1) ;
% hw = [ hw, zeros( 420, 1024-630); zeros(512-420,1024)] ;
% hwUN = ifft( ifft( HwUN, [], 2), [], 1) ;
% hwUN = [ hwUN, zeros( 420, 1024-630); zeros(512-420,1024)] ;

% % fourier 
% HWUN = fft( fft( hwUN, [], 2), [], 1) ;
% HW = fft( fft( hw, [], 2), [], 1) ;
% 
% % zero padding
% fctWN = [ fctWGN, zeros( 420, 1024-630); zeros(512-420,1024)] ;
% fctWGN_F = fft( fft( fftshift(fctWN), [], 2), [], 1) ;

% proseggish arxikhs eikonas f
fctE_F = HW.*fctWGN_F ;
fctE = fftshift( ifft( ifft(fctE_F, [], 2), [], 1) ) ;

% proseggish arxikhs eikonas f me agnwsto to thoryvo
fctEUN_F = HWUN.*fctWGN_F ;
fctEUN = fftshift( ifft( ifft(fctEUN_F, [], 2), [], 1) ) ;

figure(1)
subplot( 2, 1, 1)
imshow( fctE(1:420, 1:630) )
title('Original Image Estimation (with noise knowledge)') ;
subplot( 2, 1, 2)
imshow( fctWGN(1:420, 1:630) )
title('Original Image + white noise') ;

figure(2)
subplot( 2, 1, 1)
imshow( fctEUN(1:420,1:630) )
title('Original Image Estimation (no noise knowledge)') ;
subplot( 2, 1, 2)
imshow( fctWGN(1:420,:) )
title('Original Image + white noise') ;


%% ------------------------ Bhma 2 ----------------------------------------

% ypovathmizw thn eikona
fctG = psf( fct ) ;

% dinw eisodo kroustikh synarthsh gia na parw eksodo kroustikh apokrish
kroust = zeros( size(fct) ) ;
kroust( 1, 1) = 1 ; 
hpsf = psf( kroust ) ;
Hpsf = fft( fft( ( (hpsf)), [], 2), [], 1) ;

% metafora sto pedio syxnothtas gia na vrw thn Hpsf
fctGF = fft( fft( ( (fctG)), [], 2), [], 1) ;
fctF = fft( fft( (fctWGN), [], 2), [], 1) ;

% apeikonish apokrishs syxnothtas
figure(3)
imshow( 10*log10(Hpsf)) ;
title('Frequency Response Hpsf') ;

% efarmogh antistrofou filtrou xwris katwfli
fctEST_F = (Hpsf.^-1.*fctGF ) ;
fctEST = ( ifft( ifft( fctEST_F, [], 2), [], 1)) ;

figure(4)
subplot( 2, 1, 1)
imshow( fct )
title('Original Image (no noise)') ;
subplot( 2, 1, 2)
imshow( fctEST )
title('Original Image Estimation thru Inv. Filtering(no threshold)') ;


% orizw katwfli 
thres1 = 0.85 ; 

% efarmozw to antistro filtro
[ fctEST ] = invFthres( Hpsf, fctGF,  thres1) ;

% minimum mean square error
MSE1 = mean( mean( abs(fct - fctEST).^2 )) ;


figure(5)
subplot( 2, 1, 1)
imshow( fctEST ) ;
title('katwfli: 0.85') ;
subplot( 2, 1, 2)
imshow( fct ) ;
title('Original Image') ;

% orizw katwfli 
thres2 = .38 ; 

% efarmozw to antistro filtro
[ fctEST] = invFthres( Hpsf, fctGF,  thres2) ;

% minimum mean square error
MSE2 = mean( mean( abs(fct - fctEST).^2 )) ;

figure(6)
subplot( 2, 1, 1)
imshow( fctEST ) ;
title('katwfli: 0.38') ;
subplot( 2, 1, 2)
imshow( fct ) ;
title('Original Image') ;

% orizw katwfli 
thres3 = 0.18 ; 

% efarmozw to antistro filtro
[ fctEST] = invFthres( Hpsf, fctGF,  thres3) ;

% minimum mean square error
MSE3 = mean( mean( abs(fct - fctEST).^2 )) ;

figure(7)
subplot( 2, 1, 1)
imshow( fctEST ) ;
title('katwfli: 0.18 ') ;
subplot( 2, 1, 2)
imshow( fct ) ;
title('Original Image') ;

% orizw katwfli 
thres4 = 0.09 ; 

% efarmozw to antistro filtro
[ fctEST ] = invFthres( Hpsf, fctGF ,  thres4) ;

% minimum mean square error
MSE4 = mean( mean( abs(fct - fctEST).^2 )) ;
 
figure(8)
subplot( 2, 1, 1)
imshow( fctEST ) ;
title('katwfli: 0.09 ') ;
subplot( 2, 1, 2)
imshow( fct ) ;
title('Original Image') ;

% orizw katwfli 
thres5 = 0.024 ; 

% efarmozw to antistro filtro
[ fctEST ] = invFthres( Hpsf, fctGF ,  thres5) ;

% minimum mean square error
MSE5 = mean( mean( abs(fct - fctEST).^2 )) ;
 
figure(9)
subplot( 2, 1, 1)
imshow( fctEST ) ;
title('threshold: 0.024 ') ;
subplot( 2, 1, 2)
imshow( fct ) ;
title('Original Image') ;

thresholds = [ thres1, thres2, thres3, thres4, thres5] ;
MSEs = [ MSE1, MSE2, MSE3, MSE4, MSE5] ; 
figure(10)
plot( thresholds, MSEs)
title('MSE ws pros to katwfli') ;
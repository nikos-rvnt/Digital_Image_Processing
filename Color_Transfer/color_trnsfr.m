
% --> oi dyo eikones pou xrhsimopoiithikan, lifthikan apo thn bash eikonwn :
% http://sipi.usc.edu/database/
im1 = im2double(imread('4.2.01.tiff')) ;
im2 = im2double(imread('house.tiff')) ;

% anakataskevazw tous pinakes wste kathe stili tou kainouriou na einai o 
%pinakas kathe xrwmatos tou paliou me thn mia sthlh tou katw ap thn allh
source_rgb = reshape(im1,[],3);
target_rgb = reshape(im2,[],3);

% o parakatw pinakas dinei to sxhma LMS = RGB_2_LMS*RGB
RGB_2_LMS = [0.3811 0.5783 0.0402; 0.1967 0.7244 0.0782; 0.0241 0.1288 0.8444] ;

source_lms = RGB_2_LMS*source_rgb' ;
target_lms = RGB_2_LMS*target_rgb' ;

% metatrepoume sto logarithmiko xwro gt ta dedomena parousiazoun assymetria
source_lms = log10(source_lms) ;
target_lms = log10(target_lms) ;

% oi parakatw dyo pinakes dinoun to sxhma Lab = Lab1*Lab2*LMS
Lab1 = [1/sqrt(3) 0 0; 0 1/sqrt(6) 0; 0 0 1/sqrt(2)] ;
Lab2 = [1 1 1; 1 1 -2; 1 -1 0] ;

% metatrepoume ston Lab xwro
source_Lab = Lab1*Lab2*source_lms ;
target_Lab = Lab1*Lab2*target_lms ;

% briskw th mesh timh kai thn afairw apo ta stoixeia tou source
source_LabC = source_Lab - repmat( mean( source_Lab, 2), 1, 262144) ;

% briskw ta std twn source kai target kai kanw std_target/std_source
source_std = std( source_Lab', 1) ;
target_std = nanstd( target_Lab', 0) ;

std_ts = target_std./source_std ;

metatropi = zeros( 3, 262144);
for rgb = 1:3
    metatropi( rgb, :) = source_LabC( rgb, :)*std_ts( 1, rgb) + mean(target_Lab(rgb,:), 2);
end

% afou kaname th metatropi pame pisw ston xwro LMS pol/zontas me tous
% parakatw dyo pinakes :
lms1 = [1 1 1; 1 1 -1; 1 -2 0] ;
lms2 = [sqrt(3)/3 0 0; 0 sqrt(6)/6 0; 0 0 sqrt(2)/2] ;

metatropi_lms = lms1*lms2*metatropi ;
%epeidh prin perasame ston logarithmiko xwro kanume t antistrofo
metatropi_lms = 10.^metatropi_lms ;

% kai telos epistrefoume ston RGB xwro
lms2rgb = [4.4679 -3.5873 0.1193; -1.2186 2.3809 -0.1624; 0.0497 -0.2439 1.2045] ;
metatropi_RGB = lms2rgb*metatropi_lms ;

% telos ta 3 dianysmata ta epanaferw sth morfh 3 pinakwn gia thn
% metasxhmatismenh eikona
metatropi_IM = reshape( metatropi_RGB', 512, 512, 3) ;

%mporoume na doume to apotelesma :
figure(1)
imshow('house.tiff')
title('Source Image');

figure(2)
imshow('4.2.01.tiff')
title('Target Image')

figure(3)
imshow(metatropi_IM)
title('Produced Image')

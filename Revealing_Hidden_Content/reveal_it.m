
% fortwnw thn eikona 
[ circle ] = load('images/circle.mat') ;
cir = circle.circle ;

% o pinakas einai double kanw ta stoixeia tou akeraia
cirH = floor(cir*255) + 1 ;
% sarwnw thn eikona me parathyro 3x3 gia na vrw to istogramma
histo = zeros( 256, 1) ;
wind = zeros( 3, 3) ;
% zero padding ton pinaka, gia 3x3 parathyro 2 epipleon sthles
% (aristera-deksia) kai 2 epipleon grammes (panw-katw)
cirZP = [ zeros( 1, 258); zeros( 256, 1), cir, zeros( 256, 1); zeros( 1, 258)];
% o pinakas einai double kanw ta stoixeia tou akeraia
cirH = floor(cirZP*255) + 1 ;

% apo aristera sta deksia ana 3 pixel
for i=1:3:size( cirH, 2)
    % apo panw pros ta katw ana 3 pixel
    for j=1:3:size( cirH, 1)
        wind = cirH( i:i+2, j:j+2) ;
        for ii=1:3
            for jj=1:3
                temp = wind( ii, jj) ;
                histo( temp, 1) = histo( temp, 1) + 1 ;                
            end
        end
    end
end

% kanonikopoiw to istogramma diairwntas me to plithos twn pixel
histoN = histo./( size( cir, 1)*size( cir, 2) ) ;

% epalithevw to istogramma 
%isto = imhist( cir ) ;


% --- local histogram equalisation -------

for i=1:size( cirZP, 2)-2
    for j=1:size( cirZP, 1)-2
        
        cumF = zeros( 1, 256) ;
        
        for iw=1:3
            for jw=1:3
                temp = cirH( iw+i-1, jw+j-1) ;
                cumF( 1, temp) = cumF( 1, temp) + 1 ;
            end
        end
        % athroistiko istogramma
%         for cu=2:256
%            cumF( 1, cu) = cumF( 1, cu) + cumF( 1, cu-1) ; 
%         end
        cirHEL( i, j) = floor( cumF( 1, cirH( 2+i-1, 2+j-1))/(3*3)) ;
    end
end

figure(1)
subplot( 1, 2, 1)
imshow( cir )
title('Firstly') ;
subplot( 1, 2, 2)
imshow( cirHEL )
title('After local histogram equalization') ;


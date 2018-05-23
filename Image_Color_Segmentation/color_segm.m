
% --> Erwtima 4: tmimatopoieiste mia eikona me ton k-means - 8 RGB times
% fortwsi ths eikonas
IM = imread('1973510495.jpg') ;
IM = double(IM) ;
% anakataskevazw ton pinaka ths arxikhs eikonas kanontas ton 2 diastasewn
grammes = size( IM, 1) ;
stiles = size( IM, 2) ;
IMA = reshape( IM, grammes*stiles, 3) ;

% arithmos xrwmatwn gia tmhmatopoihsh 
ar_xrwmatwn = 8 ;

% trexw ton kmeans
% evala na typwnontai kapoia statistika opws sto poses epanalipseis kathe
% fora sygklinei o algorithmos
options = statset( 'Display', 'iter', 'MaxIter', 120) ;
[ idx, cent] = kmeans( IMA, ar_xrwmatwn, 'distance', 'sqEuclidean', 'Options', options, 'Replicates', 3, 'EmptyAction', 'singleton') ;

% anakataskevazw ton pinaka ths eikonas
IM_anak = reshape( idx, grammes, stiles) ;
imshow( IM_anak, []);

% kanw anakataskevh kathe ksexwrisths tmhmatopoihshs dhladh enas pinakas   
% gia kathe xrwma
tmhmatopoihsh = cell( 1, 8);
rgb_etiketa = repmat( IM_anak, [1 1 3]);

% apomonwnw kathe ena xrwma pou exei tmhmatopoihthei
for k = 1:ar_xrwmatwn
    xrwma = IM;
    xrwma(rgb_etiketa ~= k) = 0;
    tmhmatopoihsh{k} = xrwma;
    figure(k)
    imshow(tmhmatopoihsh{k}) 
end

% --> ERWTIMA 5 - ylopoihste to color structure histogram gia parathyro 3x3 kai
% kvantish se 8 xrwmata


% arxikopoihsh parathyrou 3x3
window = zeros( 3, 3) ;
% diansyma sthlh 8 thesewn - metrhths emfanishs twn 8 RGB xrwmatwn
colors = zeros( 8, 1) ;

% sarwnw olo ton pinaka eikonas ana sthles ksekinontas apo panw aristera
% kai proxwrwntas pros ta deksia
for i=1:3:336    
        for j=1:3:480
            % vazw tis antistoixes times sto parathyro
            window = IM_anak( i:i+2, j:j+2) ;
                % gia kathe timh tou parathryou ayksanw ton metrhth tou
                % antistoixou xrwmatos sto dianysma colors
                for wr=1:3
                    for wc=1:3
                        colors( window( wr, wc)) = colors( window( wr, wc)) + 1 ;
                    end
                end
        end   
end

% apo thn 3x3 sarwsh emeine eksw h teleytaia grammh thn opoia sarwnw
% ksexwrista kai leitourgw antistoixa me prin
for j=1:480
           colors( IM_anak( 337, j)) = colors( IM_anak( 337, j)) + 1 ;
end 

% kai to color structure histogram se grafikh apeikonish
figure(9)
bar(colors) ;
title('color structure histogram')
[ meshIM, Q, W] = training();

C_test = zeros( 10304, 40);
folder = 'testing_images';

for k = 1:40
  onomaIM = sprintf('s%d.2.tif', k); % to onoma ths eikonas
  fullFileName = fullfile( folder, onomaIM); %enwnei to path tou dir me t onoma ths eikonas
  IM = imread(fullFileName); % diabazei thn eikona

  C_test( :, k) = reshape( IM, 10304, 1);
  %imshow(IM);
end
        

% bhma 1: afairw apo kathe eikona th mesh timh twn eikonwn ths ekpaideyshs
V_test = zeros( 10304, 40);
for i=1:10304
   V_test( i, :) = C_test( i, :) - meshIM; % afairw apo kathe dian. thn mesh timi
end


% bhma 2: proballw to dianysma V ston ypoxwro Rk
W_test = zeros( 10, 40);
for ii=1:40
   W_test( :, ii) = Q'*V_test( :, ii);   % dhladh w = Q'*V     
end

V_rshp = zeros( 10304, 40);
for ii=1:40
   V_rshp( :, ii) = Q*W_test( :, ii);  % h anakataskevh tou V_test = Qk*w    
end


% bhma 3: ypologizw thn elaxisth apostash anamesa sta W_test - W

eL = 0; % arxikopoihsh elaxisths apostashs
for i = 1:10
    temp = norm( W_test( i, :) - W( i, :)); % briskw thn elaxisth apostash
                                            % anamesa sth sympiesmenh morfh
    if (i>2)&&(temp<eL)                     % kathe eikonas tou testing kai
        eL = temp;                          % tou training me norma2
    elseif (i==1)
       eL = temp; 
    end
end


% bhma 4: lynw to problhma beltistopoihshs me synthikes

W_testNORM = zeros( 10, 40);
W_NORM = zeros( 10, 40);
for i =1:10
    W_testNORM( i, :) = W_test( i, :)/norm(W_test( i, :));   % kanonikopoiw ta sympiesmena                         
    W_NORM( i, :) = W( i, :)/norm(W( i, :));                 % dianysmata W_test & W
end

W_NORM = sort( W_NORM ); % taksinomw ton pinaka sympiesmenwn dianysmatwn


P = zeros( 40, 40);    % 40 dianysmata mhkous 40 to kathena pou prokyptoun
P = W_testNORM'*W_testNORM;   % ap ton pollaplasiasmo twn W_testNORM*W_NORM

ro = zeros( 40, 1);
lamd = zeros( 40, 1);
RV = V_rshp'*Q*Q'*V_rshp;   % o logos tou Rayleigh
for i=1:40
    ro( i, 1) = max( P( :, i)); % oi times pou pairnei to ro einaiapo th diagwnio tou P
    lamd( i, 1) = max( RV( :, i)); % oi idiotimes
end                            

sfalma = min(norm(ro-lamd));
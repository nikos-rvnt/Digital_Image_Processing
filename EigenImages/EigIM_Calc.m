%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Panepisthmio Patrwn 
%                             DPMS - SESE
%               Psifiakh Epeksergasia & Analysh Eikonas
%
%                    2h Ergasthriakh Askhsh 2016-17
%        ->  Anaktisi Eikonas Apo Bash Dedomenwn me Xrhsh PCA  <-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------- Meros A: Ekpaideysh - ypologismos PCA pinaka eikonwn ----------

% dhmiourgia enos struct gia na fortwthei to Database 
Database_IM = dir('./IMAGES/DataBase') ;

% diagrafh twn 3 akyrwn arxeiwn pou fortwnontai, ta '.', '..' & 'Thumbs.db'
Database_IM(1:3) = [] ;


if( exist('IMAGES/DataBase','dir'))
    cd ./IMAGES/DataBase 
    for db=1:length(Database_IM)

        % fortwnontai oi eikones ths bashs se 1 epipleon pedio sto struct
        Database_IM(db).image = im2double( imread( Database_IM(db).name)) ;

        %  allagh xrwmatikou xwrou rgb -> gray
        Database_IM(db).imageG = rgb2gray( Database_IM(db).image ) ;
        
        % dhmiourgia leykou gaussianu thoryvou gia SNR = [0,10,20]
        SNR = 8 ;
        P0 = sum( abs(Database_IM(db).imageG(:)).^2)/10000 ; % var( eikonaG(:) ) ;
        N0 = P0/(10^(SNR/10)) ;
        [ gr, st] = size( Database_IM(db).imageG ) ;
        leykos = sqrt(N0)*randn( gr, st ) ;

        % prosthiki tou thoryvou sthn eikona
        Database_IM(db).imageWGN = Database_IM(db).imageG + leykos ;
    end
    cd ..
    cd ..
    
else    
    fprintf(' O fakelos ths bashs eikonwn den yparxei. ');

end

% arxikopoihsh pinaka pou kathe stili tou einai h kathe eikona
vec_images = zeros( 10000, length(Database_IM)) ;

% metatropi kathe eikonas se stili ston pinaka vec_images
for db=1:length(Database_IM)
    temp = Database_IM(db).imageG ;
    vec_images( :, db) = reshape( temp, 10000, 1) ;              
end      

% afairesh meshs eikonas apo kathe eikona
vec_imagesZM = vec_images - repmat( mean( vec_images, 2), 1, 100) ;

% ypologismos mhtrwou syndiasporas twn eikonwn
% kanonika prepei na vrw to C1=V*V' alla epeidh tha vgei poly megalo tha
% ypologisw to C2=V'*V pou tha xei idies idiotimes kai ta idiodianysmata tou
% C1 syndeontai me tou C1 ws q = (1/li)*V*p , me p idiodianysma tou C2
cov_im = (1/99)*(vec_imagesZM'*vec_imagesZM) ;

% ypologismos idiodianysmatwn tou pinaka syndiasporas
[ Prins, EiV] = eig( cov_im ) ;
 
% o pinakas twn idiotimwn ws dianysma, isxyei sqrt(var(i)) = idiotimh(i)
EiV = diag( EiV ) ;
 
% taksinomhsh se fthinousa seira giati h eig() ta epistrefei se ayksousa
[ junk, rindices] = sort( EiV, 'descend') ;
EiV = EiV(rindices) ;
Prins = Prins( :, rindices) ;

% krathma 2, idiotimwn elaxisto plithos wste oi eikones diaxwrisimes
plithosEIG = 5 ;
lamda = EiV( 1:plithosEIG, 1) ; % krataw tis 10 meg. idiotimes 
Q = zeros( 10000, plithosEIG) ;

% ypologismos twn idiodianysmatwn tou V*V' --> xwros idioeikonwn
for i=1:plithosEIG
    % Q = (1/lamda)*V*P , P -> idiodianysmata tou Vec'*Vec
    %Q( :, i) = (1/lamda( i, 1))*vec_imagesZM*Percs( :, i); 
    Q( :, i) =  vec_imagesZM*Prins( :, i); 
%     % kanonikopoihsh wste ||Q(i)||=1
%     Q( :, i) = Q( :, i)/norm(Q( :, i)) ;

end


% sympiesmenh morfh dianysmatwn vec_images,10000x100 -> 10x100(10 idiotimes)
Wtr = zeros( plithosEIG, 100);
for ii=1:100
   % sympiesmeno dianysma apoklisis
   Wtr( :, ii) = Q'*vec_imagesZM( :, ii);      
   % kanonikopoihsh toy dianysmatos wste |wi| = 1
   Wtr( :, ii) = Wtr( :, ii)./norm( Wtr( :, ii), 2) ;
end

% provolh twn eikonwn ston xwro twn Prins
%Prins( :, :) = 0 ;
%signals = vec_imagesZM*Prins( :, 1:5) ;
signals = Prins( :, :)'*vec_imagesZM' + repmat( mean( vec_images, 2), 1, 100)' ;


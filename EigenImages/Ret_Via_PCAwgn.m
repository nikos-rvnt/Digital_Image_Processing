%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Panepisthmio Patrwn 
%                             DPMS - SESE
%               Psifiakh Epeksergasia & Analysh Eikonas
%
%                    2h Ergasthriakh Askhsh 2016-17
%        ->  Anaktisi Eikonas Apo Bash Dedomenwn me Xrhsh PCA  <-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------- Meros A: Ekpaideysh - ypologismos PCA pinaka eikonwn ----------

% kaleitai to arxeio EigIM_Calc opou ginetai h ekpaideysh
EigIM_Calc ;


% ----------------- Meros B: Anagnwrish Eikonas ---------------------------

% % parathyro pou eisagei o xrhsths poia eikona thelei na anaktisei
% prompt = {'Dwste ton arithmo ths eikonas pou thelete (1-100):'};
% dlg_title = 'Input';
% num_lines = 1;
% defaultans = {'24'};
% answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
% eikona = str2num( cell2mat(answer)) ;

% 100 ylopoihseis anagnwrishs olwn twn eikonwn gia akriveia pososto anakt.
realizations = 100 ;

% arxikopoihsh metrhth gia krathma swsta anakthmenwn eikonwn & ypologismo
% posostou epityxous anakthshs
count2 = zeros( 1, realizations) ;

for real=1:realizations 

for ima=1:length(Database_IM)

if( exist('IMAGES/DataBase','dir'))
    cd ./IMAGES/DataBase 

    % fortwsh ths eikonas pou epelekse o xrhsths
    eikona = im2double( imread( Database_IM(ima).name)) ;

    %  allagh xrwmatikou xwrou rgb -> gray
    eikonaG = rgb2gray( eikona ) ;
    
    % dhmiourgia leykou gaussianu thoryvou gia SNR = [0,10,20]
    SNR = 20 ;
    P0 = sum( abs(eikonaG(:)).^2)/10000 ; % var( eikonaG(:) ) ;
    N0 = P0/(10^(SNR/10)) ;
    [ gr, st] = size( eikonaG ) ;
    leykos = sqrt(N0)*randn( gr, st ) ;

    % prosthiki tou thoryvou sthn eikona
    eikonaWGN = eikonaG + leykos ;

    cd ..
    cd ..
    
else    
    fprintf(' O fakelos ths bashs eikonwn den yparxei. ');

end

% eikona apo pinakas -> sthlh
eikonaSt = reshape( eikonaWGN, 10000, 1) ;              

% afairesh meshs eikonas (mesh timh vec_images)  
eikonaZM = eikonaSt - mean( vec_images, 2) ;

% provolh ths eikonas ston xwro twn idioeikonwn
Wima = Q'*eikonaZM ;

% anakataskevh apo ton xwro twn idioeikonwn(Q symmetrikos thetika orismenos)
eikonaRe = Q*Wima ; 

% ypologismos elaxisths apostashs W - Wima
dist = zeros( 100, 1) ;
for ii=1:100
    
    dist( ii, 1) = norm( Wtr( :, ii) - Wima ) ;
end

% elaxisth apostash --> to W ths antistoixhs eikonas sth vash 
[ elax, thesi] = min( dist ) ;
anakthsh = Database_IM(thesi).image ;

% elegxos orthotitas gia anaktimenh gia pososto epityxous anakthshs
if( isequal( thesi, ima) )
    count2(real) = count2(real) + 1 ;
end

end

end

% meso pososto epityxous anakthshs
pea2 = sum( count2(:))/realizations ;


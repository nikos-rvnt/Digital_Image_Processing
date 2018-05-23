function [ meshIM, Q, W] = training()

    C = zeros( 10304, 40);
    folder = 'training_images';

    % bhma 1
    for k = 1:40
      onomaIM = sprintf('s%d.1.tif', k); % to onoma ths eikonas
      fullFileName = fullfile( folder, onomaIM); %enwnei to path tou dir me t onoma ths eikonas
      IM = imread(fullFileName); % diabazei thn eikona

      % bhma 2: fortwnume tis eikones ston pinaka C
      C( :, k) = reshape( IM, 10304, 1);
      %imshow(IM);
    end 

    % bhma 3: ypologizw th mesh timh
    meshIM = mean(C);
    V = zeros( 10304, 40);
    % bhma 4: afairw apo kathe eikona th mesh timh
    for i=1:10304
       V( i, :) = C( i, :) - meshIM; % afairw apo kathe dian. thn mesh timi
    end

    % bhma 5: ypologizw to mhtrwo syndiasporwn
    Csyn = V*V'; % mhtrwo syndiasporwn

    % bhma 6: ypologismos idiodianysmatwn

    Cmik = V'*V; %pairnw ayto to mitrwo gt thelw na ypologisw ta idiodianysmata
                 %alla gia 10304x10304 h polyplokotita prof. einai terastia


    [ D, P] = eig( Cmik, 'nobalance'); % pairnw tis idiotimes P & ta idiodianysmata D


    % bhma 7: ypologismos twn idiodianysmatwn Q/idioproswpa

    lamda = zeros( 10, 1);  % krataw tis 10 meg. idiotimes aptis 40 ( 10<=40 )
    Q = zeros( 10304, 10);

    for i=1:10
        lamda( i, 1) = P( 30+i, 30+i);
        Q( :, i) = (1/lamda( i, 1))*V*D( :, 30+i); % ta idioproswpa
    end


    % bhma 8: ypologismos sympiesmenhs morfhs dianysmatwn Vi

    W = zeros( 10, 40);
    for ii=1:40
       W( :, ii) = Q'*V( :, ii); % sympiesmeno dianysma apoklisis     
    end

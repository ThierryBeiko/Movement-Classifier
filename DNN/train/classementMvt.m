cercle=fopen('cercle.txt','r');
rotation= fopen('rotationDroite_gauche.txt','r');
swipeGD=fopen('swipeDroit_Gauche.txt','r');
swipeHB=fopen('swipeHaut_Bas.txt','r');
trainX = fopen('X_train.txt','w');
trainy = fopen('y_train.txt','w');

for i=1:20
    if mod(i,2)==0
        for j = 1:100
            line = fgetl(cercle);
            fwrite(trainX,line);
            fprintf(trainX,"\r\n");            
        end
        fprintf(trainy,"0\r\n");
        for j =1:100
            line=fgetl(rotation);
            fwrite(trainX,line);
            fprintf(trainX,"\r\n");
        end
        fprintf(trainy,"3\r\n");
        for j = 1:100
            line = fgetl(swipeGD);
            fwrite(trainX,line);
            fprintf(trainX,"\r\n");          
        end
        fprintf(trainy,"2\r\n");
        for j = 1:100
            line = fgetl(swipeHB);
            fwrite(trainX,line);
            fprintf(trainX,"\r\n");
        end
        fprintf(trainy,"6\r\n");
    else
        for j =1:100
            line=fgetl(rotation);
            fwrite(trainX,line);
            fprintf(trainX,"\r\n");
        end
        fprintf(trainy,"4\r\n");
        for j = 1:100
            line = fgetl(swipeGD);
            fwrite(trainX,line);
            fprintf(trainX,"\r\n");
        end
        fprintf(trainy,"1\r\n");
        for j = 1:100
            line = fgetl(swipeHB);
            fwrite(trainX,line);
            fprintf(trainX,"\r\n");
        end
        fprintf(trainy,"5\r\n");
    end
end

fclose('all');
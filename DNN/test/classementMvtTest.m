cercle=fopen('cercleTest.txt','r');
rotation= fopen('rotationDroite_gaucheTest.txt','r');
swipeGD=fopen('swipeDroit_GaucheTest.txt','r');
swipeHB=fopen('swipeHaut_BasTest.txt','r');
testX = fopen('X_test.txt','w');
testy = fopen('y_test.txt','w');

for i=1:10
    if mod(i,2)==0
        for j = 1:100
            line = fgetl(swipeGD);
            fwrite(testX,line);
            fprintf(testX,"\r\n");
        end
        fprintf(testy,"2\r\n");
        for j =1:100
            line=fgetl(rotation);
            fwrite(testX,line);
            fprintf(testX,"\r\n");
        end
        fprintf(testy,"3\r\n");
        for j = 1:100
            line = fgetl(swipeHB);
            fwrite(testX,line);
            fprintf(testX,"\r\n");
        end
        fprintf(testy,"6\r\n");
        for j = 1:100
            line = fgetl(cercle);
            fwrite(testX,line);
            fprintf(testX,"\r\n");
        end
        fprintf(testy,"0\r\n");
    else
        for j = 1:100
            line = fgetl(swipeGD);
            fwrite(testX,line);
            fprintf(testX,"\r\n");
        end
        fprintf(testy,"1\r\n");
        for j =1:100
            line=fgetl(rotation);
            fwrite(testX,line);
            fprintf(testX,"\r\n");
        end
        fprintf(testy,"4\r\n");
        for j = 1:100
            line = fgetl(swipeHB);
            fwrite(testX,line);
            fprintf(testX,"\r\n");
        end
        fprintf(testy,"5\r\n");
    end
end

fclose('all');
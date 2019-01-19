trainy = fopen('y_test_reduit.txt','w');

for i=1:10
    if mod(i,2)==0
            fprintf(trainy,"2\r\n");
        
            fprintf(trainy,"3\r\n");
            
            fprintf(trainy,"6\r\n");

            fprintf(trainy,"0\r\n");
        
    else
            fprintf(trainy,"1\r\n");

            fprintf(trainy,"4\r\n");

            fprintf(trainy,"5\r\n");

    end
end

fclose('all');
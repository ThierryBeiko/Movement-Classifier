clear all
clc

delete(instrfind({'Port'},{'COM4'}));
serialPort = serial('COM4');
set(serialPort,'BaudRate',38400);
i = 1;    
j = 0;  
ax = 1;
mx = 1;
gx = 1;
capteur = 0;
ca = 0;
cg = 0;
Accel1 = 0;
Accel2 = 0;
Accel3 = 0;
gyro1 = 0;
gyro2 = 0;
gyro3 = 0;
limite1 = 50;
limite2 = 80;
resetCalibA =0;
resetCalibG =0;
acquisitionA = 0;
acquisitionG =0;
flagCalib = 0;
Start = 0;
    fopen(serialPort);
    Ax = fopen('Ax.txt', 'w');
    Ay = fopen('Ay.txt', 'w');
    Az = fopen('Az.txt', 'w');
    Gx = fopen('Gx.txt', 'w');
    Gy = fopen('Gy.txt', 'w');
    Gz = fopen('Gz.txt', 'w');
    while (i == 1 ) 
        A = fscanf(serialPort);
        A2 = A(1);    
        if (A2 == 'A')
            capteur = 1;
        end
         if (A2 == 'G')
           capteur = 3;
        end
        A1 = str2num(A(2:end));
        if size(A1) ~= [0 , 0];
        a1 = A1(1,1);
        a2 = A1(1,2);
        a3 = A1(1,3);
        end  
        if (capteur == 1)
         if ca < limite1 
              ca = ca+1;
         end
 
         if (limite1 <= ca && ca <limite2)
         Accel1 = (Accel1+a1);
         Accel2 = (Accel2+a2);
         Accel3 = (Accel3+a3);
         ca = ca+1;
         resetCalibA = 0;
         end
         if(ca == limite2)
            Start = 1;
            ca= ca+1;
         end
          if (ca >= limite2)
          j=j+1;
         if(Start == 1)
            Start = 0
         end
          if (abs(a3-Accel3/30) > 10)
             abs(a3-Accel3/30)
             acquisitionA = 1; 
             
          end
          if (acquisitionA ==1)
            Accelx (ax)= round(a1-Accel1/30);
            Accely (ax)= round(a2-Accel2/30);
            Accelz (ax)= round(a3-Accel3/30);
            ax = ax+1;
            resetCalibA = resetCalibA+1;
            if resetCalibA == 70
            ca = limite1;
            flagCalib = 1;
            Accel1 =0;
            Accel2 =0;
            Accel3 =0;
            end
          end
         if (acquisitionA == 0)
%             Accelx (ax)= 0;
%             Accely (ax)= 0;
%             Accelz (ax)= 0;
%             ax = ax+1;
          end
          end
        end
        if (capteur == 3)
        if cg < limite1 
             cg = cg+1;
        end
        if (limite1 <= cg && cg  <limite2) 
        gyro1 = (gyro1+a1);
        gyro2 = (gyro2+a2);
        gyro3 = (gyro3+a3);
        cg = cg+1;
        end   
        
        if (cg >=limite2)
          j=j+1;

if (acquisitionA ==1)
        gyrox (gx)= round(a1-(gyro1/30));
        gyroy (gx)= round(a2-(gyro2/30));
        gyroz (gx)= round(a3-(gyro3/30));
        gx = gx+1;
end
         if (acquisitionA == 0)
%             gyrox (gx)= 0;
%             gyroy (gx)= 0;
%             gyroz (gx)= 0;
%             gx = gx+1;
         end
         if (flagCalib ==1) 
         cg = limite1;
         flagCalib=0;
         acquisitionA = 0;
         gyro1 =0;
         gyro2 =0;
         gyro3 =0;
         end
        end
        end
    if j == 700
    i = 0;
    end
    end 
    
   for i = 1:size(Accelx)
         fprintf(Ax,'%2.2f\n', Accelx);
         fprintf(Ay,'%2.2f\n', Accely);
         fprintf(Az,'%2.2f\n', abs(Accelz));
         fprintf(Gx,'%2.2f\n', abs(gyrox));
         fprintf(Gy,'%2.2f\n', gyroy);
         fprintf(Gz,'%2.2f\n', gyroz);
   end
    fclose(Ax);
    fclose(Ay);
    fclose(Az);
    fclose(Gx);
    fclose(Gy);
    fclose(Gz);
    fclose(serialPort);
    
%     plot(Accelx)
%     hold on
%     plot(Accely)
    
% varAxPos = max(Accelx) - Accel1/10;
% varAyPos = max(Accely) - Accel2/10;
% varAzPos = max(Accelz) - Accel3/10;
% varGxPos = max(gyrox) - gyro1/10;
% varGyPos = max(gyroy) - gyro2/10;
% varGzPos = max(gyroz) - gyro3/10;
% 
% varAxNeg = abs(min(Accelx)) - Accel1/10;
% varAyNeg = abs(min(Accely)) - Accel2/10;
% varAzNeg = abs(min(Accelz)) - Accel3/10;
% varGxNeg = abs(min(gyrox)) - gyro1/10;
% varGyNeg = abs(min(gyroy)) - gyro2/10;
% varGzNeg = abs(min(gyroz)) - gyro3/10;
     
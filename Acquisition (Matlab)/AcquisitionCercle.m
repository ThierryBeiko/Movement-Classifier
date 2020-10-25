clear all 
clc
% Configuration du port sériel
delete(instrfind({'Port'},{'COM4'}));
serialPort = serial('COM4');
set(serialPort,'BaudRate',38400);

% Définition des variables
i = 1;     
nbMvts = 0;
nbSample = 10;
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
nomFichier = 'cercleX.txt';

% Ouverture du port et du fichier où les données seront écrites
fopen(serialPort);
fichier = fopen(nomFichier,'w');
fprintf("Effectuer des cercles dans le sens antihoraire \r\n")
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
    if size(A1) ~= [0 0]
        a1 = A1(1,1);
        a2 = A1(1,2);
        a3 = A1(1,3);
    end  
    % Permet au capteur de se réchauffer
    if (capteur == 1)
     if ca < limite1 
        ca = ca+1;
     end
    % Calcul une moyenne lorsque immobile sur 30 données
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
      if(Start == 1)
          Start = 0
      end
     if (abs(a3-Accel3/30) > 11)
        abs(a3-Accel3/30)
        acquisitionA = 1; 
     end
     if (acquisitionA ==1)
        Accelx(ax)= round(a1-Accel1/30);
        Accely(ax)= round(a2-Accel2/30);
        Accelz(ax)= round(a3-Accel3/30);
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
     if (acquisitionA ==1)
        gyrox (gx)= round(a1-(gyro1/30));
        gyroy (gx)= round(a2-(gyro2/30));
        gyroz (gx)= round(a3-(gyro3/30));
        gx = gx+1;
     end
     if (flagCalib ==1) 
         cg = limite1;
         flagCalib=0;
         acquisitionA = 0;
         gyro1 =0;
         gyro2 =0;
         gyro3 =0;
         nbMvts = nbMvts+1;
     end
    end
    end
    if nbMvts == nbSample
        i = 0;
    end
end 

   j = 0;
   for i = 1:length(Accelx)
%       if mod(j,100)==0
%           fprintf(fichier, 'Mouvement %d \r\n',j/100);
%       end
       fprintf(fichier,'%.2f, %.2f, %.2f, %.2f, %.2f, %.2f\r\n', Accelx(i),Accely(i),Accelz(i),gyrox(i),gyroy(i),gyroz(i));
%       j = j+1;
   end
    fclose(fichier);
    fclose(serialPort);
    

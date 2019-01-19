/* This file is part of the Razor AHRS Firmware */

// kalman_init(double q, double r, double p, double k)
Kalman filtre(0.0625, 32, 3, 0);
void output_angles()
{
  if (output_format == OUTPUT__FORMAT_BINARY)
  {
  }
  else if (output_format == OUTPUT__FORMAT_TEXT)
  {
  }
}
void output_calibration(int calibration_sensor)
{
}

void output_sensors_text(char raw_or_calibrated) // comment this section to modify #osct output
{
  gyro[0] = filtre.getFilteredValue(gyro[0]);
  gyro[1] = filtre.getFilteredValue(gyro[1]);
  gyro[2] = filtre.getFilteredValue(gyro[2]);

  if (start == 1)
  {
    //Acquisition sur 30 boucles pour calculer les moyennes de la position actuelle
    if (compteurMoy < 30)
    {
      moyAx = moyAx + float(int(accel[0]));
      moyAy = moyAy + float(int(accel[1]));
      moyAz = moyAz + float(int(accel[2]));
      moyGx = moyGx + float(int(gyro[0]));
      moyGy = moyGy + float(int(gyro[1]));
      moyGz = moyGz + float(int(gyro[2]));
      moyenneAx = moyAx / 30;
      moyenneAy = moyAy / 30;
      moyenneAz = moyAz / 30;
      moyenneGx = moyGx / 30;
      moyenneGy = moyGy / 30;
      moyenneGz = moyGz / 30;
      compteurMoy++;
      if (compteurMoy == 30)
      {
        go = true;
      }
    }
    //Une fois les moyennes calculées, envoi d'un caractère au port sériel
    //pour informer que le programme est prêt pour une nouvelle acquisition 
    if (go == true)
    {
      Serial.println('G');
      go = false;
    }
    if (compteurMoy == 30 && DataAcquisition == 0)
    {
      //Si la différence entre les valeurs d'accélérations et la moyenne est 
      //supérieure au seuil déterminé, début de l'aquisition sur 100 boucles
      if (abs(accel[0] - moyenneAx) > 10 || abs(accel[1] - moyenneAy) > 10 || 
          abs(accel[2] - moyenneAz) > 10 || abs(gyro[0] - moyenneGx) > 10 ||
          abs(gyro[1] - moyenneGy) > 10 || abs(gyro[2] - moyenneGz) > 10 )
      {
        compteur++;
        DataAcquisition = 1;
        i = 0;
      }
    }
    //Aquisition sur 100 boucles
    if (DataAcquisition == 1 && i < NbData)
    {
      
      detectionAx[i] = float(int(accel[0])) - moyenneAx;
      detectionAy[i] = float(int(accel[1])) - moyenneAy;
      detectionAz[i] = float(int(accel[2])) - moyenneAz;
      detectionGx[i] = float(int(gyro[0])) - moyenneGx;
      detectionGy[i] = float(int(gyro[1])) - moyenneGy;
      detectionGz[i] = float(int(gyro[2])) - moyenneGz;
      //Transformation des valeurs en string pour l'envoi au port sériel
      //via sprintf
      dtostrf(detectionAx[i],4,2,Ax);
      dtostrf(detectionAy[i],4,2,Ay);
      dtostrf(detectionAz[i],4,2,Az);
      dtostrf(detectionGx[i],4,2,Gx);
      dtostrf(detectionGy[i],4,2,Gy);
      dtostrf(detectionGz[i],4,2,Gz);
      sprintf(outputStream, "%s, %s, %s, %s, %s, %s",Ax,Ay,Az,Gx,Gy,Gz);
      Serial.println(outputStream);
      i++;
/*
      Serial.print(float(int(accel[0])) - moyenneAx); Serial.print(",");
      Serial.print(float(int(accel[1])) - moyenneAy); Serial.print(",");
      Serial.print(float(int(accel[2])) - moyenneAz); Serial.print(",");
      Serial.print(float(int(gyro[0])) - moyenneGx); Serial.print(",");
      Serial.print(float(int(gyro[1])) - moyenneGy); Serial.print(",");
      Serial.print(float(int(gyro[2])) - moyenneGz); Serial.println();
*/
    }
    if (i == NbData)
    {
      DataAcquisition = 0;
      if (i == NbData)
      {
        compteurMoy = 0;
        moyAx = 0;
        moyAy = 0;
        moyAz = 0;
        moyGx = 0;
        moyGy = 0;
        moyGz = 0;
        i = 0;
        //delay(200);
    }
  }
}
}
void output_sensors_binary()
{
}

void output_sensors()
{
  if (output_mode == OUTPUT__MODE_SENSORS_RAW)
  {
    if (output_format == OUTPUT__FORMAT_BINARY)
      output_sensors_binary();
    else if (output_format == OUTPUT__FORMAT_TEXT)
      output_sensors_text('R');
  }
  else if (output_mode == OUTPUT__MODE_SENSORS_CALIB)
  {
    // Apply sensor calibration
    compensate_sensor_errors();

    if (output_format == OUTPUT__FORMAT_BINARY)
      output_sensors_binary();
    else if (output_format == OUTPUT__FORMAT_TEXT)
      output_sensors_text('C');
  }
  else if (output_mode == OUTPUT__MODE_SENSORS_BOTH)
  {
    if (output_format == OUTPUT__FORMAT_BINARY)
    {
      output_sensors_binary();
      compensate_sensor_errors();
      output_sensors_binary();
    }
    else if (output_format == OUTPUT__FORMAT_TEXT)
    {
      output_sensors_text('R');
      compensate_sensor_errors();
      output_sensors_text('C');
    }
  }
}

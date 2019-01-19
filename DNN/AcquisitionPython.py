#Importation des packages nécessaires
import tensorflow as tf
import numpy as np
import pandas as pd
from keras.utils import to_categorical
from keras.models import Sequential, load_model
from keras.layers import LSTM,Dense,Dropout
from sklearn.preprocessing import MinMaxScaler
import matplotlib.pyplot as plt
import serial
import io
import time
import keyboard



#Importation du modèle DNN
model = load_model('LSTM_model_good.h5')

#Configuration du port sériel
serPort = serial.Serial(port ='COM8', baudrate=38400, timeout = 0)

#Protocole de communication
serioText = io.TextIOWrapper(io.BufferedRWPair(serPort, serPort, 1), encoding='ascii')
#serioNum = io.BufferedRWPair(serPort, serPort, 1)

#Définition de variables
debut = True
classification = True
data = np.zeros((70,6))
oneTimer = 0
nbMvts = 0

#Activation du output sériel dans le code Arduino

#serioText.flush()
#keyboard.wait('space')
print(serPort.in_waiting)
time.sleep(1)

#Lecture du port et acquisition lorsque mouvement effectué, ensuite
#enrgistrement dans la matrice data
while classification:
    if oneTimer == 0:
        serioText.write('#on')
        #serioText.flush()
        oneTimer = 1
    while debut == True :
        while serPort.in_waiting < 0:
            time.sleep(0.02)
        char = serioText.readline()
        if "G" in char:
            #serPort.flushInput()
            print("Effectuer un mouvement")
            debut = False
            char2 = None
            while not char2:
                char2 = serioText.readline()
            print(char2)
            for i in range(0,70):
                if i == 0:
                    char2 = np.fromstring(char2,dtype=float,sep=',' )
                    char2 = char2.reshape(1,6)
                    data[i]= char2
                line = serioText.readline()
                line = np.fromstring(line,dtype=float,sep=',' )
                if i>0 :
                    line = line.reshape(1,6)
                    data[i] = line
                    #print(line)
                time.sleep(0.02)
            oneTimer = 2
        if oneTimer == 2:
            serioText.write('#of')
            print(serioText.readline())
                    

    data = data.reshape((1,70,6))
    output = model.predict(data,batch_size = 1, verbose =1)
    print(output)
    index_max = np.argmax(output)

    #Action effectué selon le mouvement détecté
    #Action pour le Cercle
    if index_max == 0 :
        keyboard.send('space')
    #Action pour le Swipe Droit
    if index_max == 1 :
        keyboard.send('ctrl+right')
    #Action pour le Swipe Gauche
    if index_max == 2 :
        keyboard.send('ctrl+left')
    #Action pour la Rotation Droite
    if index_max == 3 :
        for i in range(15):
            keyboard.send('B')
    #Action pour la Rotation Gauche
    if index_max == 4 :
        for i in range(15):
            keyboard.send('C')
    #Action pour le Swipe Haut
    if index_max == 5 :
        keyboard.send('shift+right')
    #Action pour le Swipe Bas
    if index_max == 6 :
        keyboard.send('shift+left')

    #print(numbers_to_gesture(index_max))
    #print(data)
    nbMvts +=1 
    debut = True
    oneTimer = 0
    time.sleep(3)
    serPort.flush()
    data = data.reshape((70,6))
    if nbMvts == 7 :
        classification = False


serPort.close()
    


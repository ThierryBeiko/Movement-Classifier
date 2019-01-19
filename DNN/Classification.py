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

#model = load_model('LSTM_model.h5')

#Configuration du port sériel
serPort = serial.Serial(port ='COM8', baudrate=38400, timeout = 0)
debut = True

data = np.zeros((100,6))
#serPort.write('#on'.encode('utf-8'))
serioText = io.TextIOWrapper(io.BufferedRWPair(serPort, serPort, 1), encoding='ascii')
serioNum = io.BufferedRWPair(serPort, serPort, 1)
serPort.flushInput()
serioText.write('#of')
time.sleep(1)
serioText.write('#on')



print(serPort.in_waiting)
#time.sleep(1)
while debut == True :
    #print("while loop reading..")
    while serPort.in_waiting < 0:
        time.sleep(0.02)
    char = serioText.readline()
    #time.sleep(0.02)
    #print("test" + char)
    if "G" in char:
        print("Effectuer un mouvement")
        debut = False
        char2 = None
        while not char2:
            char2 = serioText.readline()
        print(char2)
        for i in range(0,100):
            if i == 0:
                char2 = np.fromstring(char2,dtype=float,sep=',' )
                char2 = char2.reshape(1,6)
                data[i]= char2
            line = serioText.readline()
            #char2 = ""
            #print("testline" + line)
            line = np.fromstring(line,dtype=float,sep=',' )
            if i>1 :
                line = line.reshape(1,6)
                data[i] = line
            print(line)
            time.sleep(0.02)
                

#data = data.resphape((1,100,6))
#output = model.predict(data,batch_size = 7, verbose = 1,steps = None)
#print(output)
print(data)

#while True :
#    while debut :
#        char = serio.readline()
#        if char == 'G' :
#            debut = False
#            while True :
#                print(serio.readline())
#            #for i in range(0,99):
#            #    data[i] = serPort.read_until()
#
#    print(data)
#    #while True :
#    #    print(serPort.readline())
#
serPort.close()
    


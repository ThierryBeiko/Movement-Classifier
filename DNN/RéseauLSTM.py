#Import des modules nécessaire
import tensorflow as tf
import numpy as np
import pandas as pd
from keras.utils import to_categorical
from keras.models import Sequential
from keras.layers import LSTM,Dense,Dropout
from sklearn.preprocessing import MinMaxScaler
import matplotlib.pyplot as plt

#Lecture des fichiers input (X_train et X_test) et output (y_train et y_train)
X_train = pd.read_csv("X_train1.txt",header=None)
y_train = pd.read_csv("y_train1.txt",header=None)
X_test = pd.read_csv("X_test1.txt",header=None)
y_test = pd.read_csv("y_test1.txt",header=None)
print(X_train.shape,y_train.shape,X_test.shape,y_test.shape)

#Conversion des données en Numpy Array
x_train = np.array(X_train)
ytrain = np.array(y_train)
x_test = np.array(X_test)
ytest = np.array(y_test)
print(x_train.shape,ytrain.shape,x_test.shape,ytest.shape)

#Transformation de la forme des données
x_train = x_train.reshape((210, 70,6))
ytrain = to_categorical(ytrain)
x_test = x_test.reshape((70,70,6))
ytest = to_categorical(ytest)
print(x_train.shape,ytrain.shape,x_test.shape,ytest.shape)

#Définition du modèle
model = Sequential()

model.add(LSTM(units=100, return_sequences = True, input_shape =(x_train.shape[1],6)))
model.add(Dropout(0.761))
model.add(LSTM(units=100))
model.add(Dropout(0.36))

model.add(Dense(ytrain.shape[1],activation='softmax'))
#Configuration du modèle pour l'entrainement
model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])      

#Entraînement du réseau
epochs = 5
batch_size = 7
model.fit(x_train,ytrain,epochs=epochs,batch_size=batch_size)

#Évaluation du réseau
model.evaluate(x_test,ytest,batch_size=batch_size)

#Sauvegarde du réseau
model.save('LSTM_model.h5')
For full details and explanation on how to implement this project on your own, please view the report located in this repository ("Classification de gestes par réseau de neurones.pdf"). Since this project was carried out through a class at Polytechnique Montreal, the report and most of the comments located in the code are in French. However, in this readme, the project will be briefly explained in English.

# Movement-Classifier

The objective of this project was to create a wearable system able to detect movement of the wrist/arm and to classify these movements using neural networks. This classification can then be use to control various system operation. For example, to demo this project, the control of the Windows Spotify app was implemented. 

# Getting Started

This project contains three main sections. Since this project was the following previous work done by another student, the wrist bracelet holding the electrical circuit was already designed and mounted. What remained to be done was : First, implement a acquisition workflow using a microcontroller (Arduino) and a IMU to obtain trajectory data. Second, develop and train a Reccurent Neural Network (RNN) to classify various movements. Finally, use the RNN model to classify real-time movements measured by the IMY for application control.

## Acquisition Workflow

The IMU and the Arduino microcontroller were interfaced using the code found at : https://github.com/Razor-AHRS/razor-9dof-ahrs (Acquisition Arduino)
Modifications were applied in order to customize the acquisition so it was compatible with the IMU is used. The data acquisition for training and testing the neural network was then done with a Matlab script (Acquisition Matlab). 
ization of the desired movement must first be executed and the results must be saved. To do so, set this options to true
 
## Reccurent Neural Network
 
The development of the neural network was done with the Keras library which uses tensorflow. The architecture of the model is composed of two LSTM (Long Short-Term Memory) layers followed by a dense layer. The model was trained using tagged sequence of inertial data for each movement. The goal was to classify 7 different movements and for this, 30 different sequences per movement were used for training the model. 

## Real-time classification and application control

The trained model was saved and implemented in a Python script (DNN/AcquisitionPython.py) for real-time classification. This script allowed serial communication with the microcontroller to obtain inertial data. This data was then used to predict the user's gesture and based on the output, a specific command was executed in the Spotify's windows app interface. The commands were link to gestures beforehand. 




import keras
from keras.layers import Sequential, Dense, Conv2D, Dropout, Flatten
from keras.optimizers import Adam

class Snake_Brain():

    def __init__(self):
        self.model = Sequential()

        self.model.add(BatchNormalization(axis=1, input_shape=input_shape))
        self.model.add(Convolution2D(filters = 32,
                                     kernel_size = (3,3),
                                     activation = 'relu'))

        self.model.add(BatchNormalization(axis=1))
        self.model.add(Convolution2D(filters = 32,
                                     kernel_size = (3,3),
                                     activation = 'relu'))

        self.model.add(Flatten())
        self.model.add(Dense(units = 256,
                             activation = 'relu'))

        self.model.add(Dropout(rate = 0.3))
        self.model.add(Dense(units = 4))

        self.model.compile(loss='mean_squared_error', optimizer=Adam(),
                           metrics=['accuracy'])

    def train(self, batch):
        pass

    def decide_action(self, state):
        pass

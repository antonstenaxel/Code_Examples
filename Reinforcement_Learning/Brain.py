
import keras
from keras.models import Sequential
from keras.layers import Dense, Conv2D, Dropout, Flatten, BatchNormalization
from keras.optimizers import Adam

class Brain():

    def __init__(self):
        self.model = Sequential()

        self.model.add(Conv2D(filters = 32,\
                              kernel_size = (3,3),\
                              activation = 'relu', \
                              input_shape =(60,60,1)))\

        self.model.add(Conv2D(filters = 32,
                              kernel_size = (3,3),\
                              activation = 'relu'))

        self.model.add(Flatten())
        self.model.add(Dense(units = 256,\
                             activation = 'relu'))

        self.model.add(Dropout(rate = 0.3))
        self.model.add(Dense(units = 4))

        self.model.compile(loss='mean_squared_error',\
                           optimizer=Adam(),\
                           metrics=['accuracy'])

        self.memory = []

    def add_memory(self, state, action, reward, next_state):
        self.memory.append((screen,action,rewards))


    def retrieve_memory(self, batch_size):
        return []

    def train(self, batch):
        pass

    def predict(self, state):
        pass

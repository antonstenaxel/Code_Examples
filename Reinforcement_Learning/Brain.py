
import keras
import numpy as np
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

    def add_memory(self, experience):
        self.memory.append(experience)


    def retrieve_memory(self, batch_size):
        x = []
        y = []

        indices = np.random.randint(low=0,high=len(memory),size=batch_size)

        for index in indices:
            state, action, reward, next_state = self.memory[index]

            max_next_q = np.max(self.predict(next_state))

            q = reward + GAMMA*max_next_q

            x.append(state)
            y.append(q)


        return x,y

    def train(self, batch):
        pass

    def predict(self, state):
        pred_state = state.reshape((1,)+np.shape(state)+(1,))
        return self.model.predict(pred_state)


import keras
from Constants import *
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
        self.model.add(Dense(units = 5))

        self.model.compile(loss='mean_squared_error',\
                           optimizer=Adam(),\
                           metrics=['accuracy'])

        self.memory = []

    def add_memory(self, experience):
        self.memory.append(experience)


    def retrieve_memory(self, batch_size):
        x = np.zeros((batch_size,60,60,1))
        y = np.zeros((batch_size,5))

        indices = np.random.randint(low=0,high=len(self.memory),size=batch_size)

        for sample, index in enumerate(indices):
            state, action, reward, next_state, final_state = self.memory[index]

            max_next_q = np.max(self.predict(next_state))

            q_action = reward

            if not final_state:
                q_action += GAMMA*max_next_q

            target = self.predict(state)[0] #Zero error except for action taken

            target[action] = q_action

            x[sample,:,:,0] = state
            y[sample,:] = target


        return x,y

    def learn(self):

        x,y = self.retrieve_memory(BATCH_SIZE)
        
        self.model.fit(x,y, epochs = 1)

    def predict(self, state):
        pred_state = state.reshape((1,)+np.shape(state)+(1,))
        return self.model.predict(pred_state)

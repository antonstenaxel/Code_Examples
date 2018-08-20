import numpy as np
import random
from Brain import Brain
from Constants import *

# Class that roughly corresponds to an Agent
class Snake:

    def __init__(self):
        self.reset()
        self.brain = Brain()
        self.experience_buffer = []

    # Adds a SARS datapoint to the temporary memory.
    def remember(self, state, action, reward, next_state, final_state):
        self.experience_buffer.append((state,action,reward, next_state, final_state))

    def percept_state(self, state):
        q_values = self.brain.predict(state)
        action = np.argmax(q_values)
        return action

    def reset(self):

        self.direction = random.choice(ACTIONS[1:])
        self.head_position = np.copy(START_POS)
        self.body_position = np.vstack([self.head_position - i*self.direction for i in range(1,5)])
        self.growing = False

    def grow(self):
        self.growing = True

    def die(self):

        for experience in self.experience_buffer:
            self.brain.add_memory(experience)

        self.experience_buffer = []

        self.brain.learn()
        

    def turn(self, action):
        if action == 0: #Do nothing -action
            return
        else:
            direction = ACTIONS[action]

            if not np.all(direction == -self.direction):
                self.direction = direction

    def update(self,action):
        self.turn(action)

        if self.growing:
            self.body_position = np.append([self.head_position], self.body_position, axis = 0)
            self.growing = False
        else:
            self.body_position[1:,:] = self.body_position[:-1,:]
            self.body_position[0,:] = self.head_position

        self.head_position += self.direction

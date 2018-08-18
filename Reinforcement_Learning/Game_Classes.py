
from pygame.locals import *
from Brain import Brain
import pygame, sys, os, time, random, cv2
import numpy as np


# CONSTANTS
SCALE = 20
SCREEN_SIZE = 300
N_TILES = SCREEN_SIZE/SCALE-1
START_POS = np.array([N_TILES // 2 ,N_TILES // 2 ],dtype=np.int)
BACKGROUND_COLOR = (51, 51, 51)
SNAKE_HEAD_COLOR = (255, 50, 50)
SNAKE_BODY_COLOR = (255, 100, 100)
APPLE_COLOR = (100, 255, 100)
ACTIONS = np.array([[0,-1],[0,1],[-1,0],[1,0]],dtype=np.int)


class Snake:

    def __init__(self):
        self.reset()
        self.brain = Brain()

    def remember(self, state, action, reward):
        self.brain.add_memory(state,action,reward)

    def percept_state(self, state):
        q_values = self.brain.predict(state)
        # Decide best policy and act on it and then store the data

    def reset(self):

        self.direction = random.choice(ACTIONS)
        self.head_position = np.copy(START_POS)
        self.body_position = np.vstack([self.head_position - i*self.direction for i in range(1,5)])
        self.grow = False

    def eat_apple(self):
        self.grow = True

    def eat_self(self):
        self.reset()

    def crash(self):
        self.reset()

    def turn(self, direction):
        if not np.all(direction == -self.direction):
            self.direction = direction

    def grow(self):
        self.body_position = np.append(self.body_position)

    def update(self):


        if self.grow:
            self.body_position = np.append([self.head_position], self.body_position, axis = 0)
            self.grow = False
        else:
            self.body_position[1:,:] = self.body_position[:-1,:]
            self.body_position[0,:] = self.head_position

        self.head_position += self.direction


class Apple:

    def __init__(self):
        self.relocate()


    def relocate(self):
        self.position = np.random.randint(0,N_TILES,size=[2])

class Graphics:

    def __init__(self):


        pygame.init()
        self.s = pygame.display.set_mode((SCREEN_SIZE, SCREEN_SIZE))
        pygame.display.set_caption('Snake')

        self.apple_image = pygame.Surface((SCALE, SCALE))
        self.apple_image.fill(APPLE_COLOR)

        self.snake_head_image = pygame.Surface((SCALE, SCALE))
        self.snake_head_image.fill(SNAKE_HEAD_COLOR)

        self.snake_body_image = pygame.Surface((SCALE, SCALE))
        self.snake_body_image.fill(SNAKE_BODY_COLOR)

    def return_screen(self, size = (60,60)):
        image = pygame.surfarray.array3d(self.s)
        image = cv2.resize(image, dsize=size, interpolation=cv2.INTER_CUBIC)

        return image

    def render(self,snake_head,snake_body,apple_pos):
        self.s.fill(BACKGROUND_COLOR)
        self.s.blit(self.apple_image,(apple_pos[0]*SCALE,apple_pos[1]*SCALE))

        self.s.blit(self.snake_head_image,(snake_head[0]*SCALE,snake_head[1]*SCALE))
        for bodypart in snake_body:
            self.s.blit(self.snake_body_image,(bodypart[0]*SCALE,bodypart[1]*SCALE))

        pygame.display.update()

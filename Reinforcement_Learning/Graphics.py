
from pygame.locals import *
import pygame, sys, os, time, random, cv2
import numpy as np
from Constants import *

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
        image = np.mean(image, axis = 2) # To gray scale
        image = cv2.resize(image, dsize=size, interpolation=cv2.INTER_CUBIC)

        return image

    def render(self,snake_head,snake_body,apple_pos):
        self.s.fill(BACKGROUND_COLOR)
        self.s.blit(self.apple_image,(apple_pos[0]*SCALE,apple_pos[1]*SCALE))

        self.s.blit(self.snake_head_image,(snake_head[0]*SCALE,snake_head[1]*SCALE))
        for bodypart in snake_body:
            self.s.blit(self.snake_body_image,(bodypart[0]*SCALE,bodypart[1]*SCALE))

        pygame.display.update()

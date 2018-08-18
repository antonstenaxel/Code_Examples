from pygame.locals import *
import pygame, time, sys
from Game_Classes import Apple, Snake, Graphics, SCREEN_SIZE,SCALE, ACTIONS, N_TILES
import numpy as np


if __name__ == "__main__":


    apple = Apple()
    snake = Snake()
    graphics = Graphics()

    while True:  # Main game loop

        time.sleep(0.1)

        for e in pygame.event.get():
            if e.type == QUIT:
                sys.exit(0)
            elif e.type == KEYDOWN:
                if e.key == K_UP:
                    snake.turn(ACTIONS[0])
                elif e.key == K_DOWN:
                    snake.turn(ACTIONS[1])
                elif e.key == K_LEFT:
                    snake.turn(ACTIONS[2])
                elif e.key == K_RIGHT:
                    snake.turn(ACTIONS[3])

        snake.update()
        graphics.render(snake.head_position, snake.body_position, apple.position)


        # Check wall collision
        if np.any(snake.head_position < 0) or np.any(snake.head_position > N_TILES):
            snake.crash()


        # Check if snake eats itself
        for bodypart in snake.body_position:
            if np.all(snake.head_position == bodypart):
                snake.eat_self()


        # Check if snake eats apple
        if np.all(apple.position == snake.head_position):
            snake.eat_apple()
            apple.relocate()


        state = graphics.return_screen()
        snake.percept_state(state)
        

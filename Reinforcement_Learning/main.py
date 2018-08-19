from pygame.locals import *
import pygame, time, sys
from Graphics import Graphics
from Apple import Apple
from Snake import Snake
from Constants import *
import numpy as np


def check_game_events():
    for e in pygame.event.get():
        if e.type == QUIT:
            sys.exit(0)
        elif e.type == KEYDOWN:
            if e.key == K_UP:
                snake.turn(1)
            elif e.key == K_DOWN:
                snake.turn(2)
            elif e.key == K_LEFT:
                snake.turn(3)
            elif e.key == K_RIGHT:
                snake.turn(4)

if __name__ == "__main__":

    apple = Apple()
    snake = Snake()
    graphics = Graphics()

    state = graphics.return_screen()

    while True:  # Main game loop

        check_game_events()

        action = snake.percept_state(state)
        snake.update(action)

        graphics.render(snake.head_position, snake.body_position, apple.position)

        new_state = graphics.return_screen()

        # Check wall collision
        if np.any(snake.head_position < 0) or np.any(snake.head_position > N_TILES):
            snake.die()

        # Check if snake eats itself
        for bodypart in snake.body_position:
            if np.all(snake.head_position == bodypart):
                snake.die()

        # Check if snake eats apple
        if np.all(apple.position == snake.head_position):
            snake.grow()
            apple.relocate()


        state = new_state
        time.sleep(0.1)

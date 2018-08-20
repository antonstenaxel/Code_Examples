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

if __name__ == "__main__":

    apple = Apple()
    snake = Snake()
    graphics = Graphics()

    state = graphics.return_screen()
    game_over = False

    while True:  # Main game loop

        check_game_events()

        action = snake.percept_state(state)

        snake.update(action)

        new_state = graphics.return_screen()

        reward = SURVIVAL_REWARD

        # Check wall collision
        if np.any(snake.head_position < 0) or np.any(snake.head_position > N_TILES):
            game_over = True
            reward = LOSS_REWARD

        # Check if snake eats itself
        for bodypart in snake.body_position:
            if np.all(snake.head_position == bodypart):
                game_over = True
                reward = LOSS_REWARD


        # Check if snake eats apple
        if np.all(apple.position == snake.head_position):
            snake.grow()
            apple.relocate()
            reward = WIN_REWARD

        snake.remember(state,action,reward,new_state, game_over)

        if(game_over):
            snake.die()
            game_over = False



        state = new_state
        graphics.render(snake.head_position, snake.body_position, apple.position)



        #time.sleep(0.01)

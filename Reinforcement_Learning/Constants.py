import numpy as np

# Layout
SCALE = 20
SCREEN_SIZE = 300
N_TILES = SCREEN_SIZE/SCALE-1

# Graphics
BACKGROUND_COLOR = (0, 0, 0)
SNAKE_HEAD_COLOR = (255, 0, 0)
SNAKE_BODY_COLOR = (0, 0, 255)
APPLE_COLOR = (0, 255, 0)
#Different color for head and body to give sense of movement

# Game
#Actions: {"Nothing":0, "Up":1, "Down":2,"Left":3, "Right":4}
ACTIONS = np.array([[0,0],[0,-1],[0,1],[-1,0],[1,0]],dtype=np.int)
START_POS = np.array([7,7 ],dtype=np.int)
LOSS_REWARD = -10
WIN_REWARD = 10
SURVIVAL_REWARD = 0

GAMMA = 0.9
BATCH_SIZE = 32

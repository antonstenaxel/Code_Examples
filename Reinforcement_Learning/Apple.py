from Constants import *

class Apple:

    def __init__(self):
        self.relocate()
        
    def relocate(self):
        self.position = np.random.randint(0,N_TILES,size=[2])

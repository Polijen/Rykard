#il rulez cu python3 lab6.py

import pygame
import numpy as np


class Boid:
    def __init__(self, position, velocity):
        self.position = np.array(position, dtype='float64')
        self.velocity = np.array(velocity, dtype='float64')

    def update_position(self, width, height):
        self.position += self.velocity
        self.position[0] = self.position[0] % width
        self.position[1] = self.position[1] % height

    def separation(self, boids, separation_distance=20):
        steer = np.zeros(2)
        count = 0
        for other in boids:
            distance = np.linalg.norm(self.position - other.position)
            if 0 < distance < separation_distance:
                steer += self.position - other.position
                count += 1
        if count > 0:
            steer /= count
        return steer

    def alignment(self, boids, neighbor_distance=50):
        avg_velocity = np.zeros(2)
        count = 0
        for other in boids:
            distance = np.linalg.norm(self.position - other.position)
            if 0 < distance < neighbor_distance:
                avg_velocity += other.velocity
                count += 1
        if count > 0:
            avg_velocity /= count
            return avg_velocity - self.velocity
        return np.zeros(2)

    def cohesion(self, boids, neighbor_distance=50):
        center_of_mass = np.zeros(2)
        count = 0
        for other in boids:
            distance = np.linalg.norm(self.position - other.position)
            if 0 < distance < neighbor_distance:
                center_of_mass += other.position
                count += 1
        if count > 0:
            center_of_mass /= count
            return center_of_mass - self.position
        return np.zeros(2)

    def apply_behaviors(self, boids, separation_weight=1.5, alignment_weight=1.0, cohesion_weight=1.0, max_speed=2):
        sep = self.separation(boids) * separation_weight
        ali = self.alignment(boids) * alignment_weight
        coh = self.cohesion(boids) * cohesion_weight
        self.velocity += sep + ali + coh
        self.limit_speed(max_speed)

    def limit_speed(self, max_speed):                                          #cred ca self.velocity e parametrul necesar citi pentru a determina viteza, luam valoarea returnata, o salvez intro valoare globala si pun ifs in functia de color ce fa schimba STRING-ul de culaore (E culoare(direct) sau ints de culoare.)
        speed = np.linalg.norm(self.velocity)                                  #https://www.pygame.org/docs/ref/draw.html
        if speed > max_speed:
            self.velocity = (self.velocity / speed) * max_speed

    def draw(self, surface):                                                   #modific aici functia pentru a pune culori diferite in functie de viteza.
        pygame.draw.circle(surface, WHITE, self.position.astype(int), 3)





# Initialize Pygame
pygame.init()

# Define simulation window dimensions
WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600
screen = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT))
pygame.display.set_caption('Boids Simulation with Pygame')

# Define clock to control frame rate
clock = pygame.time.Clock()
FPS = 60  # Frames per second

# Define colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)

"""
# Minimal Pygame loop to keep the window open
running = True
while running:
    clock.tick(FPS)  # Maintain frame rate

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    screen.fill(BLACK)  # Fill the screen with black
    pygame.display.flip()  # Update the display

pygame.quit()
"""

num_boids = 30
boids_pygame = [
    Boid(position=np.random.rand(2) * [WINDOW_WIDTH, WINDOW_HEIGHT],
         velocity=np.random.rand(2))
    for _ in range(num_boids)
]



# Main Pygame loop
'''
running = True
while running:
    clock.tick(FPS)  # Maintain frame rate

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Fill the background
    screen.fill(BLACK)

    # Update and draw each Boid
    for boid in boids_pygame:
        boid.apply_behaviors(boids_pygame)
        boid.update_position(WINDOW_WIDTH, WINDOW_HEIGHT)
        boid.draw(screen)

    # Update the display
    pygame.display.flip()
'''
#pygame.quit()

def update_position(self, width, height, radius=3):
    # move
    self.position += self.velocity

    # bounce on X (respect radius and clamp inside)
    if self.position[0] < radius:
        self.position[0] = radius
        self.velocity[0] *= -1
    elif self.position[0] > width - radius:
        self.position[0] = width - radius
        self.velocity[0] *= -1

    # bounce on Y (respect radius and clamp inside)
    if self.position[1] < radius:
        self.position[1] = radius
        self.velocity[1] *= -1
    elif self.position[1] > height - radius:
        self.position[1] = height - radius
        self.velocity[1] *= -1


def animate(frame_num):
    """
    Update function for the animation.

    :param frame_num: Current frame number (unused)
    :return: Updated scatter plot
    """
    for boid in boids:
        boid.apply_behaviors(boids)
        boid.update_position(WIDTH, HEIGHT)

    # Update scatter plot data
    scatter.set_offsets([boid.position for boid in boids])
    return scatter,



# Modify the main loop to include mouse interaction
running = True
while running:
    clock.tick(FPS)

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Get mouse position and state
    mouse_pos = np.array(pygame.mouse.get_pos(), dtype='float64')
    mouse_pressed = pygame.mouse.get_pressed()[0]  # Left button

    # Fill the background
    screen.fill(BLACK)

    for boid in boids_pygame:
        if mouse_pressed:
            direction = mouse_pos - boid.position
            if np.linalg.norm(direction) != 0:
                boid.velocity += direction * 0.001  # Adjust strength as needed

        boid.apply_behaviors(boids_pygame)
        boid.update_position(WINDOW_WIDTH, WINDOW_HEIGHT)
        boid.draw(screen)

    pygame.display.flip()

pygame.quit()

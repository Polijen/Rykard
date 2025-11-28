import pygame
import random
import math
from collections import deque

pygame.init()

#Screen dimensions
WIDTH, HEIGHT = 1800, 900

# Zone boundaries for agent movement
UI_ZONE_WIDTH = 250  # Width of UI area on the left
SAFE_ZONE_LEFT = UI_ZONE_WIDTH
SAFE_ZONE_RIGHT = WIDTH - 200  # Keep agents away from quarantine zone on right


#Colors    RGB
BACKGROUND_COLOR = (30, 30, 30)
NOT_INFECTED_COLOR = (0, 255, 0)   #Green           
INFECTED_COLOR = (255, 0, 0)       #Red
RECOVERED_COLOR = (0, 0, 255)      #Blue
VACCINATED_COLOR = (0, 255, 255)   #Cyan
BORDER_COLOR = (255, 255, 0)       #Galben, e pentru infectati 
QUARANTINE_COLOR = (150, 0, 150)  #Purpur
TEXT_COLOR = (200, 200, 200) 

#Frame Rate
FPS = 60

#Initialize screen and clock 
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Epidemic SImulation SIR Model")
clock = pygame.time.Clock()

#Font for text
FONT = pygame.font.SysFont(None, 24)
FONT_LARGE = pygame.font.SysFont(None, 28)


#States
NOT_INFECTED = "S"       #Oamenii ce sunt sanatosi
INFECTED = "I"           #Oamenii bolnavi
RECOVERED = "R"          #Oamenii ce au trecut prin boala si sunt ok 
IMMUNE = "V"             #Literally Gods


#Infection_Probs 
"""                        #Acum sunt inutile... dar le pastrez ca proof of development
INFECTION_RADIUS = 15
INFECTION_PROBABILITY = 0.2
RECOVERY_TIME = 300                         #Timpul minim in frames pentru a fi cured          
RECOVERY_PROBABILITY = 0.01                 #Probabilitatea ca sa devina cured pentru fiecare frame dupa ce a trecut timpul minim 
DEATH_PROBABILITY = 0.005                   #La fel ca recovery doar ca pe parcurul timpului in care e infectat
"""
INFECTION_TIME = 300    


class Agent:
    def __init__(self, position=None, velocity=None, speed=2):
        #Ideea e ca daca nu sunt dati argumentele, se alege random. asta ca sa putem pune in anumite pozitii daca e necesar
    
        self.position = position or pygame.math.Vector2(random.uniform(SAFE_ZONE_LEFT + 20, SAFE_ZONE_RIGHT - 20), random.uniform(0, HEIGHT-50))   
        self.velocity = velocity or pygame.math.Vector2(random.uniform(-1, 1), random.uniform(-1, 1)).normalize()
        self.speed = 2
        self.radius = 6
        
        #States
        self.state = NOT_INFECTED
        self.infection_timer = 0        #Frames de la infectare
        self.proximity_timer = {}       #Timpul langa infectati
        
        #Quarantine
        self.in_quarantine = False
        self.quarantine_entry_time = 0

        #Socializare
        self.grouping_timer = 0
        self.target_agent = None

    def update_position(self, quarantine_zone):

        self.position +=self.velocity * self.speed

        #Avem 2 regiuni asa ca trebuie sa facem bouce in dependenta de unde se afla 
        if self.in_quarantine:
            self.bounce_off_quarantine(quarantine_zone)
        else:
            self.bounce_off_walls()



    def bounce_off_walls(self):
        # Bounce off walls 
        if self.position.x < SAFE_ZONE_LEFT or self.position.x > SAFE_ZONE_RIGHT:
            self.velocity.x *= -1
    
        # Bounce off top/bottom walls
        if self.position.y < 0 or self.position.y > HEIGHT:
            self.velocity.y *= -1

        # Keep position within safe zone bounds (avoid UI area and quarantine)
        self.position.x = max(SAFE_ZONE_LEFT, min(self.position.x, SAFE_ZONE_RIGHT))
        self.position.y = max(0, min(self.position.y, HEIGHT))



    def bounce_off_quarantine(self, quarantine_zone):
        #Bounce pe stanga/dreapta
        if self.position.x < quarantine_zone.left or self.position.x > quarantine_zone.right:
            self.velocity.x *= -1
        #Bounce pe sus/jos
        if self.position.y < quarantine_zone.top or self.position.y > quarantine_zone.bottom:
            self.velocity.y *= -1
        
        # Keep position within quarantine bounds 
        self.position.x = max(quarantine_zone.left, min(self.position.x, quarantine_zone.right))
        self.position.y = max(quarantine_zone.top, min(self.position.y, quarantine_zone.bottom))

    
    def social_behavior(self, agents): #grupari temporare pentru a vorbi

        if self.in_quarantine:     #daca sunt in carantina ei nu se grupeaza, pastreaza distanta asa cum se cere 
            return

        #Decide random daca vrea sa se grupeze cu cineva si va cauta un alt om
        if self.grouping_timer <= 0 and random.random() < 0.01: 
            #Cauta cel mai apropiat
            nearby_agents = [a for a in agents
                if a != self and not a.in_quarantine and self.position.distance_to(a.position) < 100
            ]
            if nearby_agents:
                self.target_agent = random.choice(nearby_agents)
                self.grouping_timer = random.randint(60, 180)  #1-3 secunde

            #Se deplaseaza spre oameni daca vrea sa se grupeze 

        #Deplasarea daca vrea sa se grupeze 
        if self.grouping_timer > 0 and self.target_agent:
            if self.target_agent.in_quarantine:
                # Stop grouping if target is quarantined
                self.grouping_timer = 0
                self.target_agent = None
            else:
                direction = (self.target_agent.position - self.position)
                if direction.length() > 20:  # Stay close but not too close
                    self.velocity = direction.normalize()
                self.grouping_timer -= 1
        else:
            # Random walk when not grouping
            if random.random() < 0.02:
                angle = random.uniform(0, 2 * math.pi)
                self.velocity = pygame.math.Vector2(math.cos(angle), math.sin(angle))


    def check_infection(self, agents, infection_probability, infection_radius):    #Verifica daca sanatosi devin infectati de cinea din apropiere, probabilitatea de infectare creste cu cat mai mult timp se afla in apropiere de INFECTED
        if self.state != NOT_INFECTED:  #Trebuie sa fie sanatosi ca sa poata fi infectati
            return

        #Verifica proximity cu alti INFECTED 
        for other in agents:
            if other.state == INFECTED and other != self:
                distance = self.position.distance_to(other.position)
                
                if distance < infection_radius:
                    # Track time spent near this infected agent
                    if other not in self.proximity_timer:
                        self.proximity_timer[other] = 0
                    self.proximity_timer[other] += 1
                    
                    # Infection probability increases with proximity duration
                    # Base probability * (1 + time_multiplier)
                    time_multiplier = self.proximity_timer[other] / 60.0  # Normalize by FPS
                    adjusted_probability = infection_probability * (1 + time_multiplier * 0.5)
                    
                    if random.random() < adjusted_probability:
                        self.state = INFECTED
                        self.infection_timer = 0
                        self.proximity_timer.clear()
                        break
                else:
                    # Reset proximity timer if agent moves away
                    if other in self.proximity_timer:
                        del self.proximity_timer[other]


    def update_infection(self, recovery_time, recovery_probability, death_probability):  
        #face update la infectati, si deja daca e cazul ii omoara sau trec in sanatosi
        if self.state != INFECTED:
            return

        self.infection_timer += 1

        # After minimum infection time, agent can recover or die
        if self.infection_timer > recovery_time:
            # Check for recovery
            if random.random() < recovery_probability:
                self.state = RECOVERED
                self.in_quarantine = False  # Leave quarantine when recovered
                return False
            
            # Check for death
            if random.random() < death_probability:
                return True  # Signal that agent should be removed
        
        return False


    def draw(self):
        # Determine color based on state
        if self.state == NOT_INFECTED:
            color = NOT_INFECTED_COLOR
        elif self.state == INFECTED:
            color = INFECTED_COLOR
        elif self.state == RECOVERED:
            color = RECOVERED_COLOR
        elif self.state == IMMUNE:
            color = VACCINATED_COLOR
        
        # Draw the agent as a circle
        pygame.draw.circle(
            screen, 
            color, 
            (int(self.position.x), int(self.position.y)), 
            self.radius
        )
        
        # Draw yellow border around infected agents for visibility
        if self.state == INFECTED:
            pygame.draw.circle(
                screen, 
                BORDER_COLOR, 
                (int(self.position.x), int(self.position.y)), 
                self.radius + 2, 
                2
            )


class Simulation:
    def __init__(self, num_agents=150, initial_infected=3):
        
        #Create agents 
        self.agents = [Agent() for a in range(num_agents)]

        #Infectam cati ne trebuie 
        for i in range(min(initial_infected, num_agents)):
            self.agents[i].state = INFECTED

        #Default parameters
        self.infection_probability = 0.015
        self.infection_radius = 20
        self.recovery_time = 1200                          #20s at 60 FPS
        self.recovery_probability = 0.008
        self.death_probability = 0.004
        # Vaccination parameters
        self.initial_vaccination_rate = 0.3                # % of population vaccinated AT START
        self.vaccination_success_rate = 0.85               # Success rate of vaccination attempt
        self.ongoing_vaccination_enabled = False           # Toggle for vaccination over time
        self.ongoing_vaccination_rate = 0.0001             # Per-frame probability for ongoing vaccination
        self.quarantine_enabled = True

        #Quarantine area
        self.quarantine_zone = pygame.Rect(WIDTH-200, 0 , 200, 250)

        #Avem oameni deja vaccinati de la inceput 
        self.apply_vaccinations()  


        #Graph history 
        self.history_not_infected = deque(maxlen=600)  # Keep last 10 seconds
        self.history_infected = deque(maxlen=600)
        self.history_recovered = deque(maxlen=600)
        self.history_immune = deque(maxlen=600)
        self.history_infection_rate = deque(maxlen=600)
        self.history_recovery_rate = deque(maxlen=600)
        self.frame_count = 0
        
        # Previous counts for rate calculation
        self.prev_infected_count = initial_infected
        self.prev_recovered_count = 0
        
        # Simulation state
        self.running = True
        self.paused = False

    
    def apply_vaccinations(self):
        for agent in self.agents:
            if agent.state == NOT_INFECTED:
                # Agent decides whether to get vaccinated
                if random.random() < self.initial_vaccination_rate:
                    # Vaccination has a success rate
                    if random.random() < self.vaccination_success_rate:
                        agent.state = IMMUNE

    
    def run(self): 
        """Main loop of the simulation."""
        while self.running:
            clock.tick(FPS)
            self.handle_events()
            
            if not self.paused:
                self.update_agents()
                self.handle_quarantine()
                self.update_history()
                self.frame_count += 1
            
            self.render()
        
        pygame.quit()


    def handle_events(self):
        """Handle user input and events."""
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.running = False
            elif event.type == pygame.KEYDOWN:
                # Adjust infection probability
                if event.key == pygame.K_i:
                    self.infection_probability = min(0.05, self.infection_probability + 0.002)
                elif event.key == pygame.K_u:
                    self.infection_probability = max(0.001, self.infection_probability - 0.002)
                
                # Adjust recovery probability
                elif event.key == pygame.K_r:
                    self.recovery_probability = min(0.02, self.recovery_probability + 0.001)
                elif event.key == pygame.K_t:
                    self.recovery_probability = max(0.001, self.recovery_probability - 0.001)
                
                # Adjust Initial vaccination rate
                elif event.key == pygame.K_v:
                    self.initial_vaccination_rate = min(1.0, self.initial_vaccination_rate + 0.05)
                elif event.key == pygame.K_b:
                    self.initial_vaccination_rate = max(0.0, self.initial_vaccination_rate - 0.05)
            
                # Adjust ONGOING vaccination rate
                elif event.key == pygame.K_o:
                    self.ongoing_vaccination_rate = min(0.001, self.ongoing_vaccination_rate + 0.00005)
                elif event.key == pygame.K_p:
                    self.ongoing_vaccination_rate = max(0.0, self.ongoing_vaccination_rate - 0.00005)
            
                # Toggle ongoing vaccination on/off
                elif event.key == pygame.K_m:
                    self.ongoing_vaccination_enabled = not self.ongoing_vaccination_enabled

                # Toggle quarantine
                elif event.key == pygame.K_q:
                    self.quarantine_enabled = not self.quarantine_enabled
                
                # Pause/unpause
                elif event.key == pygame.K_SPACE:
                    self.paused = not self.paused
                
                # Reset simulation
                elif event.key == pygame.K_n:
                    self.reset_simulation()


    
    def reset_simulation(self):
        self.__init__(num_agents=len(self.agents))


    def update_agents(self):
        # Update each agent's state
        for agent in self.agents[:]:
            # Susceptible agents can get vaccinated over time if enabled
            if self.ongoing_vaccination_enabled and agent.state == NOT_INFECTED and not agent.in_quarantine:
                # Check if agent decides to get vaccinated this frame
                if random.random() < self.ongoing_vaccination_rate:
                    # Vaccination attempt with success rate
                    if random.random() < self.vaccination_success_rate:
                        agent.state = IMMUNE
        

            # Social behavior (temporary grouping)
            agent.social_behavior(self.agents)
            
            # Check for infection
            agent.check_infection(
                self.agents, 
                self.infection_probability, 
                self.infection_radius
            )
            
            # Update infection status (recovery or death)
            if agent.update_infection(
                self.recovery_time, 
                self.recovery_probability, 
                self.death_probability
            ):
                # Agent died - remove from simulation
                self.agents.remove(agent)
                continue
            
            # Update position
            agent.update_position(self.quarantine_zone)

    def handle_quarantine(self):
        #Move infected agents to quarantine zone if enabled.
        if not self.quarantine_enabled:
            # Release all quarantined agents
            for agent in self.agents:
                agent.in_quarantine = False
            return
        
        for agent in self.agents:
            # Move infected agents to quarantine
            if agent.state == INFECTED and not agent.in_quarantine and agent.infection_timer > INFECTION_TIME:   #5 secunde sa infecteze
                agent.in_quarantine = True
                # Move to quarantine zone
                agent.position = pygame.math.Vector2(
                    random.uniform(self.quarantine_zone.left + 20, self.quarantine_zone.right - 20),
                    random.uniform(self.quarantine_zone.top + 20, self.quarantine_zone.bottom - 20)
                )



    def update_history(self):  #for grapths
        # Count agents in each state
        Not_Infected_count = sum(1 for a in self.agents if a.state == NOT_INFECTED)
        infected_count = sum(1 for a in self.agents if a.state == INFECTED)
        recovered_count = sum(1 for a in self.agents if a.state == RECOVERED)
        immune_count = sum(1 for a in self.agents if a.state == IMMUNE)
        
        # Calculate rates (new cases/recoveries per frame)
        infection_rate = max(0, infected_count - self.prev_infected_count + (recovered_count - self.prev_recovered_count))
        recovery_rate = max(0, recovered_count - self.prev_recovered_count)
        
        # Update history
        self.history_not_infected.append(Not_Infected_count)
        self.history_infected.append(infected_count)
        self.history_recovered.append(recovered_count)
        self.history_immune.append(immune_count)
        self.history_infection_rate.append(infection_rate)
        self.history_recovery_rate.append(recovery_rate)
        
        # Update previous counts
        self.prev_infected_count = infected_count
        self.prev_recovered_count = recovered_count

    
    def render(self):     #FUnctia ce pune chestiile pe ecran 
        screen.fill(BACKGROUND_COLOR)
        
        # Draw quarantine zone
        if self.quarantine_enabled:
            pygame.draw.rect(screen, QUARANTINE_COLOR, self.quarantine_zone, 3)
            quarantine_text = FONT.render('QUARANTINE', True, QUARANTINE_COLOR)
            screen.blit(quarantine_text, (self.quarantine_zone.centerx - 50, self.quarantine_zone.top + 10))
        
        # Draw all agents
        for agent in self.agents:
            agent.draw()
        
        # Draw UI elements
        self.draw_legend()
        self.draw_stats()
        self.draw_controls()
        self.draw_graphs()
        
        pygame.display.flip()

    
    def draw_legend(self):
        y_offset = 10
        legends = [
            ('Not_Infected (Green)', NOT_INFECTED_COLOR),
            ('Infected (Red)', INFECTED_COLOR),
            ('Recovered (Blue)', RECOVERED_COLOR),
            ('Immune/Vaccinated (Cyan)', VACCINATED_COLOR),
        ]
        
        for text, color in legends:
            rendered_text = FONT.render(text, True, color)
            screen.blit(rendered_text, (10, y_offset))
            y_offset += 20

    def draw_stats(self):
        Not_Infected_count = sum(1 for a in self.agents if a.state == NOT_INFECTED)
        infected_count = sum(1 for a in self.agents if a.state == INFECTED)
        recovered_count = sum(1 for a in self.agents if a.state == RECOVERED)
        immune_count = sum(1 for a in self.agents if a.state == IMMUNE)
        total_count = len(self.agents)
        
        y_offset = 120
        stats = [
            f'Total Population: {total_count}',
            f'Not_Infected: {Not_Infected_count} ({100*Not_Infected_count/max(1,total_count):.1f}%)',
            f'Infected: {infected_count} ({100*infected_count/max(1,total_count):.1f}%)',
            f'Recovered: {recovered_count} ({100*recovered_count/max(1,total_count):.1f}%)',
            f'Immune: {immune_count} ({100*immune_count/max(1,total_count):.1f}%)',
        ]
        
        for stat in stats:
            rendered_text = FONT.render(stat, True, TEXT_COLOR)
            screen.blit(rendered_text, (10, y_offset))
            y_offset += 20

    def draw_controls(self):
        y_offset = 300
        controls = [
            'CONTROLS:',
            f'I/U: Infection Rate ({self.infection_probability:.3f})',
            f'R/T: Recovery Rate ({self.recovery_probability:.3f})',
            f'V/B: Initial Vaccination ({self.initial_vaccination_rate:.2f})',
            f'O/P: Ongoing Vacc Rate ({self.ongoing_vaccination_rate:.5f})',
            f'M: Toggle Ongoing Vacc ({"ON" if self.ongoing_vaccination_enabled else "OFF"})',
            f'Q: Toggle Quarantine ({"ON" if self.quarantine_enabled else "OFF"})',
            'SPACE: Pause/Resume',
            'N: New Simulation',
        ]
    
        for i, control in enumerate(controls):
            color = FONT_LARGE.render('', True, TEXT_COLOR).get_rect().size if i == 0 else TEXT_COLOR
            font = FONT_LARGE if i == 0 else FONT
            rendered_text = font.render(control, True, TEXT_COLOR)
            screen.blit(rendered_text, (10, y_offset))
            y_offset += 25 if i == 0 else 20


    def draw_graphs(self):
        if len(self.history_infected) < 2:
            return
        
        graph_width = 180
        graph_height = 80
        graph_x = 10
        
        # Graph 1: Population over time
        graph_y = HEIGHT - 180
        self.draw_graph(
            graph_x, graph_y, graph_width, graph_height,
            [self.history_not_infected, self.history_infected, 
             self.history_recovered, self.history_immune],
            [NOT_INFECTED_COLOR, INFECTED_COLOR, RECOVERED_COLOR, VACCINATED_COLOR],
            "Population Over Time"
        )
        
        # Graph 2: Infection and Recovery Rates
        graph_y = HEIGHT - 90
        self.draw_graph(
            graph_x, graph_y, graph_width, graph_height,
            [self.history_infection_rate, self.history_recovery_rate],
            [INFECTED_COLOR, RECOVERED_COLOR],
            "Infection/Recovery Rates"
        )

    def draw_graph(self, x, y, width, height, data_series, colors, title):
        # Draw background
        pygame.draw.rect(screen, (50, 50, 50), (x, y, width, height))
        pygame.draw.rect(screen, TEXT_COLOR, (x, y, width, height), 1)
        
        # Draw title
        title_text = FONT.render(title, True, TEXT_COLOR)
        screen.blit(title_text, (x + 5, y + 5))
        
        # Find max value for scaling
        max_val = 1
        for series in data_series:
            if series:
                max_val = max(max_val, max(series))
        
        # Draw data lines
        for series, color in zip(data_series, colors):
            if len(series) < 2:
                continue
            
            points = []
            for i, value in enumerate(series):
                # Scale to graph dimensions
                px = x + (i / len(series)) * width
                py = y + height - (value / max_val) * (height - 25)
                points.append((px, py))
            
            if len(points) > 1:
                pygame.draw.lines(screen, color, False, points, 2)


# Scenario presets
def scenario_all_die():
    sim = Simulation(num_agents=100, initial_infected=5)
    
    # Infection parameters - very aggressive
    sim.infection_probability = 0.025         # High infection rate
    sim.infection_radius = 25                 # Larger infection radius
    
    # Recovery/Death parameters - deadly disease
    sim.recovery_time = 600                   # 10 seconds minimum infection
    sim.recovery_probability = 0.0001         # Almost no recovery (0.01%)
    sim.death_probability = 0.012             # High death rate (1.2% per frame after recovery_time)
    
    # Vaccination parameters - no protection
    sim.initial_vaccination_rate = 0.0        # No one vaccinated at start
    sim.vaccination_success_rate = 0.0        # Vaccination doesn't work (if any)
    sim.ongoing_vaccination_enabled = False   # No ongoing vaccination
    sim.ongoing_vaccination_rate = 0.0        # No vaccination over time
    
    # Quarantine - disabled for maximum spread
    sim.quarantine_enabled = False            # No quarantine
    
    # REAPPLY VACCINATIONS - This removes existing vaccinations and applies new rate (0%)
    # First, remove all existing vaccinations
    for agent in sim.agents:
        if agent.state == IMMUNE:
            agent.state = NOT_INFECTED
    # Then reapply with new rate (which is 0, so no one gets vaccinated)
    sim.apply_vaccinations()
    
    return sim


def scenario_some_survive():
    sim = Simulation(num_agents=150, initial_infected=3)
    
    # Infection parameters - moderate spread
    sim.infection_probability = 0.012         # Moderate infection rate
    sim.infection_radius = 20                 # Standard infection radius
    
    # Recovery/Death parameters - survivable disease
    sim.recovery_time = 900                   # 15 seconds minimum infection
    sim.recovery_probability = 0.01           # Good recovery chance (1% per frame)
    sim.death_probability = 0.002             # Low death rate (0.2% per frame)
    
    # Vaccination parameters - strong vaccination program
    sim.initial_vaccination_rate = 0.35       # 35% vaccinated at start
    sim.vaccination_success_rate = 0.90       # 90% vaccination success rate
    sim.ongoing_vaccination_enabled = True    # Ongoing vaccination campaign
    sim.ongoing_vaccination_rate = 0.00015    # Moderate vaccination speed
    
    # Quarantine - enabled with delay to allow some spread
    sim.quarantine_enabled = True             # Quarantine enabled
    
    # REAPPLY VACCINATIONS - Apply new vaccination rate (35%)
    # First, remove all existing vaccinations
    for agent in sim.agents:
        if agent.state == IMMUNE:
            agent.state = NOT_INFECTED
    # Then reapply with new rate
    sim.apply_vaccinations()
    
    return sim


def scenario_pandemic_with_intervention():
    sim = Simulation(num_agents=200, initial_infected=5)
    
    # Infection parameters
    sim.infection_probability = 0.018         # Higher initial infection rate
    sim.infection_radius = 22                 
    
    # Recovery/Death parameters
    sim.recovery_time = 1200                  # 20 seconds (realistic illness duration)
    sim.recovery_probability = 0.006          # Moderate recovery
    sim.death_probability = 0.003             # Moderate death rate
    
    # Vaccination parameters - gradual rollout
    sim.initial_vaccination_rate = 0.15       # Only 15% vaccinated at start (slow start)
    sim.vaccination_success_rate = 0.85       # 85% vaccination success
    sim.ongoing_vaccination_enabled = True    # Vaccination campaign ramps up
    sim.ongoing_vaccination_rate = 0.0002     # Faster vaccination rollout
    
    # Quarantine - enabled
    sim.quarantine_enabled = True             # Quarantine helps control spread
    
    # REAPPLY VACCINATIONS - Apply new vaccination rate (15%)
    # First, remove all existing vaccinations
    for agent in sim.agents:
        if agent.state == IMMUNE:
            agent.state = NOT_INFECTED
    # Then reapply with new rate
    sim.apply_vaccinations()
    
    return sim


if __name__ == "__main__":
    # Choose your scenario:
    
    # Scenario 1: Deadly outbreak - everyone dies
    #simulation = scenario_all_die()
    
    # Scenario 2: Controlled outbreak - some survive, virus disappears
    simulation = scenario_some_survive()
    
    # Scenario 3: Realistic pandemic with interventions
    #simulation = scenario_pandemic_with_intervention()
    
    # Or use default parameters:
    # simulation = Simulation()
    
    simulation.run()

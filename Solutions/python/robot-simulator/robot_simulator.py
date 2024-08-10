# Globals for the directions
# Directions are represented as (x, y) tuples
EAST = (1, 0)
NORTH = (0, 1)
WEST = (-1, 0)
SOUTH = (0, -1)
# All possible directions
DIRECTIONS = [NORTH, EAST, SOUTH, WEST]


class Robot:
    def __init__(self, direction=NORTH, x_pos=0, y_pos=0):
        self.direction = direction
        self.coordinates = (x_pos, y_pos)

    def turn_right(self):
        self.direction = DIRECTIONS[(DIRECTIONS.index(self.direction) + 1) % 4]

    def turn_left(self):
        self.direction = DIRECTIONS[(DIRECTIONS.index(self.direction) - 1) % 4]

    def advance(self):
        x, y = self.coordinates
        dx, dy = self.direction
        self.coordinates = (x + dx, y + dy)

    def move(self, instructions):
        for instruction in instructions:
            if instruction == "R":
                self.turn_right()
            elif instruction == "L":
                self.turn_left()
            elif instruction == "A":
                self.advance()

class Garden:

    PLANTS = {"V": "Violets", "R": "Radishes", "C": "Clover", "G": "Grass"}

    DEFAULT_STUDENTS = [
        "Alice",
        "Bob",
        "Charlie",
        "David",
        "Eve",
        "Fred",
        "Ginny",
        "Harriet",
        "Ileana",
        "Joseph",
        "Kincaid",
        "Larry",
    ]

    def __init__(self, diagram, students=None):
        self.rows = diagram.split("\n")
        self.students = sorted(students if students else self.DEFAULT_STUDENTS)

    def plants(self, student):
        index = self.students.index(student) * 2
        student_plants = [
            self.rows[0][index],
            self.rows[0][index + 1],
            self.rows[1][index],
            self.rows[1][index + 1],
        ]
        return [self.PLANTS[plant] for plant in student_plants]

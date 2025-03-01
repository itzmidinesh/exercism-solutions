class Allergies:

    def __init__(self, score):
        self._score = score

    def allergic_to(self, item):
        return item in self.lst

    @property
    def lst(self):
        allergens = {
            "eggs": 1,
            "peanuts": 2,
            "shellfish": 4,
            "strawberries": 8,
            "tomatoes": 16,
            "chocolate": 32,
            "pollen": 64,
            "cats": 128,
        }
        return [
            allergen for allergen, value in allergens.items() if self._score & value
        ]

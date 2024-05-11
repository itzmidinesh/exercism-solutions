from itertools import permutations

# Define attributes and their possible values
COLORS = ["red", "green", "ivory", "yellow", "blue"]
NATIONS = ["English", "Spanish", "Ukrainian", "Norwegian", "Japanese"]
PETS = ["dog", "snails", "fox", "horse", "zebra"]
DRINKS = ["coffee", "tea", "milk", "orange juice", "water"]
SMOKES = ["Old Gold", "Kools", "Chesterfields", "Lucky Strike", "Parliaments"]


def solve():
    # Generate all permutations of attribute values
    perms = [
        list(permutations(attr)) for attr in [COLORS, NATIONS, PETS, DRINKS, SMOKES]
    ]
    house = None

    # Iterate through permutations and apply constraints
    for colors in perms[0]:
        colors = list(colors)
        if any(
            [
                colors.index("green") + 1 != colors.index("ivory"),
                colors.index("blue") != 1,
            ]
        ):
            continue
        for nations in perms[1]:
            nations = list(nations)
            if any(
                [
                    colors.index("red") != nations.index("English"),
                    nations.index("Norwegian") != 0,
                ]
            ):
                continue
            for pets in perms[2]:
                pets = list(pets)
                if nations.index("Spanish") != pets.index("dog"):
                    continue
                for drinks in perms[3]:
                    drinks = list(drinks)
                    if any(
                        [
                            drinks.index("coffee") != colors.index("green"),
                            nations.index("Ukrainian") != drinks.index("tea"),
                            drinks.index("milk") != 2,
                        ]
                    ):
                        continue
                    for smokes in perms[4]:
                        smokes = list(smokes)
                        if any(
                            [
                                smokes.index("Old Gold") != pets.index("snails"),
                                smokes.index("Kools") != colors.index("yellow"),
                                abs(smokes.index("Kools") - pets.index("horse")) != 1,
                                abs(smokes.index("Chesterfields") - pets.index("fox"))
                                != 1,
                                smokes.index("Lucky Strike")
                                != drinks.index("orange juice"),
                                smokes.index("Parliaments")
                                != nations.index("Japanese"),
                            ]
                        ):
                            continue
                        house = list(zip(colors, nations, pets, drinks, smokes))
    return house


# Solve the puzzle
solution = solve()


# Extract solutions for the questions
def drinks_water():
    water_house = [h for h in solution if h[3] == "water"][0]
    return water_house[1]


def owns_zebra():
    zebra_house = [h for h in solution if h[2] == "zebra"][0]
    return zebra_house[1]

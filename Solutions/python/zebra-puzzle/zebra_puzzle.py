from constraint import (
    Problem,
    AllDifferentConstraint,
    InSetConstraint,
    ExactSumConstraint,
)


def solve_zebra_puzzle():
    problem = Problem()

    # Define variables and their possible values
    colors = ["red", "green", "ivory", "yellow", "blue"]
    nations = ["English", "Spanish", "Ukrainian", "Norwegian", "Japanese"]
    pets = ["dog", "snails", "fox", "horse", "zebra"]
    drinks = ["coffee", "tea", "milk", "orange juice", "water"]
    smokes = ["Old Gold", "Kools", "Chesterfields", "Lucky Strike", "Parliaments"]

    # Add variables to the problem
    problem.addVariables(colors, range(1, 6))
    problem.addVariables(nations, range(1, 6))
    problem.addVariables(pets, range(1, 6))
    problem.addVariables(drinks, range(1, 6))
    problem.addVariables(smokes, range(1, 6))

    # Add constraints
    problem.addConstraint(AllDifferentConstraint(), colors)
    problem.addConstraint(AllDifferentConstraint(), nations)
    problem.addConstraint(AllDifferentConstraint(), pets)
    problem.addConstraint(AllDifferentConstraint(), drinks)
    problem.addConstraint(AllDifferentConstraint(), smokes)

    problem.addConstraint(InSetConstraint([1]), ["Norwegian"])
    problem.addConstraint(ExactSumConstraint(3), ["milk"])
    problem.addConstraint(lambda a, b: a == b, ("red", "English"))
    problem.addConstraint(lambda a, b: a == b, ("Spanish", "dog"))
    problem.addConstraint(lambda a, b: a == b, ("green", "coffee"))
    problem.addConstraint(lambda a, b: a == b, ("Ukrainian", "tea"))
    problem.addConstraint(lambda a, b: abs(a - b) == 1, ("green", "ivory"))
    problem.addConstraint(lambda a, b: a == b, ("Old Gold", "snails"))
    problem.addConstraint(lambda a, b: a == b, ("Kools", "yellow"))
    problem.addConstraint(lambda a, b: abs(a - b) == 1, ("Norwegian", "blue"))
    problem.addConstraint(lambda a, b: abs(a - b) == 1, ("Chesterfields", "fox"))
    problem.addConstraint(lambda a, b: abs(a - b) == 1, ("Kools", "horse"))
    problem.addConstraint(lambda a, b: a == b, ("Lucky Strike", "orange juice"))
    problem.addConstraint(lambda a, b: a == b, ("Japanese", "Parliaments"))

    # Solve the problem and return the solution
    solution = problem.getSolution()
    return solution, nations


solution, nations = solve_zebra_puzzle()


def drinks_water():
    water_house = solution["water"]
    return [k for k, v in solution.items() if v == water_house and k in nations][0]


def owns_zebra():
    zebra_house = solution["zebra"]
    return [k for k, v in solution.items() if v == zebra_house and k in nations][0]

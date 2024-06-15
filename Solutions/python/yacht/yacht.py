# Score categories.
# Change the values as you see fit.
YACHT = "yacht"
ONES = "ones"
TWOS = "twos"
THREES = "threes"
FOURS = "fours"
FIVES = "fives"
SIXES = "sixes"
FULL_HOUSE = "full_house"
FOUR_OF_A_KIND = "four_of_a_kind"
LITTLE_STRAIGHT = "little_straight"
BIG_STRAIGHT = "big_straight"
CHOICE = "choice"


def score(dice, category):
    number_map = {"ones": 1, "twos": 2, "threes": 3, "fours": 4, "fives": 5, "sixes": 6}

    if category in number_map:
        return dice.count(number_map[category]) * number_map[category]

    if category == "yacht":
        return 50 if len(set(dice)) == 1 else 0

    if category == "full_house":
        counts = set(dice.count(die) for die in dice)
        return sum(dice) if counts == {2, 3} else 0

    if category == "four_of_a_kind":
        for die in set(dice):
            if dice.count(die) >= 4:
                return die * 4
        return 0

    if category == "little_straight":
        return 30 if sorted(dice) == [1, 2, 3, 4, 5] else 0

    if category == "big_straight":
        return 30 if sorted(dice) == [2, 3, 4, 5, 6] else 0

    if category == "choice":
        return sum(dice)

    return 0

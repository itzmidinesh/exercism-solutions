class Luhn:
    def __init__(self, card_num):
        self.card_num = card_num

    def valid(self):
        card_num = self.card_num.replace(" ", "")
        if len(card_num) <= 1:
            return False
        if not card_num.isdigit():
            return False
        digits = [int(x) for x in card_num[::-1]]
        odd_digits = digits[0::2]
        even_digits = [
            2 * digit if 2 * digit < 10 else 2 * digit - 9 for digit in digits[1::2]
        ]
        total = sum(odd_digits + even_digits)
        return total % 10 == 0

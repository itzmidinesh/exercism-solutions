import re


class PhoneNumber:
    def __init__(self, number):
        # Check for letters in the input and raise an error
        if re.search(r"[a-zA-Z]", number):
            raise ValueError("letters not permitted")

        # Allow parentheses, spaces, and hyphens as valid characters in the phone number
        # Disallow other punctuation like +, *, &, %, etc.
        if re.search(r"[!@#$%^&*;:'\"?<>_\+=]", number) and "+" not in number:
            raise ValueError("punctuations not permitted")

        # Remove all non-digit characters
        cleaned_number = re.sub(r"[^\d]", "", number)

        # Check if the number has 11 digits and starts with '1' (for country code)
        if len(cleaned_number) == 11:
            if cleaned_number[0] != "1":
                raise ValueError("11 digits must start with 1")
            cleaned_number = cleaned_number[1:]  # Remove the country code '1'

        # Check for valid 10-digit length
        if len(cleaned_number) < 10:
            raise ValueError("must not be fewer than 10 digits")
        elif len(cleaned_number) > 10:
            raise ValueError("must not be greater than 11 digits")

        # Area code and exchange code validation
        area_code = cleaned_number[:3]
        exchange_code = cleaned_number[3:6]

        # Separate specific checks for zero or one
        if area_code[0] == "0":
            raise ValueError("area code cannot start with zero")
        if area_code[0] == "1":
            raise ValueError("area code cannot start with one")
        if exchange_code[0] == "0":
            raise ValueError("exchange code cannot start with zero")
        if exchange_code[0] == "1":
            raise ValueError("exchange code cannot start with one")

        # Assign the valid cleaned number
        self.number = cleaned_number
        self.area_code = area_code

    def pretty(self):
        # Format the number in the format (NXX)-NXX-XXXX
        return f"({self.number[:3]})-{self.number[3:6]}-{self.number[6:]}"

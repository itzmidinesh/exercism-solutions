def rotate(text, key):
    result = []

    for char in text:
        result.append(rotate_character(char, key))

    return "".join(result)


def rotate_character(char, key):
    if not char.isalpha():
        return char
    else:
        ascii = ord(char)
        if char.isupper():
            return chr((ascii - 65 + key) % 26 + 65)
        else:
            return chr((ascii - 97 + key) % 26 + 97)

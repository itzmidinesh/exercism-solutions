def rows(letter):
    size = ord(letter) - ord("A") + 1
    diamond = []

    for i in range(size):
        current_letter = chr(ord("A") + i)
        spaces_outside = " " * (size - i - 1)
        if i == 0:
            row = f"{spaces_outside}{current_letter}{spaces_outside}"
        else:
            spaces_inside = " " * (2 * i - 1)
            row = f"{spaces_outside}{current_letter}{spaces_inside}{current_letter}{spaces_outside}"
        diamond.append(row)

    diamond += diamond[:-1][::-1]
    return diamond

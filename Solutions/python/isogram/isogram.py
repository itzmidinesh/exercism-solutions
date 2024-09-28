def is_isogram(string):
    filtered_strings = [char for char in string.lower() if char.isalpha()]
    return len(filtered_strings) == len(set(filtered_strings))

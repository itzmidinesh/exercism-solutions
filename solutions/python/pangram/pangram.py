def is_pangram(sentence):
    return len(set([char.lower() for char in sentence if char.isalpha()])) == 26

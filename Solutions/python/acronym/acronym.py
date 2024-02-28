def abbreviate(words):
    newWords = words.replace("-", " ")
    newWords = "".join([char for char in newWords if char.isalpha() or char.isspace()])
    return "".join([word[0].upper() for word in newWords.split()])

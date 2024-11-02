def recite(start_verse, end_verse):
    animals = ["fly", "spider", "bird", "cat", "dog", "goat", "cow", "horse"]
    verses = {
        "fly": "I don't know why she swallowed the fly. Perhaps she'll die.",
        "spider": "It wriggled and jiggled and tickled inside her.",
        "bird": "How absurd to swallow a bird!",
        "cat": "Imagine that, to swallow a cat!",
        "dog": "What a hog, to swallow a dog!",
        "goat": "Just opened her throat and swallowed a goat!",
        "cow": "I don't know how she swallowed a cow!",
        "horse": "She's dead, of course!",
    }

    def generate_verse(n):
        lines = [f"I know an old lady who swallowed a {animals[n-1]}."]
        if animals[n - 1] != "fly":
            lines.append(verses[animals[n - 1]])
        if animals[n - 1] == "horse":
            return lines
        for i in range(n - 1, 0, -1):
            if animals[i - 1] == "spider":
                lines.append(
                    f"She swallowed the {animals[i]} to catch the {animals[i-1]} that wriggled and jiggled and tickled inside her."
                )
            else:
                lines.append(
                    f"She swallowed the {animals[i]} to catch the {animals[i-1]}."
                )
        lines.append(verses["fly"])
        return lines

    result = []
    for verse_number in range(start_verse, end_verse + 1):
        result.extend(generate_verse(verse_number))
        if verse_number < end_verse:
            result.append("")
    return result

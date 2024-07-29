def find_anagrams(word, candidates):
    normal_word = sorted(word.lower())
    anagrams = []

    for candidate in candidates:
        if (
            sorted(candidate.lower()) == normal_word
            and candidate.lower() != word.lower()
        ):
            anagrams.append(candidate)

    return anagrams

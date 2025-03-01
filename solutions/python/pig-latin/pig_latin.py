def translate(text):
    vowels = "aeiou"
    words = text.split()

    def pig_latin(word):
        if word[0] in vowels or word.startswith("xr") or word.startswith("yt"):
            return word + "ay"

        for i in range(len(word)):
            if word[i] in vowels:
                if word[i - 1 : i + 1] == "qu":
                    return word[i + 1 :] + word[: i + 1] + "ay"
                return word[i:] + word[:i] + "ay"
            if word[i] == "y" and i != 0:
                return word[i:] + word[:i] + "ay"

        return word[1:] + word[0] + "ay" if word[0] == "y" else word + "ay"

    return " ".join([pig_latin(word) for word in words])

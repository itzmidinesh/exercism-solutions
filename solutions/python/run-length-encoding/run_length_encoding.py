import re


def decode(string):
    if not string:
        return ""
    decoded = []
    matches = re.findall(r"(\d+)?([A-Za-z\s])", string)

    for count, char in matches:
        if count:
            decoded.append(char * int(count))
        else:
            decoded.append(char)

    return "".join(decoded)


def encode(string):
    if not string:
        return ""
    encoded = []
    count = 1
    for i in range(1, len(string)):
        if string[i] == string[i - 1]:
            count += 1
        else:
            if count > 1:
                encoded.append(f"{count}")
            encoded.append(string[i - 1])
            count = 1

    if count > 1:
        encoded.append(f"{count}")
    encoded.append(string[-1])
    return "".join(encoded)

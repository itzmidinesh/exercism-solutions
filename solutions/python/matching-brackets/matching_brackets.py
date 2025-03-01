def is_paired(input_string):
    matching_brackets = {")": "(", "}": "{", "]": "["}
    stack = []
    for char in input_string:
        if char in matching_brackets.values():
            stack.append(char)
        elif char in matching_brackets:
            if stack == [] or stack.pop() != matching_brackets[char]:
                return False
    return stack == []

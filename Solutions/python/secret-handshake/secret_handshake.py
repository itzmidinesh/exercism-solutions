def commands(binary_str):
    actions = ["wink", "double blink", "close your eyes", "jump"]
    result = [actions[i] for i in range(4) if binary_str.zfill(5)[-(i + 1)] == "1"]
    return result[::-1] if binary_str.zfill(5)[0] == "1" else result

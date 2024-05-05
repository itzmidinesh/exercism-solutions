def rebase(input_base, digits, output_base):
    if input_base < 2:
        raise ValueError("input base must be >= 2")
    if output_base < 2:
        raise ValueError("output base must be >= 2")
    if any(d < 0 or d >= input_base for d in digits):
        raise ValueError("all digits must satisfy 0 <= d < input base")
    # Convert input digits to base 10
    num = sum(d * input_base**i for i, d in enumerate(reversed(digits)))
    if num == 0:
        return [0]

    # Convert base 10 number to output base
    output_digits = []
    while num > 0:
        num, remainder = divmod(num, output_base)
        output_digits.append(remainder)

    return output_digits[::-1]

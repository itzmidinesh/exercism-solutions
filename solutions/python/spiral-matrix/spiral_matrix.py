def spiral_matrix(size):
    if size == 0:
        return []

    matrix = [[0] * size for _ in range(size)]
    num = 1
    left, right = 0, size - 1
    top, bottom = 0, size - 1

    while left <= right and top <= bottom:
        # Fill the top row
        for i in range(left, right + 1):
            matrix[top][i] = num
            num += 1
        top += 1
        # Fill the right column
        for i in range(top, bottom + 1):
            matrix[i][right] = num
            num += 1
        right -= 1
        # Fill the bottom row
        if top <= bottom:
            for i in range(right, left - 1, -1):
                matrix[bottom][i] = num
                num += 1
            bottom -= 1
        # Fill the left column
        if left <= right:
            for i in range(bottom, top - 1, -1):
                matrix[i][left] = num
                num += 1
            left += 1
    return matrix

def annotate(minefield):
    if not minefield:
        return []
    rows, cols = len(minefield), len(minefield[0])

    # check input validity
    for row in minefield:
        if len(row) != cols:
            raise ValueError("The board is invalid with current input.")
        for char in row:
            if char not in ["*", " "]:
                raise ValueError("The board is invalid with current input.")

    # Initialize output board
    output_board = [list(row) for row in minefield]

    # Function to count adjacent mines around a cell
    def count_adjacent_mines(row, col):
        return sum(
            1
            for i in range(row - 1, row + 2)
            for j in range(col - 1, col + 2)
            if 0 <= i < rows and 0 <= j < cols and minefield[i][j] == "*"
        )

    # Update output board
    for row in range(rows):
        for col in range(cols):
            if minefield[row][col] == "*":
                output_board[row][col] = "*"
            else:
                mine_count = count_adjacent_mines(row, col)
                output_board[row][col] = str(mine_count) if mine_count > 0 else " "

    # Convert output board to list of strings
    return ["".join(row) for row in output_board]

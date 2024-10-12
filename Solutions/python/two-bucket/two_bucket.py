from collections import deque


def measure(bucket_one, bucket_two, goal, start_bucket):
    queue = deque([(0, 0, 0)])  # (amount in bucket 1, amount in bucket 2, step count)
    visited = set()

    while queue:
        amount_1, amount_2, steps = queue.popleft()

        if (amount_1, amount_2) in visited:
            continue

        # Skip invalid starting states
        if (start_bucket == "one" and amount_1 == 0 and amount_2 == bucket_two) or (
            start_bucket == "two" and amount_1 == bucket_one and amount_2 == 0
        ):
            continue

        visited.add((amount_1, amount_2))

        # Check if goal is reached
        if amount_1 == goal:
            return (steps, "one", amount_2)
        if amount_2 == goal:
            return (steps, "two", amount_1)

        # Generate all possible next states
        next_states = [
            (
                amount_1 - min(bucket_two - amount_2, amount_1),
                amount_2 + min(bucket_two - amount_2, amount_1),
            ),  # Pour 1 to 2
            (0, amount_2),  # Empty 1
            (bucket_one, amount_2),  # Fill 1
            (
                amount_1 + min(bucket_one - amount_1, amount_2),
                amount_2 - min(bucket_one - amount_1, amount_2),
            ),  # Pour 2 to 1
            (amount_1, 0),  # Empty 2
            (amount_1, bucket_two),  # Fill 2
        ]

        for new_amount_1, new_amount_2 in next_states:
            queue.append((new_amount_1, new_amount_2, steps + 1))

    raise ValueError("Goal amount cannot be reached.")

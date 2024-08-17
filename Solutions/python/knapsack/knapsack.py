def maximum_value(maximum_weight, items):
    dp = [0] * (maximum_weight + 1)

    for item in items:
        weight = item["weight"]
        value = item["value"]

        for i in range(maximum_weight, weight - 1, -1):
            dp[i] = max(dp[i], dp[i - weight] + value)

    return dp[maximum_weight]

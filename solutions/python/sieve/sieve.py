def primes(limit):
    # Implement the sieve of Eratosthenes here
    results = [True for _ in range(limit + 1)]
    results[0] = results[1] = False

    for i in range(2, int(limit**0.5) + 1):
        if results[i]:
            for j in range(i * i, limit + 1, i):
                results[j] = False
    return [i for i, prime in enumerate(results) if prime]

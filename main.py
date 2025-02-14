def can_reach_target(numbers, target, memo, path):
    if len(numbers) == 1:
        if abs(numbers[0] - target) < 1e-6:
            return {tuple(path)}
        else:
            return set()

    # Create a sorted tuple to use as a memo key
    key = tuple(sorted(numbers))
    if key in memo:
        return memo[key]

    paths = set()

    # Iterate over all unique pairs (i, j) where i < j
    for i in range(len(numbers)):
        for j in range(i + 1, len(numbers)):
            a = numbers[i]
            b = numbers[j]
            # Create the remaining list by excluding a and b
            remaining = [numbers[k] for k in range(len(numbers)) if k != i and k != j]

            # Try addition
            new_numbers = remaining + [a + b]
            result = can_reach_target(
                new_numbers, target, memo, path + [f"({a} + {b})"]
            )
            paths.update(result)

            # Try multiplication
            new_numbers = remaining + [a * b]
            result = can_reach_target(
                new_numbers, target, memo, path + [f"({a} * {b})"]
            )
            paths.update(result)

            # Try subtraction (a - b)
            new_numbers = remaining + [a - b]
            result = can_reach_target(
                new_numbers, target, memo, path + [f"({a} - {b})"]
            )
            paths.update(result)

            # Try subtraction (b - a)
            new_numbers = remaining + [b - a]
            result = can_reach_target(
                new_numbers, target, memo, path + [f"({b} - {a})"]
            )
            paths.update(result)

            # Try division (a / b) if b is not zero
            if b != 0:
                new_num = a / b
                new_numbers = remaining + [new_num]
                result = can_reach_target(
                    new_numbers, target, memo, path + [f"({a} / {b})"]
                )
                paths.update(result)

            # Try division (b / a) if a is not zero
            if a != 0:
                new_num = b / a
                new_numbers = remaining + [new_num]
                result = can_reach_target(
                    new_numbers, target, memo, path + [f"({b} / {a})"]
                )
                paths.update(result)

    memo[key] = paths
    return paths


# Example usage:
initial_numbers = [4, 4, 4, 4]
target = 24
all_paths = can_reach_target(initial_numbers, target, {}, [])
for idx, path in enumerate(all_paths):
    print(f"Path {idx + 1}: {list(path)}")

def find(search_list, value):
    left, right = 0, len(search_list) - 1

    while left <= right:
        mid = (left + right) // 2
        mid_val = search_list[mid]

        if mid_val == value:
            return mid
        elif mid_val < value:
            left = mid + 1
        else:
            right = mid - 1

    raise ValueError("value not in array")

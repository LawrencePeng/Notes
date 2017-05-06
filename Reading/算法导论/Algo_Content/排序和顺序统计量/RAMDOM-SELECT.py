def rand_sec(arr, left, right, k):
    if left == right:
        return arr[left]
    q = rand_partition(arr, left, right)
    pos = q - left + 1
    if pos == k:
        return arr[q]
    if k < pos:
        return rand_sec(arr, left, q - 1, k)
    return rand_sec(arr, q + 1, right, k)


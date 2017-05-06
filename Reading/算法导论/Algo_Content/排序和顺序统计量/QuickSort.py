def Partition(arr, p, r):
    x = arr[r]
    i = p - 1
    for j in range(p, r):
        if arr[j] <= x:
            i += 1
            arr[j], arr[i] = arr[i], arr[j]
    arr[i + 1], arr[r] = arr[r], arr[i + 1]
    return i + 1
def QuickSort(arr, p, r):
    if p < r:
        q = Partition(arr, p, r)
        QuickSort(arr, p, q - 1)
        QuickSort(arr, q + 1, r)

arr = [5,4,3,2,1]

QuickSort(arr, 0, len(arr) - 1)

print arr

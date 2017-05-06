def count_sort(arr,max_num):
    b = [0 for x in range(len(arr) + 1)]
    c = [0 for x in range(max_num + 1)]
    for x in range(len(arr)):
        c[arr[x]] += 1
    for x in range(1,max_num + 1):
        c[x] += c[x - 1]
    for x in range(len(arr) - 1, -1, -1):
        b[c[arr[x]]] = arr[x]
        c[arr[x]] -= 1
    return b
print count_sort([1,5,2,4,3,100],100)


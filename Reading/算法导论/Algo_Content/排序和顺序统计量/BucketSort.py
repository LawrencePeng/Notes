def BucketSort(arr):
    leng = len(arr)
    seq = 1
    max_num = int(max(arr))
    min_num = int(min(arr))
    bucket_num = (max_num - min_num) / seq
    b = [[] for x in range(bucket_num)]
    for x in range(leng):
        b[int((arr[i] - min_num) / seq)].append(arr[i])
    for x in range(range(bucket(num)))
        b[x].sort()
    return [item for item in (bucket for bucket in b) ]

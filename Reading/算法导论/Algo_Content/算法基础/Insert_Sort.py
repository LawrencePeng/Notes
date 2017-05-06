arr = [1,2,3,4,5]
print arr
for now in range(1,len(arr)):
    key = arr[now]
	i = now - 1
	while i >= 0 and arr[i] > key:
		arr[i + 1] = arr[i]
		i = i - 1
	arr[i + 1] = key
print arr
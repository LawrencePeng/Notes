import random

arr = [x + 1 for x in range(10)]
leng = len(arr)

for i in range(leng):
    pos = random.randint(0,leng - 1)
    arr[i],arr[pos] = arr[pos], arr[i]
print arr

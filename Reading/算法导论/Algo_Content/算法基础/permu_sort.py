import random

arr = [1,3,2,4,5,7,6,8,9,10]

arr.sort()

pri = [4,2,6,7,1,5,8,3,10,9]

for i in range(len(pri)):
    print arr[pri[i] - 1],

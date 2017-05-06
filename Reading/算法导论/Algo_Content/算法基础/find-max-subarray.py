def find_max_subarray(arr):
    def find_max_subarray(arr, low, high):
        def find_max_crossing_subarray(arr, middle, low, high):
            left = right = -999
            max_left = -1
            max_right = -1
            sum = 0
            for i in range(middle, 0, -1):
                sum += arr[i]
                if sum > left:
                    left = sum
                    max_left = i
            sum = 0
            for j in range(middle + 1, high):
                sum += arr[j]
                if sum > right:
                    right = sum
                    max_right = j
            return max_left , max_right, left + right
        if low == high:
            return low, high, arr[low]
        else:
            middle = (low + high) / 2
            (left_low, left_high, left_sum) = find_max_subarray(arr, low, middle)
            (right_low, right_high, right_sum) = find_max_subarray(arr, middle + 1, high)
            (crossing_low, crossing_high, crossing_sum) = find_max_crossing_subarray(arr, middle, low, high)
            if left_sum >= right_sum and left_sum >= crossing_sum:
                return left_low, left_high, left_sum
            elif right_sum >= left_sum and right_sum >= crossing_sum:
                return right_low, right_high, right_sum
            return crossing_sum, crossing_high, crossing_sum
    print find_max_subarray(arr, 0, len(arr) - 1)[2]
find_max_subarray([1,2,2,-3,4,-9])

def merge(left,right):
	ans = []
	ip, jp = 0, 0
	left_len, right_len = len(left), len(right)
	while ip < left_len and jp < right_len:
		if left[ip] <= right[jp]:
			ans.append(left[ip])
			ip += 1
		else:
			ans.append(right[jp])
			jp += 1
	ans.extend(left[ip:])
	ans.extend(right[jp:])
	return ans

def merge_sort(list):
	if len(list) <= 1:
		return list
	middle = len(list) / 2
	return merge(merge_sort(list[:middle]),merge_sort(list[middle:]))

print merge_sort([5,4,3,2,1])

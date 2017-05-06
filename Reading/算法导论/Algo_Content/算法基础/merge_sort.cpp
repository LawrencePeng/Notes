# include <iostream>
# include <vector>

using namespace std;

vector<int> merge(vector<int> left,vector<int> right)
{
	int i = 0, j = 0;
	int left_len = left.size(),right_len = right.size();
	vector<int> ans;
	
    while(i < left_len && j < right_len)
		if(left[i] < right[j])
			ans.push_back(left[i++]);
		else
			ans.push_back(right[j++]);
	
    for(int tmp = i;i < left_len;i++)
		ans.push_back(left[tmp]);
	
    for(int tmp = j;j < right_len;j++)
		ans.push_back(right[tmp]);
	
    return ans;
}

vector<int> merge_sort(vector<int> vc)
{
	if(vc.size() == 1)
		return vc;
    
	int middle = vc.size() / 2;
    vector<int> left,right;
	
    for(int i =0; i < middle;i ++)
	{
		left.push_back(vc[i]);
		right.push_back(vc[middle + i]);
	}
    
	if(vc.size() % 2 != 0)
		right.push_back(vc.back());
    
	return merge(merge_sort(left),merge_sort(right));
}

int main()
{
	vector<int> arr;
	arr.push_back(1);
	arr.push_back(3);
	arr.push_back(2);
	arr.push_back(-1);
	vector<int> ans = merge_sort(arr);
	for(int i = 0; i < ans.size(); i++)
		cout<<ans[i]<<" ";
	cout<<endl;
}

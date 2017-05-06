#include <iostream>
using namespace std;
void Swap(int* ans,int i,int j)
{
    int tmp = *(ans + i);
    *(ans +j) = *(ans + i);
    *(ans + i) = tmp;
}
void shellsort(int a[], int n)
{
    int i, j, gap;
    for (gap = n / 2; gap > 0; gap /= 2)
        for (i = gap; i < n; i++)
            for (j = i - gap; j >= 0 && a[j] > a[j + gap]; j -= gap)
                Swap(a[j], a[j + gap]);
}
int main()
{
    int time;
    cin >>time;
    while(time --) {
        int len;
        cin >> len;
        int *ans = new int[len];
        for (int i = 0; i < len; ++i) {
            cin >> ans[i];
        }
        shellsort(ans, len);
        for (int j = 0; j < len; ++j) {
            cout <<ans[j] <<" ";
        }
        cout<<endl;
    }
    return 0;
}
#include <bits/stdc++.h>

#define ll long long
#define all(v) v.begin(), v.end()
#define fast ios_base::sync_with_stdio(0);cin.tie(0);cout.tie(0);
using namespace std;

struct p {
    double x, y;

    p(double a, double b) {
        x = a;
        y = b;
    }

    p() {

    }
};

int main() {
    int n;
    cin >> n;
    vector<p> ar;
    for (int i = 0; i < n; i++) {
        double x, y;
        cin >> x >> y;
        p t(x, y);
        if (ar.empty())
            ar.emplace_back(t);
        if (t.x == ar.back().x)
            ar.pop_back();
        ar.emplace_back(t);
    }
    vector<vector<p>> D;
    vector<p> nw;
    bool f = true;
    for (int i = 0; i < ar.size(); i++) {
        if (ar[i].y == 3700) {
            if (!nw.empty())
                D.emplace_back(nw);
            nw.clear();
            f = true;
            continue;
        }
        if (nw.empty())
            nw.emplace_back(ar[i]);
        else if (f) {
            if (nw.back().y > ar[i].y) {
                nw.emplace_back(ar[i]);
            } else {
                nw.emplace_back(ar[i]);
                f = false;
            }
        } else {
            if (nw.back().y < ar[i].y)
                nw.emplace_back(ar[i]);
            else {
                D.emplace_back(nw);
                nw.clear();
                f = true;
                nw.emplace_back(ar[i]);
            }
        }
    }

    double ma = 0;
    int ind = -1;
    for (int i = 0; i < D.size(); i++) {
        double r = (D[i].back().x - D[i][0].x);
        if (r > ma) {
            ma = r;
            ind = i;
        }
    }
    cout << ind + 1;
}

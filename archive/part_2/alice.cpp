#include <bits/stdc++.h>

#define ll long long
#define ld long double
#define all(x) x.begin(),x.end()
#define fori(n) for (int i = 0; i < n; ++i)
#define forj(n) for (int j = 0; j < n; j++)
#define ss second
#define ff first
#define pb push_back

//#pragma GCC optimize("Ofast", "unroll-loops", "fast-math", "O3")
#define fast ios_base::sync_with_stdio(0);cin.tie(0);cout.tie(0);
using namespace std;

const ll mod = 1e9 + 9;
const int MN = 4000;
int dx[4] = {0, -1, 0, 1};
int dy[4] = {1, 0, -1, 0};
map<char, int> mp = {{'U', 0},
                     {'D', 2},
                     {'L', 1},
                     {'R', 3},
};

int strToInt(string s) {
    int now = 0;
    for (auto i : s) {
        if (i > '9')
            now = now * 16 + i - 'A' + 10;
        else
            now = now * 16 + i - '0';
    }
    return now;
}

int H, M, K, N;
int si, sj, fi, fj;
int direction;
const int white = strToInt("FFFFFF");
int wall[MN][MN][4];
int dp[MN][MN][4];
bool us[MN][MN][4];
tuple<int, int, int> parent[MN][MN][4];
vector<tuple<int, int, int, char>> Q;


void input() {
    fast
    cin >> H >> M >> K;
    N = H / 250;
    int tt;
    cin >> tt;
    char tmp;
    cin >> tmp;
    direction = mp[tmp];
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            for (int d = 0; d < 4; d++) {
                wall[i][j][d] = white;
            }
        }
    }
    cin >> sj >> si >> fj >> fi;
    sj /= 250;
    si /= 250;
    fi /= 250;
    fj /= 250;
    for (int d = 0; d < M; d++) {
        int i, j, ii, jj;
        string s;
        cin >> i >> j >> ii >> jj;
        cin >> s;
        int color = strToInt(s);
//        cout << color << ' ' << white << endl;
        i /= 250;
        j /= 250;
        ii /= 250;
        jj /= 250;
//        cout << i << ' ' << j << ' ' << ii << ' ' << jj << endl;
        swap(i, j);
        swap(ii, jj);
        if (i > ii)
            swap(i, ii);
        if (j > jj)
            swap(j, jj);
        for (int x = i; x < ii; x++) {
            if (jj != 0)
                wall[x][jj - 1][3] = color;
            if (jj != N)
                wall[x][jj][1] = color;
        }
        for (int y = j; y < jj; y++) {
            if (i != 0)
                wall[i - 1][y][0] = color;
            if (i != N)
                wall[i][y][2] = color;
        }
    }
    for (int i = 0; i < K; i++) {
        int l, u, r;
        cin >> l >> u >> r;
        char t;
        cin >> t;
        Q.emplace_back(l, u, r, t);
    }
//    cout << 123 << endl;
}

void getPositionOfAlice() {
    for (int in = 0; in < N; in++) {
        for (int jn = 0; jn < N; jn++) {
            for (int dir = 0; dir < 4; dir++) {
                if (in == si && jn == sj)
                    continue;
                int d = dir;
                int i = in;
                int j = jn;
                bool f = true;
                for (auto tpl : Q) {
                    int l = get<0>(tpl);
                    int u = get<1>(tpl);
                    int r = get<2>(tpl);
                    char Move = get<3>(tpl);
                    int ii = i + dy[d];
                    int jj = j + dx[d];
                    if (u != ((wall[i][j][d] != white || ii >= N || jj >= N || ii < 0 || jj < 0) ||
                              (ii == si && jj == sj))) {
                        f = false;
                        break;
                    }
                    int dd = (d + 1) % 4;
                    ii = i + dy[dd];
                    jj = j + dx[dd];
                    if (l != ((wall[i][j][dd] != white || ii >= N || jj >= N || ii < 0 || jj < 0) ||
                              (ii == si && jj == sj))) {
                        f = false;
                        break;
                    }
                    dd = (d + 3) % 4;
                    ii = i + dy[dd];
                    jj = j + dx[dd];
                    if (r != ((wall[i][j][dd] != white || ii >= N || jj >= N || ii < 0 || jj < 0) ||
                              (ii == si && jj == sj))) {
                        f = false;
                        break;
                    }
                    if (Move == 'L')
                        d = (d + 1) % 4;
                    if (Move == 'R')
                        d = (d + 3) % 4;
                    if (Move == 'F') {
                        ii = i + dy[d];
                        jj = j + dx[d];
                        if ((wall[i][j][d] != white || ii >= N || jj >= N || ii < 0 || jj < 0) ||
                            (ii == si && jj == sj)) {
                            f = false;
                            break;
                        }
                        i = ii;
                        j = jj;
                    }
                }
                if (f) {
                    if (i != 0) {
                        if (wall[i - 1][j][0] == white)
                            wall[i - 1][j][0] = 0;
                    }
                    if (j != 0) {
                        if (wall[i][j - 1][3] == white)
                            wall[i][j - 1][3] = 0;
                    }
                    if (j != N - 1) {
                        if (wall[i][j + 1][1] == white)
                            wall[i][j + 1][1] = 0;
                    }
                    if (i != N - 1) {
                        if (wall[i + 1][j][2] == white)
                            wall[i + 1][j][2] = 0;
                    }
//                    cout << in << ' ' << jn << ' '  << d << endl;
                    return;
                }
            }
        }
    }
}

vector<int> ans = {white};

string toString(int x) {
    string s;
    while (x) {
        int d = x % 16;
        x /= 16;
        if (d < 10)
            s += d + '0';
        else
            s += 'A' + d - 10;
    }
    while (s.size() < 6)
        s += '0';
    reverse(all(s));
    return s;
}

void precalc() {
    int tmp = 0;
    for (int i = 0; i < N; i++) {
        tmp = white;
        for (int j = 0; j < N; j++) {
            if (wall[i][j][1] != white)
                tmp = wall[i][j][1];
            dp[i][j][1] = tmp;
        }
        tmp = white;
        for (int j = N - 1; j >= 0; j--) {
            if (wall[i][j][3] != white)
                tmp = wall[i][j][3];
            dp[i][j][3] = tmp;
        }
    }
    for (int j = 0; j < N; j++) {
        tmp = white;
        for (int i = 0; i < N; i++) {
            if (wall[i][j][2] != white)
                tmp = wall[i][j][2];
            dp[i][j][2] = tmp;
        }
        tmp = white;
        for (int i = N - 1; i >= 0; i--) {
            if (wall[i][j][0] != white)
                tmp = wall[i][j][0];
//            cout << i << ' ' << j << ' ' << toString(tmp) << endl;
            dp[i][j][0] = tmp;
        }
//        cout << endl;
    }
}

void bfs() {
    queue<tuple<int, int, int>> q;
    q.push({si, sj, direction});
    us[si][sj][direction] = true;
    int D;
    while (!q.empty()) {
        int i = get<0>(q.front());
        int j = get<1>(q.front());
        int d = get<2>(q.front());
//        cout << i << ' ' << j << ' ' << d << endl;
        D = d;
        q.pop();
        int dd = (d + 1) % 4;
        if (!us[i][j][dd]) {
            us[i][j][dd] = true;
            parent[i][j][dd] = {i, j, d};
            q.push(make_tuple(i, j, dd));
        }
        dd = (d + 3) % 4;
        if (!us[i][j][dd]) {
            us[i][j][dd] = true;
            parent[i][j][dd] = {i, j, d};
            q.push(make_tuple(i, j, dd));
        }
        int ii = i + dy[d];
        int jj = j + dx[d];
        if (wall[i][j][d] != white || ii >= N || jj >= N || ii < 0 || jj < 0)
            continue;
        if (us[ii][jj][d])
            continue;
        us[ii][jj][d] = true;
        parent[ii][jj][d] = {i, j, d};
        if (ii == fi && jj == fj)
            break;
        q.push(make_tuple(ii, jj, d));
    }
    int i = fi, j = fj, d = D;
    while (i != si || j != sj || direction != d) {
//        cout << i << ' ' << j << ' ' << d << endl;
//        cout << toString(dp[i][j][d]) << endl;
        int ii = get<0>(parent[i][j][d]);
        int jj = get<1>(parent[i][j][d]);
        int dd = get<2>(parent[i][j][d]);
        if (dp[i][j][d] != ans.back() && dp[i][j][d] != white)
            ans.emplace_back(dp[i][j][d]);
        i = ii, j = jj, d = dd;
        if (dp[i][j][d] != ans.back() && dp[i][j][d] != white)
            ans.emplace_back(dp[i][j][d]);
    }
    reverse(all(ans));
}

int main() {
    fast
    input();

    getPositionOfAlice();

    precalc();

    bfs();

    for (int i = 0; i < ans.size() - 1; i++) {
        cout << toString(ans[i]) << ' ';
    }
}


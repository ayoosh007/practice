# C++ Algorithms: Simple Code and Loop Memory Guide

These programs follow the style of your supplied examples: short functions, explicit loops, direct printing, and fixed examples in `main()`.

Each C++ block is a **separate complete program**. Compile one at a time with `g++ -std=c++17 main.cpp -o main`. N-Queens and assignment use the GCC convenience header `<bits/stdc++.h>`.

**Indexing:** N-Queens and job assignment use **1 to N**, matching your N-Queens file. Strings use **0 to length−1**, matching your string file.

Job assignment means assigning N workers to N jobs at minimum total cost, with each job used once. It is not profit-and-deadline job scheduling. The simpler implementation below is **depth-first branch and bound**; if your syllabus specifically asks for *least-cost/best-first* branch and bound, that variant requires expanding the smallest-bound state first, usually with a priority queue.

## 1. N-Queens

### Remember the logic

**Try column → check previous queens → record → print or recurse.**

`X[k]` stores the column chosen for row k. `Place(k, l)` checks whether column l is safe for that row. Earlier rows already have queens; later rows do not matter yet.

```cpp
#include <bits/stdc++.h>
using namespace std;

int n;           // board size
vector<int> X;   // X[k] = column of the queen in row k (1-indexed)
int count_sol;   // number of solutions found

// Is it safe to put queen k in column l, given queens 1..k-1 already placed?
bool Place(int k, int l) {
    for (int j = 1; j <= k - 1; j++) {
        if (X[j] == l) return false;                    // same column
        if (abs(j - k) == abs(X[j] - l)) return false;  // same diagonal
    }
    return true;
}

void NQueens(int k) {
    for (int l = 1; l <= n; l++) {
        if (Place(k, l)) {
            X[k] = l;
            if (k == n) {                 // all queens placed -> a solution
                count_sol++;
                cout << "Solution " << count_sol << ": ";
                for (int i = 1; i <= n; i++) cout << X[i] << " ";
                cout << "\n";
            } else {
                NQueens(k + 1);           // place the next queen
            }
            // returning here (or the loop advancing to the next l) IS the backtrack
        }
    }
}

int main() {
    n = 4;                    // classic 4-Queens demo
    X.assign(n + 1, 0);
    count_sol = 0;

    cout << "All solutions to " << n << "-Queens:\n";
    NQueens(1);               // start by placing queen in row 1
    cout << "Total solutions: " << count_sol << "\n";
    return 0;
}
```

### Remember the limits

| Variable | Range | Meaning |
| --- | --- | --- |
| `k` | Recursion goes from 1 to N | Current row/queen. |
| `l` | `1 <= l <= n` | Try every column. |
| `j` in `Place` | `1 <= j <= k-1` | Check only earlier queens. |
| `i` when printing | `1 <= i <= n` | Print all N chosen columns. |

**Memory line: “Try till N, check till K−1.”**

- Same column: `X[j] == l`.
- Same diagonal: `abs(j-k) == abs(X[j]-l)`; equal row and column distances.
- Finish when `k == n`, **after** placing the queen in row N.
- No `X[k] = 0` is needed: the next choice overwrites it, and `Place` only reads earlier rows. This is implicit backtracking.

For N=4, the two solutions are `2 4 1 3` and `3 1 4 2`.

## 2. Job assignment using recursive branch and bound

### Remember the logic

**Check bound → try unused job → mark → recurse → unmark.**

`Assign(k, currentCost)` assigns a job to worker k. Workers 1 through k−1 already have jobs. `X[k]` is the chosen job; `used[j]` prevents assigning that job twice.

The bound estimates the cheapest possible final cost:

`currentCost + each remaining worker's cheapest unused job`

When calculating the bound, two workers may use the same job in the **estimate**. This makes it optimistic, because the estimate relaxes the one-job-per-worker restriction on job reuse. Actual assignments always enforce unique jobs.

If even this optimistic estimate is `>= bestCost`, return immediately. That is the branch-and-bound step, rather than ordinary exhaustive backtracking.

```cpp
#include <bits/stdc++.h>
using namespace std;

int n;
vector<vector<long long>> cost;
vector<int> X, bestX;  // X[k] = job assigned to worker k (1-indexed).
vector<bool> used;
long long bestCost;

// Optimistic total: actual cost + cheapest unused job for each remaining worker.
long long Bound(int k, long long currentCost) {
    long long estimate = currentCost;
    for (int i = k; i <= n; i++) {
        long long cheapest = LLONG_MAX;
        for (int j = 1; j <= n; j++) {
            if (!used[j])
                cheapest = min(cheapest, cost[i][j]);
        }
        estimate += cheapest;
    }
    return estimate;
}

void Assign(int k, long long currentCost) {
    if (k == n + 1) { // All workers have jobs.
        if (currentCost < bestCost) {
            bestCost = currentCost;
            bestX = X;
        }
        return;
    }

    if (Bound(k, currentCost) >= bestCost) return; // Cannot improve best.

    for (int j = 1; j <= n; j++) {
        if (!used[j]) {
            X[k] = j;                           // Choose job j.
            used[j] = true;                     // Mark it occupied.
            Assign(k + 1, currentCost + cost[k][j]);
            used[j] = false;                    // Undo for the next branch.
        }
    }
}

int main() {
    n = 4;
    // Row 0 and column 0 are unused, so workers/jobs run from 1 to n.
    cost = {
        {0, 0, 0, 0, 0},
        {0, 9, 2, 7, 8},
        {0, 6, 4, 3, 7},
        {0, 5, 8, 1, 8},
        {0, 7, 6, 9, 4}
    };
    X.assign(n + 1, 0);
    bestX.assign(n + 1, 0);
    used.assign(n + 1, false);

    // Start with a valid answer: worker i gets job i.
    bestCost = 0;
    for (int i = 1; i <= n; i++) {
        bestX[i] = i;
        bestCost += cost[i][i];
    }

    Assign(1, 0);
    cout << "Minimum cost: " << bestCost << "\n";
    for (int i = 1; i <= n; i++)
        cout << "Worker " << i << " -> Job " << bestX[i] << "\n";
    return 0;
}
```

### Remember the limits

| Variable | Range | Meaning |
| --- | --- | --- |
| `k` in `Assign` | Starts at 1 | Next worker to assign. |
| `j` in `Assign` | `1 <= j <= n` | Try every job, skipping used ones. |
| `i` in `Bound` | `k <= i <= n` | Only remaining workers need estimated costs. |
| `j` in `Bound` | `1 <= j <= n` | Find the cheapest unused job for this worker. |
| Base case | `k == n+1` | The last worker was assigned in the previous call. |

**Memory line: “Jobs 1 to N; bound workers K to N; finish N+1.”**

Unlike N-Queens' placement array, `used[j]` **must be undone**. Otherwise a later branch sees a job as occupied even though the assignment that occupied it was abandoned.

### Small dry run

- Initial complete assignment is `1→1, 2→2, 3→3, 4→4`, costing `9+4+1+4 = 18`.
- Root bound is `2+3+1+4 = 10`. This is less than 18, so explore.
- After worker 1 gets job 1, the bound is `9+3+1+4 = 17`. Continue exploring.
- The optimal assignment found is `1→2, 2→1, 3→3, 4→4`, costing **13**.
- Once best cost is 13, any state with bound at least 13 can be skipped.

Output:

```text
Minimum cost: 13
Worker 1 -> Job 2
Worker 2 -> Job 1
Worker 3 -> Job 3
Worker 4 -> Job 4
```

**Why this bound is safe:** each remaining worker's actual assigned job costs at least that worker's cheapest unused job. Adding these minima cannot exceed the cost of any valid completion.

Do not mark jobs inside `Bound`: greedily forcing distinct jobs during estimation can overestimate and prune a useful branch. Costs may be negative; pruning still works because it uses the complete lower bound, not only `currentCost`. Assume N≥1, all assignments are allowed, and sums fit in `long long`.

## 3. Naive string matching

### Remember the logic

**Try every start → compare characters → break on mismatch → print if all matched.**

`i` is the text window's start. `j` is the offset within the pattern. Compare `text[i+j]` with `pattern[j]`.

```cpp
#include <iostream>
#include <string>
using namespace std;

void naiveSearch(const string& text, const string& pattern) {
    int n = text.length();
    int m = pattern.length();

    // Empty pattern matches every boundary, including after the last character.
    if (m == 0) {
        for (int i = 0; i <= n; i++)
            cout << "Pattern found at index " << i << "\n";
        return;
    }
    if (m > n) return;


    for (int i = 0; i <= n - m; i++) {
        int j;
        // Check for pattern match starting at index i
        for (j = 0; j < m; j++) {
            if (text[i + j] != pattern[j])
                break;
        }
        if (j == m)   // full pattern matched
            cout << "Pattern found at index " << i << "\n";
    }
}

int main() {
    string text = "AABAACAADAABAABA";
    string pattern = "AABA";
    naiveSearch(text, pattern);
    return 0;
}
```

### Remember the limits

| Loop/check | Limit | Why |
| --- | --- | --- |
| Window starts | `i <= n-m` | The last whole pattern must fit. |
| Character offsets | `j < m` | Pattern indices are 0 through M−1. |
| Full match | `j == m` | The loop completed without a mismatch. |

Derivation: the window ends at `i+m−1`, which must be `<= n−1`. Rearrange to get **`i <= n-m`**.

**Memory line: “Start ≤ N−M; inside < M.”**

For text `AABAACAADAABAABA` and pattern `AABA`, matches start at **0, 9, 12**.

## 4. Rabin–Karp string matching

### Remember the logic

**Build hashes → compare hashes → verify characters → roll to next window.**

| Name | Meaning |
| --- | --- |
| `d` | Base, 256 for byte values. |
| `q` | Positive prime modulus; the example uses 101. |
| `p` | Pattern hash. |
| `t` | Current text window hash. |
| `h` | `d^(m-1) % q`, the leading character's weight. |

The rolling formula is:

`t = (d * (t - outgoing * h) + incoming) % q`

**Memory line: “Remove first, shift left, add next.”** If the remainder is negative, add q. Hash equality only means “possible match”; verify characters to handle collisions.

```cpp
#include <iostream>
#include <string>
using namespace std;

void rabinKarp(const string& text, const string& pattern, int q) {
    int n = text.length();
    int m = pattern.length();

    // Empty pattern matches every boundary, including after the last character.
    if (m == 0) {
        for (int i = 0; i <= n; i++)
            cout << "Pattern found at index " << i << "\n";
        return;
    }
    if (m > n) return;

    const int d = 256;      // number of characters in the alphabet

    long long p = 0;              // hash value for pattern
    long long t = 0;              // hash value for current text window
    long long h = 1;

    // h = d^(m-1) % q  (value of the highest-order digit position)
    for (int i = 0; i < m - 1; i++)
        h = (h * d) % q;

    // Compute initial hash of pattern and first window of text
    for (int i = 0; i < m; i++) {
        p = (d * p + (unsigned char)pattern[i]) % q;
        t = (d * t + (unsigned char)text[i]) % q;
    }

    // Slide the pattern over the text one character at a time
    for (int i = 0; i <= n - m; i++) {
        // If hashes match, verify character by character (avoids false positives)
        if (p == t) {
            int j;
            for (j = 0; j < m; j++) {
                if (text[i + j] != pattern[j])
                    break;
            }
            if (j == m)
                cout << "Pattern found at index " << i << "\n";
        }

        // Compute hash for next window: remove leading digit, add trailing digit
        if (i < n - m) {
            t = (d * (t - (unsigned char)text[i] * h) + (unsigned char)text[i + m]) % q;
            if (t < 0)          // convert negative value to positive
                t += q;
        }
    }
}

int main() {
    string text = "AABAACAADAABAABA";
    string pattern = "AABA";
    rabinKarp(text, pattern, 101); // Positive prime modulus.
    return 0;
}
```

### Remember the limits

| Step | Limit | Memory cue |
| --- | --- | --- |
| Build `h` | `i < m-1` | Highest exponent is M−1. |
| Build initial hashes | `i < m` | Hash M characters. |
| Inspect each window | `i <= n-m` | Include the last window. |
| Verify characters | `j < m` | M character positions. |
| Roll the hash | `i < n-m` | Only when another window exists. |

**Memory line: “Power M−1; hash M; inspect ≤; roll <.”**

Current window: `text[i]` through `text[i+m-1]`. Outgoing character: `text[i]`. Incoming character: `text[i+m]`.

At the last start, `i == n-m`, so `i+m == n`; there is no incoming text character. That is why rolling uses `<`, while inspecting uses `<=`.

The output is the same as naive matching: **0, 9, 12**.

The code keeps your example's structure, with guards for empty/oversized patterns, wider hash arithmetic, and unsigned byte conversion. With the demonstrated integer modulus, intermediate products fit in `long long`.

## Compare the recursive patterns

| Step | N-Queens | Job assignment |
| --- | --- | --- |
| Current decision | Row k chooses column l | Worker k chooses job j |
| Reject a choice/state | `Place(k,l)` is false | Job used, or bound cannot improve best |
| Record choice | `X[k] = l` | `X[k] = j`, mark used |
| Recurse | `NQueens(k+1)` | `Assign(k+1, updatedCost)` |
| Undo | Implicit overwrite | Explicitly unmark job |
| Completion | `k == n` after placement | `k == n+1` on entering next call |

The base cases differ because the completion check occurs at different points, not because one problem needs an extra assignment.

## Complexity and quick checks

| Algorithm | Time | Extra space |
| --- | --- | --- |
| N-Queens | Factorial/exponential search; conservative O(N² × N!) for this scanning implementation, excluding printing | O(N) |
| Assignment B&B | Factorial worst case; each bound O(N²); conservative O(N² × N!) overall | O(N) beyond the O(N²) cost matrix |
| Naive | O((N−M+1)M) worst case for 1≤M≤N | O(1) |
| Rabin–Karp | O(N+M+HM), where H is the number of hash hits; O(NM) worst case | O(1) |

Rabin–Karp is near linear when hash hits are rare. Many genuine matches, as well as collisions, can force repeated verification.

- N-Queens: N=1 → 1 solution; N=2 or 3 → none; N=4 → 2.
- Assignment: the example costs 13; a single worker receives the only job.
- Both matchers: `AAAAA` / `AAA` → 0, 1, 2, including overlapping matches.
- Equal text and pattern → index 0; `i <= n-m` must allow that one iteration.
- Pattern longer than text → no output.
- Empty pattern → every boundary from 0 through N, by the convention used here.

String matching is case-sensitive and byte-based. Assume lengths fit in `int`.

## One-minute recall

1. **N-Queens:** “Try till N, check till K−1.”
2. **Assignment:** “Bound, choose, mark, recurse, unmark.”
3. **Naive:** “Start ≤ N−M; inside < M.”
4. **Rabin–Karp:** “Power M−1; hash M; inspect ≤; roll <.”

/// # vector utilities written by InTheBloom
///
/// ## Description
/// std::vectorに関する便利ツール群
///
/// ## Functions
/// - auto make_vector<Type> (int, int, ...)
///   + 引数で与えた長さの多次元std::vectorを生成し、返却する。
///
/// - int uniq<T> (std::vector<T>& A)
///   + 引数で与えられたstd::vectorについて、すべて等しい要素の連続列を長さ1に縮め、その長さを返却する。この変更は破壊的である。
///   + Aの要素について、等価判定とstd::swapによる交換をO(|A|)回行う。

#include <vector>
#include <algorithm>

namespace inthebloom {
    template <class Type>
    std::vector<Type> make_vector (int N) {
        return std::vector<Type>(N);
    }

    template <class Type, class... Args>
    auto make_vector (int N, Args... args) {
        return std::vector<decltype(make_vector<Type>(args...))>(N, make_vector<Type>(args...));
    }

    template <class T>
    int uniq (std::vector<T>& A) {
        const int N = static_cast<int> (A.size());
        int last = 0;
        int l = 0, r = 0;
        while (l < N) {
            while (r < N) {
                if (A[l] != A[r]) break;
                r++;
            }

            if (last != l) std::swap(A[last], A[l]);
            last++;
            l = r;
        }

        A.resize(last);
        return last;
    }
} // namespace inthebloom


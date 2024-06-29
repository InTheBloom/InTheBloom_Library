/// # Union Find written by InTheBloom
///
/// ## Description
/// N頂点のグラフに対して、以下のクエリを処理する。
/// 1. 任意の2頂点間に辺を追加する。
/// 2. 任意の2頂点が連結であるか判定する。
/// NDEBUGが定義されていない場合、不正な引数が与えられると標準エラー出力にデバッグ出力を行う。これはパフォーマンス低下を引き起こす可能性がある。
///
/// ## Functions:
/// - UnionFind (int N)
///   + (Constructor)
///
/// - const int get_element_size (void)
///   + 現在のNを返す。
///
/// - int root (int u)
///   + 連結成分のその時点での代表元を返す。
///
/// - int unite (int u, int v)
///   + 頂点uと頂点vに辺を追加し、連結成分の代表元を返す。
///
/// - bool same (int u, int v)
///   + 同じ連結成分に属するか判定する。
///
/// - void reset (int N)
///   + 頂点数をNで初期化する。構築時は自動初期化されるため、呼ぶ必要はない。
///
/// ## Varification
/// - UnionFind(yosupo judge): https://judge.yosupo.jp/submission/217769
/// - Union Find(atcoder): https://atcoder.jp/contests/atc001/submissions/55002168
/// - Sum of Maximum Weights(atcoder): https://atcoder.jp/contests/abc214/submissions/55002186

#include <vector>
#include <string>
#include <cassert>
#include <iostream>

namespace inthebloom {
    class UnionFind {
        private:
            std::vector<int> par, siz;
            int N;

            enum class FUNCTION_ID {
                get_element_size,
                root,
                same,
                unite,
                size,
                reset,
            };

            static const std::vector<std::string> function_names;

            void validate_vertex (int u, FUNCTION_ID id) {
                bool res = (0 <= u && u < N);
#ifndef NDEBUG
                if (!res) std::cerr << "UnionFind (" << function_names[static_cast<int> (id)] << "): argument " << std::to_string(u) << " is out of range." << std::endl;
#endif
                assert(res);
            }

            void validate_element_size (int N, FUNCTION_ID id) {
                bool res = (0 <= N && N < 100'000'000);
#ifndef NDEBUG
                if (!res) std::cerr << "UnionFind (" << function_names[static_cast<int> (id)] << "): argument " << std::to_string(N) << " is out of range." << std::endl;
#endif
                assert(res);
            }

        public:
            UnionFind (int N_) {
                reset(N_);
            }

            int get_element_size () const {
                return N;
            }

            int root (int u) {
                validate_vertex(u, FUNCTION_ID::root);
                if (par[u] == u) return u;
                return par[u] = root(par[u]);
            }

            bool same (int u, int v) {
                validate_vertex(u, FUNCTION_ID::same);
                validate_vertex(v, FUNCTION_ID::same);
                return root(u) == root(v);
            }

            int unite (int u, int v) {
                validate_vertex(u, FUNCTION_ID::unite);
                validate_vertex(v, FUNCTION_ID::unite);
                // Union-by-size
                int ru = root(u), rv = root(v);
                if (ru == rv) return ru;
                if (siz[ru] < siz[rv]) std::swap(ru, rv);
                siz[ru] += siz[rv];
                par[rv] = ru;
                return ru;
            }

            int size (int u) {
                validate_vertex(u, FUNCTION_ID::size);
                return siz[root(u)];
            }

            void reset (int N_) {
                validate_element_size(N_, FUNCTION_ID::reset);
                N = N_;
                par.resize(N);
                siz.resize(N);
                for (int i = 0; i < N; i++) par[i] = i;
                for (int i = 0; i < N; i++) siz[i] = 1;
            }
    };

    const std::vector<std::string> UnionFind::function_names = {
        "get_element_size",
        "root",
        "same",
        "unite",
        "size",
        "reset",
    };
} // namespace inthebloom


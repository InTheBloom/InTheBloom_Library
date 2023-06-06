import std;

void read(T...)(string S, ref T args) {
    auto buf = S.split;
    foreach (i, ref arg; args) {
        arg = buf[i].to!(typeof(arg));
    }
}

void read_array(T)(string S, ref T[] arg) {
    arg = S.split.to!(T[]);
}

void main () {
    int n, m; readln.read(n, m);

    auto Graph = Dijkstra!int();

    foreach (_; 0..m) {
        int u, v, w; readln.read(u, v, w);
        Graph.input(u, v, w);
    }

    int begin; readln.read(begin);

    Graph.calculate(begin);

    foreach (i; 1..9) {
        writeln("to ", i, " cost : ", Graph.cost(i));
    }
}

struct Dijkstra(T) {
    T[][T] graph;
    long[T][T] weight;

    struct dijkstra_pair {
        long distance;
        T path;
        T vertex;
    }
    dijkstra_pair[T] node;
    private bool is_calculated = false;
    private bool[T] is_comfirmed;

    // 頂点の型Tであるグラフの辺と重みを受け取る
    void input (T u, T v, long w) {
        graph[u] ~= v;
        weight[u][v] = w;

        node[u] = dijkstra_pair(long.max, u, u);
        node[v] = dijkstra_pair(long.max, v, v);
        is_comfirmed[u] = false;
        is_comfirmed[v] = false;
    }

    // ダイクストラのアルゴリズムに基づいて頂点startからの(連結成分の)最小重みを求める
    void calculate (T start) {
        if (start !in node) {
            stderr.writeln("Fatal error in dijkstra.calculate(T start) : This vertex is not in the graph!");
            return;
        }

        node[start].distance = 0;
        node[start].path = start;

        // 確定済みかどうか
        foreach (ref x; is_comfirmed) {
            x = false;
        }

        // 優先度付きキュー
        BinaryHeap!(Array!dijkstra_pair, "b.distance < a.distance") PQueue;
        PQueue.insert(node[start]);

        while (!PQueue.empty) {
            auto begin = PQueue.front; PQueue.removeFront;
            if (is_comfirmed[begin.vertex]) {
                continue;
            }
            is_comfirmed[begin.vertex] = true;

            if (begin.vertex in graph) {
                foreach (ref x; graph[begin.vertex]) {
                    if (node[begin.vertex].distance + weight[begin.vertex][x] < node[x].distance) {
                        node[x].distance = node[begin.vertex].distance + weight[begin.vertex][x];
                        PQueue.insert(node[x]);
                    }
                }
            }
        }

        foreach (ref x; is_comfirmed) {
            x = true;
        }
        is_calculated = true;
    }

    // 頂点endへの最小重みを出力 パスが存在しなければlong.maxを返す。
    long cost (T end) {
        if (end !in node) {
            stderr.writeln("Fatal error in dijkstra.cost(T end) : This vertex is not in the graph!");
            return long.max;
        }
        if (!is_calculated) {
            stderr.writeln("Costs are not calculatd. Do \"dijkstra.calculate(T start)\" first.");
            return long.max;
        }
        return node[end].distance;
    }
}

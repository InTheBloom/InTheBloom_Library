struct Dijkstra {
    /* data */
    int[][] graph;
    long[int][] weight;
    bool is_calc = false;

    struct dijkstra_node {
        int vertex;
        long distance;
        int path;
    }

    dijkstra_node[] node;

    /* methods */

    this (int N) {
        assert(0 <= N);
        graph = new int[][](N, 0);
        foreach (i; 0..N) {
            node[i] = dijkstra_node(i, long.max, i);
        }
    }

    // u, v must be 0-indexed integer.
    void input (int u, int v, long w) {
        assert(0 <= u);
        assert(0 <= v);
        assert(0 <= w);

        if (graph.length <= max(u, v)) {
            graph.length = max(u, v) + 1;
        }
        graph[u] ~= v;
        weight[u][v] = w;

        if (dijkstra_node.length <= max(u, v)) {
            dijkstra_node.length = max(u, v) + 1;
            node[u] = dijkstra_node(u, long.max, u);
            node[v] = dijkstra_node(v, long.max, v);
        }
    }

    void calc (int start) {
        assert(start < graph.length);

        if (is_calc) {
            foreach (ref x; node) {
                x.distance = long.max;
                x.path = x.vertex;
            }
        }

        node[start].distance = 0;

        BinaryHeap!(dijkstra_node, "b.distance < a.distance") PQ = [];
        PQ.insert(node[start]);

        while (!PQ.empty) {
            auto begin = PQ.front; PQ.removeFront;
            if (node[begin.vertex].distance < begin.distance) {
                continue;
            }
            node[begin.vertex] = begin;

            foreach (ref x; graph[begin.vertex]) {
                if (node[begin.vertex].distance + weight[begin.vertex][x] < node[x].distance) {
                    node[x].distance = node[begin.vertex].distance + weight[begin.vertex][x];
                    node[x].path = begin.vertex;
                    PQ.insert(node[x]);
                }
            }
        }
    }

    int[] trace (int end) {
        DList!int Q;
        int v = end;
        while (node[v].path != v) {
            Q.insertFront(v);
            v = node[v].path
        }
        Q.insertFront(v);
        int[] res;
        while (!Q.empty) {
            res ~= Q.front; Q.removeFront;
        }
        return res;
    }

    long cost (int end) {
        return node[end].distance;
    }
}

class Dijkstra
{
    import std.container : BinaryHeap;
    import std.typecons;
    import std.format : format;

    size_t N;
    long[] cost;
    size_t[][] graph;
    long delegate (int, int) getCost;
    BinaryHeap!(Tuple!(size_t, long)[], "b[1]<a[1]") PQ;

    this (size_t N) {
        this.N = N;
        graph = new size_t[][](N, 0);
        cost = new long[](N);

        Tuple!(size_t, long)[] buf; buf.reserve(N);
        PQ = buf;

        cost[] = long.max;
    }

    // cost setter
    void setCostFunc (long delegate (int, int) func) { this.getCost = func; }

    void addEdge (size_t u, size_t v)
    in {
        assert(u < N, format("Dijkstra.addEdge : out of range. N = %s, u = %s.", N, u));
        assert(v < N, format("Dijkstra.addEdge : out of range. N = %s, v = %s.", N, v));
    }
    do {
        graph[u] ~= v;
    }
    void setStartPoint (size_t v, long W)
    in {
        assert(v < N, format("Dijkstra.addEdge : out of range. N = %s, u = %s.", N, v));
    }
    do {
        PQ.insert(tuple(v, W));
    }

    const(long[]) run ()
    in {
        assert(getCost != null, "Dijkstra.run : function getCost is undefined.");
    }
    do {
        while (!PQ.empty) {
            auto head = PQ.front; PQ.removeFront;
            size_t v = head[0]; long w = head[1];
            if (cost[v] < w) continue;

            cost[v] = w;
            foreach (to; graph[v]) {
                long NewCost = cost[v] + getCost(cast(int) v, cast(int) to);
                if (cost[to] <= NewCost) continue;
                cost[to] = NewCost;
                PQ.insert(tuple(to, NewCost));
            }
        }

        return cost;
    }
}

classdef Graph < handle
    %GRAPH このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        directed
        graph
    end
    properties (Dependent)
        nodeNum
        linkNum
    end   
    methods
        function obj = Graph(graph, directed)
            %コンストラクタ
            obj.graph = graph;
            %graphが無向の場合はdirected = 0, 有向の場合は directed = 1
            obj.directed = directed;
        end
              
        function val = get.nodeNum(obj)
            %ノード数のゲットメソッド
            val = numnodes(obj.graph);
        end
        
        function val = get.linkNum(obj)
            %ノード数のゲットメソッド
            val = numedges(obj.graph);
        end
        
        function adj = getAdjacency(obj)
            %隣接行列（フル行列表記）
            adj = full(adjacency(obj.graph));
        end
    end
end


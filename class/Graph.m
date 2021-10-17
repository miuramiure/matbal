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
            
            obj.graph = graph;
            %graphが無向の場合はdirected = 0, 有向の場合は directed = 1
            obj.directed = directed;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 このメソッドの概要をここに記述
            %   詳細説明をここに記述
            outputArg = obj.Property1 + inputArg;
        end
    end
end


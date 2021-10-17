classdef BalusModel < handle
    %Balusのモデルデータ
    
    properties
        application
        target
        contentType
        id
        contents
    end
    properties (Dependent)
        json
    end
    methods
        function obj = BalusModel(jsonText)
            %
            model = jsondecode(jsonText);
            obj.application = model.application;
            obj.target = model.target;
            obj.contentType = model.contentType;
            obj.id = model.id;
            obj.contents = model.contents;
        end
        
        function graph = getGraph(obj)
            %有向グラフとしてGraphオブジェクトを生成する
            
            links = obj.contents.links;
            nodes = obj.contents.nodes;
            [L,~] = size(links);%リンク数
            [N,~] = size(nodes);%ノード数
            
            %ノードのkeyを格納した配列
            nodeKeys = strings(N,1);
            for i=1:N
                nodeKeys(i) = string(nodes(i).key);
            end
            
            %digraphを生成
            fromNodeIDs = zeros(1,L);
            toNodeIDs = zeros(1,L);
            for i=1:L
                fromNodeIDs(i) = getIndexOfMatch(nodeKeys,string(links(i).fromKey));%fromKeyと一致するノードの番号（ID）
                toNodeIDs(i) = getIndexOfMatch(nodeKeys,string(links(i).toKey));%toKeyと一致するノードの番号（ID）
            end
            g = digraph(fromNodeIDs, toNodeIDs);
            
            graph = Graph(g,1);
            
        end
        
        function val = get.json(obj)
            %Balusにペーストできるjsonを取得する
            model = struct('application', obj.application,'target', obj.target, 'contentType', obj.contentType, 'id', obj.id, 'contents', obj.contents);
            val = jsonencode(model);
        end
    end
    methods(Static)
       function c = nodeColors()
           %nodeに使われている色
           %nodes(x).style.themeColorに入る
           c = [
               "Red";
               "Orange";
               "Yellow";
               "Green";
               "YellowGreen";
               "Blue";
               "Purple";
               "White";
               ];
       end
   end
end


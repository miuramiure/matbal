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
            %jsonの構造をMatlab構造体に変換
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
            nodeKey = strings(N,1);
            for i=1:N
                nodeKey(i) = string(nodes(i).key);
            end
            
            %digraphを生成
            fromNodeIDs = zeros(1,L);
            toNodeIDs = zeros(1,L);
            for i=1:L
                fromNodeIDs(i) = getIndexOfMatch(nodeKey,string(links(i).fromKey));%fromKeyと一致するノードの番号（ID）
                toNodeIDs(i) = getIndexOfMatch(nodeKey,string(links(i).toKey));%toKeyと一致するノードの番号（ID）
            end
            g = digraph(fromNodeIDs, toNodeIDs);
            
            
            %ノード情報テーブルに情報を追加
            nodeText = strings(N,1);%テキスト
            nodePositionX = zeros(N,1);%x座標
            nodePositionY = zeros(N,1);%y座標
            nodeColor = strings(N,1);%themeColor
            
            for i=1:N
                nodeText(i) = string(nodes(i).name.value);
                nodePositionX(i) = nodes(i).position.x;
                nodePositionY(i) = nodes(i).position.y;
                nodeColor(i) = string(nodes(i).style.themeColor);
            end
            
            g.Nodes.text = nodeText;
            g.Nodes.x = nodePositionX;
            g.Nodes.y = nodePositionY;
            g.Nodes.color = nodeColor;
            
            
            %エッジ情報テーブルに情報を追加
            linkText = strings(N,1);%テキスト
            linkLine = strings(N,1);%x座標
            linkMark = strings(N,1);%x座標      
            
            for i=1:L
                linkText(i) = string(links(i).name.value);
                linkLine(i) = string(links(i).style.lineStyle);
                linkMark(i) = string(links(i).style.markStyle);
            end
            
            g.Edges.text = linkText;
            g.Edges.line = linkLine;
            g.Edges.mark = linkMark;
            
            %グラフオブジェクトを生成して戻り値へ
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


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
            %ゾーンとのリンクがあるある場合は正常に動かない
            
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
            fromNodeIdx = zeros(1,L);
            toNodeIdx = zeros(1,L);
            for i=1:L
                fid = getIndexOfMatch(nodeKey,string(links(i).fromKey));%fromKeyと一致するノードの番号（idx）
                tid = getIndexOfMatch(nodeKey,string(links(i).toKey)); %toKeyと一致するノードの番号（idx）
                
                if fid ~= 0 && tid ~= 0 %ノードへのリンク、ノードからのリンクなどを無視
                    fromNodeIdx(i) = fid;
                    toNodeIdx(i) = tid;
                end 
            end
            g = digraph(fromNodeIdx, toNodeIdx);
            

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
        
        function result = removeAllNodes(obj)
            %全てのノードを消す
            obj.contents.nodes = [];
            result = 1;
        end
        
        function result = removeAllLinks(obj)
            %全てのリンクを消す
            obj.contents.links = [];
            result = 1;
        end
        
        function result = removeAllZones(obj)
            %全てのゾーンを消す
            obj.contents.zones = [];
            result = 1;
        end
        
        function nodeText = getAllNodeText(obj)
            %全てのノードのテキストを取得する
            %出力はstringsの配列
            nodes = obj.contents.nodes;
            [N,~] = size(nodes);%ノード数
            nodeText = strings(N,1);%テキスト配列を初期化
            for i=1:N
                nodeText(i) = string(nodes(i).name.value);
            end
        end
        
        function val = get.json(obj)
            %Balusにペーストできるjsonを取得する
            model = struct('application', obj.application,'target', obj.target, 'contentType', obj.contentType, 'id', obj.id, 'contents', obj.contents);
            val = jsonencode(model);
        end
                      
        function result = addVoidZone(obj)
            %空のzoneを1つ追加する
            [n,~] = size(obj.contents.zones); %既存のzoneの数
            newZone = BalusModel.getVoidZoneStruct();
            obj.contents.zones(n+1) = newZone; %n+1番目に新しいzoneを追加
            result = n+1;
        end
        
    end
    methods(Static)
        function c = nodeColor(idx)
            %nodeに使われている色
            %nodes(x).style.themeColorに入る
            colors = [
                "Red";
                "Orange";
                "Yellow";
                "Green";
                "YellowGreen";
                "Blue";
                "Purple";
                "White";
                ];
            c = char(colors(idx));
        end
        
        function style = lineStyles()
            %lineのスタイルのリスト
            %links(x).style.lineStyleに入る
            style = [
                'Dashed';
                'Solid';
                ];
        end

        function date = getDammyDate()
            %ダミーの作成時間情報
            %createdAtに入れる
            date = '2700-01-01T00:00:00.000Z';
        end
        
        function key = getDammyKey(type)
            %ダミーのKeyを生成
            %typeには'Node'や'StickyZone'などが入る
            ch = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
            [~,n] = size(ch);
            code = "";
            for i=1:21
                code = append(code, ch(randi(n)));
            end
            
            key = char(append(type, ':', code));
        end
        
        function key = getDammyUserKey()
            %ダミーのUserKeyを生成
            %createduserKeyなどに入る
            ch = '0123456789';
            [~,n] = size(ch);
            code = "";
            for i=1:16
                code = append(code, ch(randi(n)));
            end
            
            key = char(append('User', ':', code));
        end
        
        function zone = getVoidZoneStruct()
            %空のzoneに相当するstructを生成
            %BalusModel.contetns.zonesに突っ込むことができる
            zone = struct('key',BalusModel.getDammyKey('StickyZone'));
            zone.text = struct('value', '空のゾーン');
            zone.position = struct('x', 300, 'y', 300);
            zone.size = struct('width', 300, 'height', 300);
            zone.style = struct('fontSize', 'L', 'themeColor', BalusModel.nodeColor(1));
            zone.createdUserKey = BalusModel.getDammyUserKey(); 
            zone.createdAt = BalusModel.getDammyDate();
            zone.sourceNodeKey = [];
            zone.containElementKeys = [];
        end
        
        
        
    end
end


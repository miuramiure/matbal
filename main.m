%---初期化---
clc;
clear;
addpath(append(pwd,'\class'));
addpath(append(pwd,'\function'));

%ファイルを読み込み
%data.txtにBalusからコピーしたjsonを貼っておく
iJson = string(importdata("data/input.txt"));

%nodeColors = BalusModel.nodeColors();

%Balusモデルをつくる
bm = BalusModel(iJson);

%グラフオブジェクトをつくる
graph = bm.getGraph();
plot(graph.graph);



%アウトプット用のjsonテキストを取得
oJson = bm.json; 
oJson = strrep(string(oJson), '"sourceNodeKey":[]', '"sourceNodeKey":null');


%ファイルへの書き込み
exist 'data/output.txt';
if ans > 0
   delete 'data/output.txt';%すでにoutputファイルがある場合は1回消す
end

fid = fopen('data/output.txt','w');
fprintf(fid,'%s',oJson);
fclose(fid);
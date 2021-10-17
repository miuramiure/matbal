function index = getIndexOfMatch(vector,target)
%vectorのうちmatchと成分が一致する箇所のindexを返す
%vectorは縦ベクトル
%一致するものがない場合は0を、2箇所以上一致するものがある場合は-1を返す。
N = length(vector);

%i番目の要素にiが入った横ベクトルを生成
iVector = zeros(1,N);
for i=1:N
    iVector(1,i) = i;
end

matchVector = vector == target;
M = sum(matchVector); %合致した数を算出

switch M
    case 0
        result = 0; %合致なしの場合
    case 1
        result = iVector * matchVector;
    otherwise
        result = -1; %複数合致の場合
end

index = result;

end


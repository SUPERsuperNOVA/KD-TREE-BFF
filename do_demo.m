
%待检索图片
testImg_file = './testPictures';
testImg_name = '/motianlun3.jpg';
image = imread([testImg_file testImg_name]);
figure(1);
imshow(image);

%提取带检索图片SIFT特征
[~,descr,~,~ ] = do_sift([testImg_file testImg_name], 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ;

%选择聚类个数
K=500;

% 提取图片库中所有图片的SIFT特征
% [img_paths,Feats] = get_sifts('./img_paths.txt');

% 随机生成K个初始类心
% initMeans = Feats(randi(size(Feats,1),1,K),:);

% 根据生成的初始类心对所有SIFT特征进行聚类
% [KMeans] = K_Means(Feats,K,initMeans);


% 统计图片库每张图片每个聚类中特征点个数，每张图片对应一个K维向量
% [countVectors] = get_countVectors(KMeans,K，size(img_paths,1));

% 统计带检索图片每个聚类中特征点个数，得到一个K维向量
[cosVector] = get_singleVector(KMeans,K,descr');

% 根据余弦相似定理，求带检索图片与图片库中所有图片的余弦夹角
cosValues = zeros(1,size(img_paths,1));
for N =1:size(img_paths,1);
        dotprod = sum(cosVector .* countVectors(N,:));
        dis = sqrt(sum(cosVector.^2))*sqrt(sum(countVectors(N,:).^2));
        cosin = dotprod/dis;
        cosValues(N) = cosin;
end;

% 对结果排序
[vals,index] = sort(acos(cosValues));


% 输出匹配度最高的36张图片
figure(2);
c=0;
% show picture at host
for id = 1:36
    path = img_paths{index(id)};
    image = imread(path);
    if (mod(id-1,12) == 0&&id~=1)
        c=c+1;
        figure(c+2);
    end
    subplot(4,3,id-12*c);
    imshow(image);
end
        
        
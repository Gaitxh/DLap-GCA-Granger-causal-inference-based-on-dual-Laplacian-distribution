function SUM = GC_change(GC,nGC)

% 格兰杰因果连接图的改变
% 输入
% GC:原始无噪仿真数据的格兰杰因果连接矩阵
% nGC:加噪数据的格兰杰因果连接矩阵
% 输出
% SUM:格兰杰因果改变量

% [m,n] = size(GC);
% % 人为定义原始仿真数据真实的格兰杰因果连接
% GC = zeros(m,n);
% for i = 1:1:m
%     GC(i,i) = NaN;
% end
% u = [1,4,5,2,3,4];v = [2,3,3,4,5,5];
% for j = 1:1:length(u)
%     GC(u(j),v(j)) = 1;
% end
% 
% GC(GC<0)   = 0; 
% nGC(nGC<0) = 0;
% 
% gc = NaN*ones(m,n);
% 
% for i = 1:1:m
%     for j = 1:1:n
%         if (~isnan(GC(i,j)))
%             if ((GC(i,j)>0)&&(nGC(i,j)>0))
%                 gc(i,j) = 1;
%             elseif ((GC(i,j)==0)&&(nGC(i,j)==0))
%                 gc(i,j) = 1;
%             else
%                 gc(i,j) = 0;
%             end
%         else
%             gc(i,j) = 0;
%         end
%     end
% end
% 
% SUM = 0;
% for i = 1:1:m
%     for j = 1:1:n
%         SUM = SUM+gc(i,j);
%     end
% end
% 
% end
[m,n] = size(GC);
sum = 0;
for i = 1:m
    for j = 1:n
            if GC(i,j)>0
                GC(i,j) = 1;
            else
                GC(i,j) = 0;
            end
            if nGC(i,j)>0
                nGC(i,j) = 1;
            else
                nGC(i,j) = 0;
            end
            if GC(i,j) == nGC(i,j)
                sum = sum+1;
            end
    end
end
SUM = sum-m;
end

function [Dist,D,k,w]=DTW(t,r,distType)
%% Dynamic Time Warping Algorithm
% Evaluates the dtw distance between two samples vector
% Uses either one dimensional or two dimensional euclidean distance,
% depending on the dimension of the input vectors.
% INPUT ARGS:
% t         ---> vector you are testing against
% r         ---> vector you are testing
% distType  ---> angular vs euclidean distance
%
% OUTPUT ARGS:
% Dist 	---> unnormalized distance between t and r
% D 	---> accumulated distance matrix
% k 	---> normalizing factor
% w 	---> optimal path


[~,N]=size(t);
[~,M]=size(r);

%% Cost matrix evaluation
d=zeros(N,M); %preallocated

if distType==2
    % uses the two-dimensional euclidean distance
    for n=1:N
        for m=1:M
            d(n,m)=norm((t(:,n)-r(:,m)),2);
        end
    end
elseif distType==1
    % uses the angular distance
    for n=1:N
        for m=1:M
            a = mod(t(n)-r(m), 360);
            d(n,m)= min([a, 360-a])/180*pi;
        end
    end
end

D=zeros(size(d)); %accumulate matrix, preallocated

%% accumulate matrix evaluation
D(1,1)=d(1,1);

for n=2:N
    D(n,1)=d(n,1)+D(n-1,1);
end
for m=2:M
    D(1,m)=d(1,m)+D(1,m-1);
end
for n=2:N
    for m=2:M
        D(n,m)=d(n,m)+min([D(n-1,m),D(n-1,m-1),D(n,m-1)]);
    end
end

%% Distance between sample vectors
Dist=D(N,M);

%% Normalizing factor and path evaluation
n=N;
m=M;
k=1;
w=[];
w(1,:)=[N,M];
while ((n+m)~=2)
    if (n-1)==0
        m=m-1;
    elseif (m-1)==0
        n=n-1;
    else
        [~,number]=min([D(n-1,m),D(n,m-1),D(n-1,m-1)]);
        switch number
            case 1
                n=n-1;
            case 2
                m=m-1;
            case 3
                n=n-1;
                m=m-1;
        end
    end
    k=k+1;
    w=cat(1,w,[n,m]);
end

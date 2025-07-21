function X = Initialization(X, nVar, Ub, Lb, Fobj)
for i=1:size(X, 1)
    X(i).Velocity=zeros([1 nVar]);
    X(i).Position=zeros(1,nVar);
    for j=1:nVar
        X(i).Position(1,j)=unifrnd(Lb(j),Ub(j),1);
    end
    X(i).Cost=Fobj(X(i).Position);
    X(i).Best.Position=X(i).Position;
    X(i).Best.Cost=X(i).Cost;
end
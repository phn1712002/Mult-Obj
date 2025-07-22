function s=SimpleBounds(s,lb,ub)
  ns_tmp=s;
  I=ns_tmp<lb;
  ns_tmp(I)=lb(I);
  
  J=ns_tmp>ub;
  ns_tmp(J)=ub(J); 
  s=ns_tmp;
end
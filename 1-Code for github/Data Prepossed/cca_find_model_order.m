function [bic,aic] = cca_find_model_order(X,MINP,MAXP)
[nvar,nobs] = size(X);
if(nobs<nvar) error('Fewer observations than variables, exiting'); end
if(MAXP<=MINP) error('MAXP must be bigger than MINP, exiting'); end

bc = ones(1,MAXP).*999;%the function of ones is make up of a matrix which is 1
ac = ones(1,MAXP).*999;
for i = MINP:MAXP%从1—MAXP，步长为MINP
    eval('res = cca_regress(X,i,0);','res = -1');   % estimate regression model, catch errors
    if(~isnumeric(res))%isunumeric 判断函数res是否是数字类型
        [bc(i),ac(i)] = findbic(res,nvar,nobs,i);
        %disp(['VAR order ',num2str(i),', BIC = ',num2str(bc(i)),', AIC = ',num2str(ac(i))]);
    else
        disp('VAR failed');
        bc(i) = 999; 
        ac(i) = 999;
    end
end

[bicmin,bic] = min(bc);
[aicmin,aic] = min(ac);

%---------------------------------------------------------------------
function [bc,ac] = findbic(res,nvar,nobs,nlag)

error = log(det(res.Z));
nest = nvar*nvar*nlag;       
bc = error + (log(nobs)*nest/nobs);   
ac = error + (2*nest/nobs);

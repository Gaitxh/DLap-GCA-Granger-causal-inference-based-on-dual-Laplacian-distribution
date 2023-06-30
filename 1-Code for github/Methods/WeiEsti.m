function esti_wei = WeiEsti(X,nlags,flag)
nobs = size(X,2);
nvar = size(X,1);
if(nvar>nobs) error('error in cca_granger_regress: nvar>nobs, check input matrix'); end
if nargin == 2, STATFLAG = 1; end
% construct lag matrices
lags = -999*ones(nvar,nobs-nlags,nlags);
for jj=1:nvar
    for ii=1:nlags
        lags(jj,:,nlags-ii+1) = X(jj,ii:nobs-nlags+ii-1);
    end
end

%  unrestricted regression (no constant term)
regressors = zeros(nobs-nlags,nvar*nlags);
for ii=1:nvar,
    s1 = (ii-1)*nlags+1;
    regressors(:,s1:s1+nlags-1) = squeeze(lags(ii,:,:));
end
parfor ii=1:nvar
    xvec = X(ii,:)';
    xdep = xvec(nlags+1:end);
    switch flag
        case 1
            esti_wei(:,ii) = regressors\xdep;
        case 2
            esti_wei(:,ii) = GauGau_Estimate(regressors,xdep);
        case 3
            esti_wei(:,ii) = LapGau_Estimate(regressors,xdep);
        case 4
            esti_wei(:,ii) = GauLap_Estimate(regressors,xdep);
        case 5
            esti_wei(:,ii) = DLap_Estimate(regressors,xdep);
    end
end
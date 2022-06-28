function th = autComputTh(data,sf,multCoeff)
nSamples = length(data);
nWin = 30;
winDur = 200*1e-3;
winDur_samples = winDur.*sf;
startSample = 1:(round(nSamples/nWin)):nSamples;
endSample = startSample+winDur_samples-1;
th = 100;
for ii = 1:nWin
    thThis = std(data(startSample(ii):endSample(ii)));
    if th > thThis
        th = thThis;
    end
end
th = th.*multCoeff;




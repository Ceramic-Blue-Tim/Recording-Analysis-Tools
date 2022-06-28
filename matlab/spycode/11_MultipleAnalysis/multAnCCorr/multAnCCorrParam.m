function multAnCCorrParam(startFolder, expNum, samplingFreq, binsRndPeak, binsRndZero, binsample, str)
% multAnCCorrParam.m
% by Michela Chiappalone (6 Maggio 2005, 9 Maggio 2005, 25 Maggio 2006)
% by Valentina Pasquale - April 2007
% % % % % % % 
% -------- USEFUL PARAMETERS -------- 
cd(startFolder)
cd ..
endFolder = pwd;
ind1 = strfind(startFolder,'_');
ind2 = strfind(startFolder,'-');
ind3 = strfind(startFolder,'msec');
if(strcmp(str,'ST'))                      % CCorr on Spike Train
    finalString = [startFolder(ind1(end-1)+1:ind3(end)-1),' - Analysis_', num2str(binsRndPeak), '-', num2str(binsRndZero), 'ms' ];
elseif(strcmp(str,'BE'))                  % CCorr on Burst Event
    finalString = [startFolder(ind1(end-2)+1:ind3(end)-1),' - Analysis_', num2str(binsRndPeak), '-', num2str(binsRndZero), 'ms' ];
end
[resultFolder] = createresultfolder(endFolder, expNum, finalString);
% % % % % % % % 
% ------- COMPUTATION PHASE ANALYZE CROSS_CORRELATION FUNCTION --------
compCCorrParam (binsRndPeak, binsRndZero, binsample, samplingFreq, startFolder, resultFolder);
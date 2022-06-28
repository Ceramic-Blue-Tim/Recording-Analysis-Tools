function varargout=determineStimulatingElectrodes(varargin)

text=importdata(varargin{1},'');       
str=text{2};
str(strfind(str,'-'))=',';
semicolonPos=strfind(str,';');
underscorePos=strfind(str,'_');
stimCh1=str2num(str(1:semicolonPos(1)-1)); %#ok<ST2NM>
stimCh2=str2num(str(underscorePos(1)+1:semicolonPos(2)-1)); %#ok<ST2NM>
switch nargout
    case 1
        stimCh{1}=stimCh1;
        stimCh{2}=stimCh2;
        varargout{1}=stimCh;
    case 2
        varargout{1}=stimCh1;
        varargout{2}=stimCh2;
end

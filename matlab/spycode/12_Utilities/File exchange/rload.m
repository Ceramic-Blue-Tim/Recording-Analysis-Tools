function rload(arg,ws)
% RLOAD: Regexp Load
% RLOAD loads files matching an input regexp(pathnames are allowed). 
%    When using the functional form, the regexp must be entered in single
%    quotes. Variables are entered into the workspace WS which can be one 
%    of 'caller'(default) or 'base'. 
%
%  Files causing an error on loading are skipped.
%
%  Examples: 
%   rload a*.dat
%     loads all files beginning with the letter 'a' and ending in '.dat'
%   rload('a*.dat b*.mat') 
%     is equivalent to rload('a*.dat'); rload('b*.mat'). 
%
%  RLOAD works only on UNIX at present
%
%  Prabhu Valiveti   prabhu@cheme.cornell.edu  5 May 1998  Version 1.0

if(nargin==0) 
  disp(sprintf('\nUsage: rload <pattern>\n'));
  return;
end


if(nargin==1)
  ws='caller';
end

if isunix
  [junk,files]=unix(['ls ' ,arg]); 
else
  disp(sprintf('Sorry! RLOAD does not work under non-UNIX systems yet!\n'));
  return;
end

delim=sprintf('\n'); file=strtok(files,delim); 
while(~isempty(file))

  if(~isempty(findstr(file,'not found'))) 
    disp(sprintf('File %s',file));
  else 
    err_str='disp(sprintf(''%s\n \t\t... Skipping %s'',lasterr,file));';
    evalin(ws,['load(''',file, ''')'],err_str);
  end

  files=strrep(files,file,'');
  file=strtok(files,delim);
end 

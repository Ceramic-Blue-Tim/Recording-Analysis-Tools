function show = writeascii(outfile,data,dataformat,outperm)
%show = writeascii(outfile,data,dataformat,outperm)
%   Saves vector, matrix (up to 3 dimensions), string, 
%       or cell array data into an ascii file
%
% INPUT ARGUMENTS
%   outfile = Name of out-file
%       default 'data.asc'
%
%   data = Vector, matrix (up to 3 dimensions), string, 
%       or cell array data
%
%   dataformat = format used for all columns of numeric data
%           e.g.  '%5.6f   ', ' %2g\t'
%           default is calculated using the highest decimal or
%               used in each column of data or 8 which ever is lower
%               if the data is a string, '%s' is used as the format
%       or delimiter to be used between columns
%           e.g.  '  ', '\t'
%           default ' '
%
%   outperm = Permision for out-file used with fopen
%       e.g. 'a', 'w+'
%       default 'w'
%   
% OUTPUT ARGUMENTS
%   show = string saying the name of the out-file and
%       where it was saved
%
% USAGE
%   writeascii(data)
%   writeascii(outfile,data)
%   writeascii(outfile,data,dataformat)
%   writeascii(outfile,data,dataformat,outperm)
%
% EXAMPLES:
%   s=writeascii('trash.asc',magic(15),'%4.0f ')
%
%   d{1,1}=strvcat(' ','This is an example',...
%       'First set of data');
%   d{2,1}=magic(15);
%   d{1,2}=strvcat('Second set of data');
%   d{2,2}=100*rand(5,7);
%   d{1,3}=strvcat('Third set of data');
%   d{2,3}=rand(3,5);
%   s=writeascii('trash2.asc',d,'%4.2f ')
%
%   s=writeascii('trash3.asc',rand(3,5,6),'%3.2f ')
%
%Alejandro Sanchez Barba, 7/8/2004

if nargin==1
    data=outfile; 
    outfile='data.asc';
end %if
if ~exist('outperm')
    outperm='w'; 
end %if

fid=fopen(outfile,outperm);

if ~iscell(data)
    data={data};
end

N=prod(size(data));

if exist('dataformat')
    if isempty(findstr('%',dataformat))
        d=dataformat;
        dataformat=[];
    end
else
    dataformat=[];
    d=' ';
end

for c=1:N
    [m,n,p]=size(data{c});
    if ~isstr(data{c})
        if isempty(dataformat)
            fileformat=getformat(data{c},d);
        else
            fileformat=dataformat;
            nf=length(findstr('.',dataformat));
            if nf==1              
                for k=2:n
                    fileformat=[fileformat, dataformat];
                end %for k
            end
            if isempty(findstr('\n',fileformat))
                fileformat=[fileformat,' \n'];
            end
        end %if   
    else
        fileformat='%s \n';
    end
    
    for b=1:p
        for k=1:m
            fprintf(fid,fileformat,data{c}(k,:,b));
        end %for k
        fprintf(fid,'\n');
    end %for b
end %for c

fclose(fid);
[pathstr,name,ext]=fileparts(outfile);
if isempty(pathstr)
    pathstr=cd;
end
show=sprintf(['%s saved in: \n%s \n',...
        'with format: \n%s'],...
    [name,ext],pathstr,fileformat);


%------------------------------------------

function [f,dig,dec]=getformat(x,d,m)
%[f,dig,dec]=getformat(x)
%   Obtains the format   
%   for the data array x
%   and gives the format using
%   the delimeter d 
%   default ' ', e.g. '\t'
%   and also returns the maximum
%   number of digits and decimals 
%   per column
%   m is the maximum number of 
%   decimals
%
%Alejandro Sanchez, 3/10/2004

if nargin<2
    d=' ';
end
if nargin<3
    m=7;
end

[r,c]=size(x);
f=[];

%It uses only the first hundred rows
%or the number of rows whichever is 
%smaller to make it much faster
nr = min(size(x,1),100);

for k=1:c
    r=all(x(1:nr,k)/10 < 1);
    n=1;
    while r==0 
        n=n+1;
        r=all(x(1:nr,k)/10^n<1);
    end
    dig(k)=n;
    
    g=round(x(1:nr,k)*10^m)/10^m;
    for n=m-1:-1:0
        s=round(x(1:nr,k)*10^n)/10^n;
        if any(any(g~=s))
            break
        end
        g=s;
    end      
    dec(k)=n;
    
    f=[f,'%',num2str(dig(k)),'.',num2str(dec(k)),'f',d];
    
end

f=[f,'\n'];


return

%===================================================

s=writeascii('trash.asc',magic(15),'%4.0f ')

d{1,1}=strvcat(' ','This is an example',...
      'First set of data');
d{2,1}=magic(15);
d{1,2}=strvcat('Second set of data');
d{2,2}=100*rand(5,7);
d{1,3}=strvcat('Third set of data');
d{2,3}=rand(3,5);
s=writeascii('trash2.asc',d,'%4.2f ')

s=writeascii('trash3.asc',rand(3,5,6),'%3.2f ')
function [] = save_ascii(loadname,savename,dataformat,delineator);
% Saves current variables in a delineated ASCII file:
% variable names 1st, horizontally, with data for each below the name.
%  
% Usage/Input:  save_ascii(loadname,savename,dataformat,delineator);
%     where, 
%     -"loadname" = filename of the *.mat file to save as ASCII
%     -"savename" = filename to save this text output to
%     -"dataformat" = format of 'double array' data (e.g. '%6f' for
%     six digit fixed-point notation)
%     -"delineator" = what to delineate data blocks with (e.g. '\t' for tab)
%
% eg. save_ascii('data.mat','textfile.txt','%6f','\t');
%
% Limitations:  This script can only handle two data types: 'char' and
% 'double', where the 'char' types can only be one dimensional
% (e.g. size = 1X15), and the 'double array's can be one or two dimensional
% (e.g. sizes = 52X1, 1X52, or 30X344).
%
% Notes:  Since this saves the matrices as they exist, I suggest keeping one
% dimensional arrays in columnar form, so they get saved that way.  For
% example, ensure the size is 52X1, not 1X52, as the latter will get saved
% as a row of data, not as a column (this doesn't apply to char arrays).
%
%         Loops within loops, whew.  Perhaps this isn't the most elegant way
% to do this, but it works.  It can be quite time consuming on even
% moderately sized files.  Also expect a large change in size as this file
% changes from binary to ASCII.
%
% The 'loadname' file cannot contain the following variables:
% bl, c, dataformat, delineator, fid, i, j, loadname, perdone, r,
% savename, & vrbls
%
% Variables will be saved in alphabetical order; the same order as they
% appear with the command 'whos'.
%
% Output: Text file of name input as 'savename'.
%
% eg.:
%
%» load data.mat
%» whos
%  Name              Size         Bytes  Class
%
%  box               2x2             32  double array
%  col               4x1             32  double array
%  row               1x4             32  double array
%  text              1x4              8  char array
%
%» save_ascii('data.mat','textfile.txt','%6f','\t');
%
% Then, if open 'textfile.txt' in a spreadsheet:
%
% | box |     | col | row |     |     |     | text |
% |  1  |  2  |  1  |  1  |  2  |  3  |  4  | test |
% |  3  |  4  |  2  |     |     |     |     |      |
% |     |     |  3  |     |     |     |     |      |
% |     |     |  4  |     |     |     |     |      |
%
% see also: save

% Author: Kirk Ireson, 28 Feb 1999 (kireson@ucsd.edu)
%
% Tested on Matlab v. 5.2.0.3084 
%
% Copyright (c) Kirk Ireson,
%               Marine Life Research Group,
%               Scripps Institution of Oceanography,
%               University of California, San Diego
% 
% Permission is granted to modify and re-distribute this
% code in any manner as long as this notice is preserved.
% All standard disclaimers apply.
%
% Please notify me if you find this script useful, it's nice to get
% feedback!
% 

load (loadname);
vrbls = whos; %variables to save

%--------
%Eliminate 'loadname', 'savename', 'dataformat', & 'delineator' from 'vrbls'
%--------

i = 1;
while i <= size(vrbls,1); %'vrbls' is shrinking, indexing larger than it, then break
   if strcmp('loadname',vrbls(i).name) == 1 |... %variable names we don't want
         strcmp('savename',vrbls(i).name) == 1 |...
         strcmp('dataformat',vrbls(i).name) == 1 |...
         strcmp('delineator',vrbls(i).name) == 1;
      if i == 1; %1st vrbl
         vrbls = vrbls(i+1:size(vrbls,1));
      elseif i == size(vrbls,1); %last vrbl
         vrbls = vrbls(1:i-1);
      else %all other cases
         vrbls = [vrbls(1:i-1);vrbls(i+1:size(vrbls,1))];
      end
   else %a variable we want to keep
      i = i + 1;
   end
end

fid = fopen(savename, 'w'); %open file

% ---------------------
% SAVING VARIABLE NAMES (top row in file)
% ---------------------

for i = 1:size(vrbls,1); %run loop for each variable
   fprintf(fid,['%s',delineator],vrbls(i).name); %save variable name and a tab character 
   if size(vrbls(i).class,2) ~= 4; %don't do loop for 'char' arrays
      if vrbls(i).size(2) > 1; %add extra tabs for 2d matrices
         for c = 1:vrbls(i).size(2) - 1;
            fprintf(fid,delineator);
         end
      end
   end
end

% ---------------------
% SAVING DATA (rows 2 through max number of rows)
% ---------------------

j = 0; %max number of rows
for i = 1:size(vrbls,1); %run loop for each variable
   if vrbls(i).size(1) > j;
      j = vrbls(i).size(1); %get largest size of rows
   end
end

perdone = 0;
disp('Percent finished:');
for r = 1:j; %run loop for maximum rows
   if floor(r/j*10) > perdone; %calculating percent done in 10% blocks
      perdone = floor(r/j*10);
      fprintf([num2str(perdone*10),', ']); %display percent done
   end
   fprintf(fid,'\r'); %start new record line
   for i = 1:size(vrbls,1); %run loop for each variable
      if vrbls(i).size(1) < r;
         %variable is smaller than current row, fill with tabs across
         if strcmp('char',vrbls(i).class); %a 'char' array
            fprintf(fid,delineator);
         else %a 'double' array
            for bl = 1:vrbls(i).size(2);
               %fill with tabs across, for size of columns of this variable
               fprintf(fid,delineator);
            end
         end
      else %variable has >=r rows of data
         if size(vrbls(i).class,2) == 4; %a 'char' array
            fprintf(fid,['%s',delineator],eval(vrbls(i).name));
            %save char string
         else %a 'double' array
            for c = 1:vrbls(i).size(2); %process each column for each variable
               fprintf(fid,[dataformat,delineator],eval([(vrbls(i).name),'(',num2str(r),',',num2str(c),')']));
               %save data and a tab character
            end
         end
      end
   end
end

fclose(fid); %close file
disp('Done');
   
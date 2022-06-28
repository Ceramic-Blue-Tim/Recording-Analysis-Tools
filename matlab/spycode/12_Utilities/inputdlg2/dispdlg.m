function ipFig=dispdlg( cellItems, figId, Mode )
%dispdlg   Generates a scrolled window for displaying data.
%   dispdlg(Data) displays the Data (text or matrix) in a window.
%   Data may be a cell array containing:
%        a string cell vector of row titles (optional)
%        a string cell vector of column titles (optional)
%        a string cell array of strings/numbers
%   Data may be just a string/numeric array
%   Data may be a structure of the form produced by sim.
%
%   dispdlg(Data, Title) where:
%   Title is a string title for the window. NB don't use ' - Locked' or
%        ' - Unlocked' in Title.
%
%   dispdlg(Data, Title, Lock) where:
%   Lock is whether to allow a subsequent dispdlg call with the
%        same title to use this figure window (default is 0 which 
%        allows replacement). The Edit menu can be used to change it.
%
%   dispdlg([], Title, Lock)
%   Sets the Lock state for the figure named Title; 0 allows replacement.
%
%   h=dispdlg(...)
%   Returns the handle of the display figure.
%
%   dispdlg displays the Data in a figure window with name 
%        Title and whether Locked. If it finds another window with this
%        name which is unlocked it will enter the Data in the first one 
%        found, otherwise it will create a new one.
%        The menu can be used later to change the Lock setting.
%
%   For example:
%        dispdlg({{'dispdlg displays:';'   matrices';'   strings';'   cells';'   structures'}},'Hint',1);
%
%        i={'x1';'x2';'u1';'u2'}';
%        o={'xdot1';'xdot2';'y1';'y2';'y3';'y4'};
%        m=[-0.45,0.34,0.32,0.43;...
%           0.25,-0.85,0.82,0.74;...
%           0.75,1.34,0.39,0.43;...
%           0.74,0.85,0.72,0.37;...
%           0.47,1.84,0.37,0.95;...
%           0.45,0.14,1.32,0.92];
%        dispdlg({o,i,m},'Linearised Model Matrix');
%
%        [t,x,y]=sim('countersdemo');
%        nl=char(10);
%        names={['Control' nl 'Sig'];['Enabled' nl 'Count'];['Triggered' nl 'Count']}';
%        dispdlg({t,names,y},'Countersdemo Result');
%
%        %[y]=sim('countersdemo',[],simset('SaveFormat','StructureWithTime'));  %doesn't work
%        countersdemo
%        %Alter the model Save Format to 'StructureWithTime'
%        %using the Simulation Parameters menu, Workspace I/O 
%        %Execute the model from the Simulation menu
%        dispdlg(yout,'Countersdemo Result');
%
%   See also: DISP, inputdlg2, MENU, selectdlg3, listdlg2.

%   Author: Mike Thomson   6 August 2001 

%------------------------------------------------------------------------
% Set spacing and sizing constants for the GUI layout
%-------------------------------------------------------------------------
dlgUnits  = 'points'; % units used for all objects
dlgColor   = [0.8,0.8,0.8];
bgColor  = [0.95,0.95,0.95];
bakColor  = [0.99,0.99,0.99];

%Window positioning
winTopGap   = 45;       % gap between top of screen and top of figure **
winSideGap  = 40;       % gap between side of screen and side of figure **

% ** figure function 'Position' parameter sets "available" area. You must 
% allow space around it for the whole window size - the OS adds
% a title bar (aprx 42 points on Mac and Windows) and a window border
% (usu 2-6 points). Otherwise user cannot move the window.
% Also you may be prevented from setting bottom below 26 points.
% 800, 600 pixels -> 600, 450 points.

%Gaps
pane1Gap=2;
textPad = [0,0,9,2];   % extra [0,0,Width,Height] on uicontrols to pad text

%Extras
scrollWide  = 12;       % 

%=========================================================================
% PERFORM CALLBACK ACTION
%=========================================================================
if isempty(cellItems)
   error(nargchk(3,3,nargin));
   hide=get(0,'showhiddenhandles');
   set(0,'showhiddenhandles','on');
   if Mode,
      ipFig=findobj('Parent',0,'Name',[figId ' - Unlocked']);
   else
      ipFig=findobj('Parent',0,'Name',[figId ' - Locked']);
   end
   % Put the hidden handles setting back
   set(0,'showhiddenhandles',hide);
   if ~isempty(ipFig),
      ipFig=ipFig(1);                 % there may be more than one
      hData=get(figId, 'Userdata');   % Get handle data
      dispdlg('dispDlg_lock',ipFig,hData.Lock); 
   else
      return;
   end;
elseif ischar(cellItems)
   fragName=cellItems;
else
   fragName='none';
end;

switch fragName
   
case 'dispDlg_lock'
   name=get(figId,'Name');
   i=findstr(name,' - Locked');
   if isempty(i),
      set(Mode,'Label','Unlock');
      set(figId,'Name',[name(1:length(name)-11),' - Locked']);
   else
      set(Mode,'Label','Lock');
      set(figId,'Name',[name(1:i-1),' - Unlocked']);
   end;
   
case 'dispDlg_figResize'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   %get figure size
   figPos = get(figId,'Position');
   
   % Get panel size data
   PnS=get(hData.FrameBox,'Userdata'); % [panelWide;panelHigh;pnlRTWide;pnlCTHigh]
   
   % Check min size
   minWide = 50 + PnS(3);
   minHigh = 50 + PnS(4);
   
   if figPos(3)<minWide,
      winWide = minWide;
   else
      winWide = figPos(3);
   end; %if
   
   if figPos(4)<minHigh,
      winHigh = minHigh;
   else
      winHigh = figPos(4);
   end; %if
   
   % Check if top is off the screen
   oldUnits = get(0,'Units');         % remember old units
   set( 0, 'Units', dlgUnits );       % convert to desired units
   screenSize = get(0,'ScreenSize');  % record screensize
   set( 0, 'Units',  oldUnits );      % convert back to old units
   
   if screenSize(4)-winTopGap < figPos(2)+winHigh,
      figPos(2)=screenSize(4)-winTopGap-winHigh;
   end;
   
   set(figId, 'Position', [figPos(1), figPos(2), winWide, winHigh]);
   
   % Set pwFrame positions
   pc{1}=[0, 0, PnS(3), winHigh];
   pc{2}=[0, winHigh-PnS(4), winWide, PnS(4)];
   set( hData.PwFrame, {'Position'}, pc' );

   % Set Scroll positions - use h & v to indicate slider present
   viewPos=[PnS(3), 0, winWide-PnS(3), winHigh-PnS(4)];
   h=0;v=0;
   if PnS(1)>viewPos(3),
      h=scrollWide;
   end;
   if PnS(2)>viewPos(4)-h,
      v=scrollWide;
      set( hData.Scroll(2), 'Visible','on' );
   else
      set( hData.Scroll(2), 'Visible','off' );
   end;
   if PnS(1)>viewPos(3)-v,
      set( hData.Scroll(1), 'Visible','on' );
      h=scrollWide;
   else
      set( hData.Scroll(1), 'Visible','off' );
   end;
   set( hData.Scroll(1), 'Position', [viewPos(1:2), viewPos(3)-v, scrollWide] );
   set( hData.Scroll(2), 'Position', [viewPos(1)+viewPos(3)-scrollWide, viewPos(2)+h, scrollWide, viewPos(4)-h] );

   % Set Scroll parameter values 
   hStp=1;vStp=1;
   hSliMx=PnS(1)-viewPos(3)+v;    % slider value at rhs
   if hSliMx<=0, hSliMx=1; end;
   vSliMx=PnS(2)-viewPos(4)+h;    % slider value at top
   if vSliMx<=0, vSliMx=1; end;
   if (PnS(1)-viewPos(3)+v)>0,
      hStp=(viewPos(3)-v)/(PnS(1)-viewPos(3)+v); % sets slider knob size
   end;
   if hStp<=0, hStp=1; end;
   if (PnS(2)-viewPos(4)+h) > 0,
      vStp=(viewPos(4)-h)/(PnS(2)-viewPos(4)+h); % sets slider knob size
   end;
   if vStp<=0, vStp=1; end;
   set( hData.Scroll(1), 'Max',hSliMx, 'SliderStep',[min(0.1*hStp,1) hStp], 'Value',0);
   set( hData.Scroll(2), 'Max',vSliMx, 'SliderStep',[min(0.1*vStp,1) vStp], 'Value',vSliMx);
   set( hData.Scroll(3), 'Position', [viewPos(1)+viewPos(3)-scrollWide, viewPos(2), scrollWide, scrollWide] );
   if h&v,
      set( hData.Scroll(3), 'Visible','on' );
   else
      set( hData.Scroll(3), 'Visible','off' );
   end;
   
   % Set Box position
   set(hData.FrameBox,'Position',viewPos);
   
   % Set TitFrame positions
   clear pc; % reset size
   pc{1}=[0, 0, PnS(3), 1+h];
   pc{2}=[0, viewPos(2)+viewPos(4), PnS(3), PnS(4)];
   pc{3}=[viewPos(1)+viewPos(3)-v, viewPos(2)+viewPos(4), 1+v, PnS(4)];
   set( hData.TitFrame, {'Position'}, pc' );
   
   % Reset the objects positions
   dispdlg('dispDlg_scroll',figId);
   
case 'dispDlg_scroll'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   % Get panel data
   PnS=get(hData.FrameBox,'Userdata'); % [panelWide;panelHigh;pnlRTWide;pnlCTHigh]
   SlP=get(hData.Scroll(2),'Position'); % for panel positioning

   % Get object positions wrt fig & wrt panel
   ObjPos=hData.Panel.oPos;
   
   % Get both scroll values
   sclH=get(hData.Scroll(1), 'Value');
   sclV=get(hData.Scroll(2), 'Value');
   
   % Set panel offsets
   pnlOff=[PnS(3) max(SlP(2),SlP(2)+SlP(4)-PnS(2))];
   
   % Set Object positions
   pos=num2cell( [ObjPos + [ones(size(ObjPos,1),1)*[pnlOff(1)-sclH,pnlOff(2)-sclV] zeros(size(ObjPos,1),2)] ] ,2);
   set( hData.Panel.Object, {'Position'}, pos );
   
   % Get title positions wrt fig &  wrt panel & Set Title positions
   if ~isempty(hData.Panel.RTitle),
      RTPos=hData.Panel.rtPos;
      pos=[RTPos + [ones(size(RTPos,1),1)*[0,pnlOff(2)-sclV] zeros(size(RTPos,1),2)] ];
      set( hData.Panel.RTitle, 'Position', pos );
   end;
   if ~isempty(hData.Panel.CTitle),
      CTPos=hData.Panel.ctPos;
      pos=[CTPos + [ones(size(CTPos,1),1)*[pnlOff(1)-sclH,(SlP(2)+SlP(4))] zeros(size(CTPos,1),2)] ];
      set( hData.Panel.CTitle, 'Position', pos );
   end;

case 'dispDlg_CnlClick'
   % Just delete the figure
   delete(gcbf);
   
otherwise
   
%=========================================================================
% INPUT PARAMETER CHECKS
%=========================================================================
% Check parameter list
%-------------------------------------------------------------------------
error(nargchk(1,3,nargin));

%-------------------------------------------------------------------------
% Set defaults
%-------------------------------------------------------------------------
if nargin<2,
   figId=['Display(' inputname(1) ')'];
end;
if nargin<3,
   Mode=0;
end;

%-------------------------------------------------------------------------
% Check TEXT sizes & types
%-------------------------------------------------------------------------
[r,c]=size(cellItems);
% Dismantle the input structure
% -----------------------------
if isstruct(cellItems),
   % Is it a simulation result?
   stField=fieldnames(cellItems);
   if length(cellItems)==1 & length(stField)==2 & strcmp(stField{1},'time') & ...
        strcmp(stField{2},'signals') & isnumeric(cellItems.time) & isstruct(cellItems.signals),
       % Manage the input assuming this is as produced by sim
       j=0;
       theText=[];
       rowTitle=cellItems.time;
       % Get the data for each output port
       for i=1:length(cellItems.signals), 
          cells=struct2cell(cellItems.signals(i));  % Convert to cells
          if ~isempty(cells{3}),
             colTitle{i+j}=cells{3};  % Is there a label
          else
             colTitle{i+j}=cells{4};  % else use the block name
          end;
          % Trouble is: some output ports are vectored, so repeat: name(n)
          if cells{2}>1,
             str=[colTitle{i+j} '('];
             chr=[char(ones(cells{2},1)*str) num2str([1:cells{2}]') char(ones(1*cells{2},1)*41)];
             [colTitle([i+j:i+j+cells{2}-1])]=deal(reshape(cellstr(chr),1,cells{2}));
             j=j+cells{2}-1;
          end
          theText=[theText,cells{1}]; % Gather the data in columns
       end
   elseif length(cellItems)==1,
      % General structure
      rowTitle=stField;
      % First check if 1st element is a struct & if all are stucts with the same fields
      fstCellItems=getfield(cellItems,stField{1});
      if isstruct(fstCellItems),
         namSubField=fieldnames(fstCellItems);
         strSubField=strvcat(namSubField{:});
         fSame=zeros(length(stField),1);
         for i=1:length(stField),
            fldCellItems=getfield(cellItems,stField{i});
            if isstruct(fldCellItems),
               tmpSubField=fieldnames(fldCellItems);
               if strcmp(strSubField,strvcat(tmpSubField{:})),
                  fSame(i)=1;
               end
            end
         end
      else
         fSame=0;
      end
      
      % If all sub-struct fields the same, put primary fields down rows & sec fields along cols
      if all(fSame),
          colTitle=namSubField';
          cColSize=length(colTitle);
          for i=1:length(stField),
             tmpField=getfield(cellItems,stField{i});
             for j=1:cColSize,
                theText{i,j}=var2str(getfield(tmpField,colTitle{j}));
             end
          end
       else
      % Else structure has varied contents - just list them
          for i=1:length(stField),
             theText{i,1}=var2str(getfield(cellItems,stField{i}));
          end
       end
      
   else
   % If a structure array just state its size
      theText={var2str(cellItems)};
   end
   
% Deal with numeric or string input
% ---------------------------------
elseif ~iscell(cellItems) & isnumeric(cellItems),
   theText=cellItems; % no titles
elseif ~iscell(cellItems) & ~isnumeric(cellItems),
   theText={cellItems}; % no titles
   
% Dismantle the input cell array
% ------------------------------
elseif r~=1 & c~=1,
   if ~iscell(cellItems{1,1}),
      %no rownames
      %no colnames
      theText=cellItems;   % just win data in a cell, no titles
   else
      % A cell matrix of cells is too complex
      error('Data cannot be a cell matrix of cells - maybe too many {}.');
   end;
elseif length(cellItems)==1,
   [r,c]=size(cellItems{1}); % cell contains a single cell
   %no rownames
   %no colnames
   theText=cellItems{1}; % only text items supplied
elseif length(cellItems)==2,
   [r1,c1]=size(cellItems{1});
   [r2,c2]=size(cellItems{2});
   theText=cellItems{2}; % text items supplied 2nd
   if size(cellItems{1},2)==c2,
      %no rownames
      colTitle=cellItems{1}; colTitle=colTitle(:)'; % title vector matches columns
   elseif size(cellItems{1},1)==r2,
      rowTitle=cellItems{1}; rowTitle=rowTitle(:); % title vector matches rows
      %no colnames
   else
      error('The first cell in Data is the wrong size.');
   end;
elseif length(cellItems)==3,
   theText=cellItems{3};     % all items supplied
   [r,c]=size(cellItems{3});
   rowTitle=cellItems{1};
   colTitle=cellItems{2};
   if size(rowTitle,1)~=r | size(colTitle,2)~=c,
      error('A title in Data is the wrong size.');
   end;
else
   error('Data is the wrong size.');
end;

% Now we have theText, rowTitle (if given), colTitle (if given)
% They may be of various types

% But the cells above may contain c(10)|c(13) - must search char types
% & fit each row

% Format the data - all a bit shoddy...Need to handle cell rows with different 
%     numbers of string rows
[tRowSize,tColSize]=size(theText);
if isnumeric(theText),
   theText=reshape(cellstr(num2str(theText(:))),tRowSize,tColSize);
else
   for i=1:tRowSize*tColSize,
      theText{i}=strsplit(theText{i});
   end
end
allCells=theText;
fill={};
if exist('rowTitle'), 
   [rRowSize,rColSize]=size(rowTitle);
	if isnumeric(rowTitle),
       rowTitle=reshape(cellstr(num2str(rowTitle(:))),rRowSize,1);
	else
       for i=1:rRowSize,
          rowTitle{i}=strsplit(rowTitle{i});
       end
	end
   allCells=[rowTitle,allCells];
   fill={' '}; 
else
   rRowSize=tRowSize; rColSize=0;
end;
if exist('colTitle'), 
   [cRowSize,cColSize]=size(colTitle);
	if isnumeric(colTitle),
       colTitle=reshape(cellstr(num2str(colTitle(:))),1,cColSize);
	else
       for i=1:cColSize,
          colTitle{i}=strsplit(colTitle{i});
       end
	end
   allCells=[[fill,colTitle];allCells]; 
else
   cRowSize=0; cColSize=tColSize;
end;
[r,c]=size(allCells);
%check all cells in a cellrow have the same no of rows
for i=1:r,
   cellrows=max(sizes(allCells(i,:),1));
   allCells(i,:)=cellpad(allCells(i,:),cellrows);
   if cColSize>0 & i==1, 
      cRowSize=cRowSize+cellrows-1;
   else
      tRowSize=tRowSize+cellrows-1;
   end
end
allText=[];
for i=1:c,
   theCol=strvcat(allCells(:,i));
   allText=[allText,theCol,ones(size(theCol,1),2)*char(32)]; % add 2 spaces
   colSize(i)=size(theCol,2)+2;
end
%allText=(reshape(allText,r+cellrows-1,c*colSize));
[textRow,textCol]=size(allText);
if exist('rowTitle'),
   rowText=allText((cRowSize+1):end,1:sum(colSize(1:rColSize)));
end;
if exist('colTitle'),
   colText=allText(1:cRowSize,sum(colSize(1:rColSize))+1:end);
end;
theText=allText((cRowSize+1):end,sum(colSize(1:rColSize))+1:end);

%-------------------------------------------------------------------------
% Check MODE size
%-------------------------------------------------------------------------
if ~isnumeric(Mode),
   error('Lock must be numeric');
end;
if Mode,
   figLock=' - Locked';
   mnuLock='Unlock';
else
   figLock=' - Unlocked';
   mnuLock='Lock';
end;

%=========================================================================
% BUILD THE GUI
%=========================================================================
% Find any unlocked disp dialogs with same name
%------------------------------------------------------------------------
hide=get(0,'showhiddenhandles');
set(0,'showhiddenhandles','on');
ipFig=findobj('Parent',0,'Name',[figId ' - Unlocked']);
if ~isempty(ipFig), ipFig=ipFig(1); end; % there may be more than one

if isempty(ipFig);
%------------------------------------------------------------------------
% Create a generically-sized invisible figure window
%------------------------------------------------------------------------
   ipFig = figure('Units'        ,dlgUnits, ...
               'NumberTitle'  ,'off', ...
               'IntegerHandle','off', ...
               'Name'         ,[figId figLock], ...
               'PaperPositionMode','auto',...
               'Visible'      ,'off', ...
               'Colormap'     ,[]);
   % Remove menu items that don't apply
   delete(findobj(ipFig,'Type','uimenu','Label','&Tools'));
   editObj=findobj(ipFig,'Type','uimenu','Label','&Edit');
   delObj=findobj('Parent',editObj,'Type','uimenu');
   delete(delObj(3:8)); % remove undo,cut,copy,paste,clear,select
   hLock=uimenu('Parent',editObj,'Position',1,'Label',mnuLock,'Callback','dispdlg(''dispDlg_lock'',gcbf,gcbo);');
else
   % Delete all disp dialog contents - not menu
   hData=get(ipFig,'Userdata');
   hLock=hData.Lock;
   delete(hData.FrameBox);
   delete(hData.Panel.Object);
   if ~isempty(hData.Panel.RTitle), delete(hData.Panel.RTitle); end;
   if ~isempty(hData.Panel.CTitle), delete(hData.Panel.CTitle); end;
   delete(hData.PwFrame);
   delete(hData.TitFrame);
   delete(hData.Scroll);
   
   % Set any new figure details - change to lock
   set(ipFig,'Name',[figId figLock],'Visible','off');
   
   % Get existing figure position
   figPos=get(ipFig,'Position');
end;

% Put the hidden handles setting back
set(0,'showhiddenhandles',hide);

%------------------------------------------------------------------------
% Add contents of the scrolled panel 
%------------------------------------------------------------------------
% Note that these will be moved later on.

% Make the text in the panel - position wrt panel in the UserData
hText = uicontrol( ...
            'Parent'    ,ipFig,...
            'Style'     ,'text',...
            'Units'     ,dlgUnits, ...
            'FontName'  ,'FixedWidth',...
            'Background',bakColor,...
            'Horizontal','left',...
            'String'    ,theText );

% Store the contents object handles in a structure
hPanel.Object=hText;

%------------------------------------------------------------------------
% Add the scroll sliders
%------------------------------------------------------------------------
% Note that these will be sized & moved later on.

hScrollH = uicontrol(...
         'Parent',ipFig,...
         'Style','slider',...
         'Units',dlgUnits, ...
         'Min',0,'Max',1 ,...
         'Value',0 , ...
         'Callback','dispdlg(''dispDlg_scroll'',gcbf);',...
         'SliderStep',[0.1 1]);

hScrollV = uicontrol(...
         'Parent',ipFig,...
         'Style','slider',...
         'Units',dlgUnits, ...
         'Min',0,'Max',1 ,...
         'Value',0 , ...
         'Callback','dispdlg(''dispDlg_scroll'',gcbf);',...
         'SliderStep',[0.1 1]);
      
h2Scrolls = uicontrol('Parent',ipFig,'Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % if both frames - bot right

%------------------------------------------------------------------------
% Add the panelWindow surround frames
%------------------------------------------------------------------------
hPwFrame(1) = uicontrol('Parent',ipFig,'Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To frame left text
hPwFrame(2) = uicontrol('Parent',ipFig,'Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To frame top text

%------------------------------------------------------------------------
% Add the panel title objects
%------------------------------------------------------------------------
% Note that these will be moved later on.
% Make the titles around the panel
if exist('rowTitle'),
   hTitleRow = uicontrol( 'Parent',ipFig,...
        'Style'       ,'text', ...
        'String'      ,rowText, ...
        'Units'       ,dlgUnits, ...
        'FontName'    ,'FixedWidth',...
        'Horizontal'  ,'left',...
        'Background'  ,bakColor );
end;

if exist('colTitle'),
   hTitleCol = uicontrol( 'Parent',ipFig,...
        'Style'       ,'text', ...
        'String'      ,colText, ...
        'Units'       ,dlgUnits, ...
        'FontName'    ,'FixedWidth',...
        'Horizontal'  ,'left',...
        'Background'  ,bakColor );
end;

%------------------------------------------------------------------------
% Do full size check for objects & titles
%------------------------------------------------------------------------
%  & set panel titles' & objects' Userdata here
% Object size
oTexts = get( hText, 'Extent' );
oWides = oTexts(3);
oHighs = oTexts(4);
oMaxWide = oWides+ textPad(3);  % calculate the largest width & height
oMaxHigh = oHighs+ textPad(4);  % add some blank space around text

% Row Title size - if there
if exist('rowTitle')==1,
   rtTexts = get( hTitleRow, 'Extent' ); % get ext
   rtWide = rtTexts(3)+ textPad(3);      % one width for all
   rtHigh = rtTexts(4) + textPad(4);     % height for all
   oMaxHigh = max(oMaxHigh, rtHigh);     % stretch obj if titles large
else
   rtWide=1;
end; %if

% Col Title size - if there
if exist('colTitle')==1,
   ctTexts = get( hTitleCol, 'Extent' ); % get ext
   ctHigh = ctTexts(4)+ textPad(4);      % one height for all
   ctWide = ctTexts(3) + textPad(3);     % width for all
   oMaxWide = max(ctWide,oMaxWide);      % stretch obj if titles large
else
   ctHigh=1;
end; %if

% Object Positions - rearrange into a position vector & store in structure
hPanel.oPos=[pane1Gap,pane1Gap,oMaxWide,oMaxHigh];

% Title Positions
if exist('rowTitle')==1,
   % Store panel title pos & size in structure
   hPanel.rtPos=[pane1Gap,pane1Gap,rtWide,oMaxHigh];     
   % Store the title object handles in a structure
   hPanel.RTitle=hTitleRow;
else
   hPanel.rtPos=[];
   hPanel.RTitle=[];
end;
if exist('colTitle')==1,
   % Store panel title size & pos in structure
   hPanel.ctPos=[pane1Gap,pane1Gap,oMaxWide,ctHigh];     
   % Store the title object handles in a structure
   hPanel.CTitle=hTitleCol;
else
   hPanel.ctPos=[];
   hPanel.CTitle=[];
end;

% Set panel size for objects & Titles
panelWide=oMaxWide+2*pane1Gap;
panelHigh=oMaxHigh+2*pane1Gap;
pnlRTWide=rtWide+2*pane1Gap;
pnlCTHigh=ctHigh+2*pane1Gap;

%------------------------------------------------------------------------
% Add the panel title end frames
%------------------------------------------------------------------------
hFrameBox=axes(  'Parent',ipFig,...
               'Units'   ,'points',...
               'XLimMode','manual',...
           'XLim',[0,100],'XTick',[],...
           'YLim',[0,100],'YTick',[],...
                  'Color',bgColor,...
             'Userdata'  ,[panelWide,panelHigh,pnlRTWide,pnlCTHigh]);
hBox=rectangle('Parent',hFrameBox,'Position',[0,0,100,100]);
hTitFrame(1) = uicontrol('Parent',ipFig,'Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To cover bottom left
hTitFrame(2) = uicontrol('Parent',ipFig,'Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To frame top left
hTitFrame(3) = uicontrol('Parent',ipFig,'Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To frame top right

%------------------------------------------------------------------------
% Store all handles in a structure in the figure Userdata for retrieval
%------------------------------------------------------------------------
hData.Lock=hLock;
hData.FrameBox=hFrameBox;
hData.Box=hBox;
hData.Panel=hPanel;
hData.PwFrame=hPwFrame;
hData.TitFrame=hTitFrame;
hData.Scroll=[hScrollH,hScrollV,h2Scrolls];
set(ipFig, 'Userdata', hData);

%------------------------------------------------------------------------
% Set callbacks for figure close & resize
%------------------------------------------------------------------------ 
set(ipFig, 'CloseRequestFcn' ,['dispdlg(''dispDlg_CnlClick'');'],...
           'ResizeFcn'       ,['dispdlg(''dispDlg_figResize'',gcbf);']);

%------------------------------------------------------------------------
% Calculate sizes & set positions
%------------------------------------------------------------------------
if ~exist('figPos'),

% Retrieve screen dimensions (in correct units)
oldUnits = get(0,'Units');         % remember old units
set( 0, 'Units', dlgUnits );       % convert to desired units
screenSize = get(0,'ScreenSize');  % record screensize
set( 0, 'Units',  oldUnits );      % convert back to old units

% Calc max size required - h & v indicate if srolls are required
reqWide = max(panelWide+pnlRTWide);
reqHigh = max(panelHigh+pnlCTHigh);

h=0;v=0;
if reqHigh>screenSize(4)-winTopGap-winSideGap,
   v=scrollWide;
end;
if reqWide+v>screenSize(3)-2*winSideGap,
   winWide=screenSize(3)-2*winSideGap;
   h=scrollWide;
else
   winWide=reqWide+v;
end;

if reqHigh+h>screenSize(4)-winTopGap-winSideGap,
   winHigh=screenSize(4)-winTopGap-winSideGap;
else
   winHigh=reqHigh+h;
end;

% Perform the window resize - triggers callback
winWide=winWide+0.5; % an annoying bug loses 0.5 on width
winHigh=winHigh+0.5; % an annoying bug loses 0.5 on width
set(ipFig, 'Position', [winSideGap, screenSize(4)-winTopGap-winHigh, winWide, winHigh]);

else
   dispdlg('dispDlg_figResize',ipFig); % use existing size & pos
end;   

%=========================================================================
% ACTIVATE
%=========================================================================
% Make figure visible
%------------------------------------------------------------------------
set( ipFig, 'Visible','on', 'HandleVisibility','callback' );

end; %switch


%*************************************************************************
% Function to handle line feeds & c/rs
function str_out=strsplit(str_in)
% searches the i/p string vector for l/f or c/r & breaks it 
% into a string  matrix, each line filled with trailing blanks.

if isempty(str_in), str_out=' '; return; end;
k=0;
for j=1:size(str_in,1),
	i=0;
	rem=str_in(j,:);
	while ~isempty(rem),
       i=i+1;
       [cell_out{i},rem]=strtok(rem,[char(10);char(13)]);
	end
	str_out(k+1:k+i,:)=strvcat(cell_out);
   k=k+i;
end

%*************************************************************************
% Function to find sizes of elements of a cell array
function outsiz=sizes(cells,n)
% Returns a matrix of length of the n-th dim of the elements of the cell array
% if n is omitted, sizes of all elements are returned & outsiz is 
%  size(cells)-by-max(size(elements))

if exist('n'),
   outsize=zeros(size(cells));
   for i=1:length(cells(:)),
      outsiz(i,:)=size(cells{i},n);
   end
else
   i=1;
   outsize=[];
   cellsiz=sizes(cells,1);
   while any(cellsiz(:)),
      outsize=[outsize;cellsiz];
      i=i+1;
      cellsiz=sizes(cells,i);
   end
   outsize=reshape(outsize,size(cells),i);
end

%*************************************************************************
% Function to pad with spaces any cells not having the given no. rows 
function outcells=cellpad(incells,n)
% Assumes i/p is a cell matrix of 2d string matrices
% Strings longer than n are not altered

outcells=incells;
for i=1:length(incells(:)),
   if size(incells{i},1)<n,
      outcells{i}=[outcells{i};char(32*ones(n-size(outcells{i},1),size(outcells{i},2)))];
   end
end

%*************************************************************************
% Function to write strings containing/describing the input
function [strOut]=var2str(varIn)
% Produces strings as produced by disp

typIn=whos('varIn');

if iscell(varIn) & length(varIn)==1, 
   parIn=varIn{1};
   fCell=1;
else
   parIn=varIn;
   fCell=0;
end
if iscell(varIn) & length(varIn)<1, 
   strOut='{}';
   return;
end

if ischar(parIn),
   if isempty(parIn),
      strOut='''''';
   elseif size(parIn,1)<2 & size(parIn,2)<31, 
      strOut=['''' parIn '''']; 
   else
      strOut=['[' num2str(size(parIn,1)) 'x' num2str(size(parIn,2)) ' char]'];
   end
elseif isnumeric(parIn), 
   if isempty(parIn),
      strOut='[]';
   elseif length(parIn)==1, 
      strOut=num2str(parIn); 
   elseif size(parIn,1)<2 & size(parIn,2)<11, 
      strOut=['[' num2str(parIn) ']']; 
   else
      strOut=['[' num2str(size(parIn,1)) 'x' num2str(size(parIn,2)) ' ' typIn.class ']'];
   end
else
   strOut=['[' num2str(size(parIn,1)) 'x' num2str(size(parIn,2)) ' ' typIn.class ']'];
end

if fCell, strOut=['{' strOut '}']; end;
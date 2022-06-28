function result = inputdlg2( cellItems, figId, charMode, inputDef )
%inputdlg2   Generate a matrix of input prompts for user input.
%   Result = inputdlg2(Prompt) returns string matrix of data input.
%   Prompt is cell array of prompts, 1 for each entry, containing:
%        a string cell vector of m row titles (optional)
%        a string cell vector of n column titles (optional)
%        a string cell array of m*n input item prompts (optional)
%        or just an array of m*n prompts
%        (either row & col titles or prompts must be provided)
%
%   Result = inputdlg2(Prompt, Title) where:
%   Title is a string title for the whole dialog.
%
%   Result = inputdlg2(Prompt, Title, Mode) where:
%   Mode is two cells:
%   Mode{1} is interpretation mode - 0 for char (default) or 1 for numeric 
%        if scalar, it applies to whole (Mode=1 makes all inputs numeric)
%        if vector, it applies for each row/column (ones(1,1:3) cols 1:3 numeric)
%        if matrix m*n, it identifies inputs which are numeric.
%   Mode{2} sets one or more lines for each input - 1 for single (def), 2 for many.
%
%   Result = inputdlg2(Prompt, Title, Mode, Default) where:
%   Default is an m*n matrix to the initial values
%        or a single value to apply to all (accepts number, string or cell).
%
%   inputdlg2 displays a matrix of input boxes with prompts in a resizable 
%   scrolled figure window.The calling process is stopped to await the 
%   user selection. The inputs made by the user are returned as Result: 
%       an m*n cell array of strings if the mode was 0,
%       an m*n matrix if mode was 1,
%       an m*n cell array of cells if mode was mixed.
%   Result is empty if no entry is made, or the dialog is cancelled 
%   or closed.
%   NB! Beware of large arrays - they do take a long time!
%
%   For example:
%       cond={'Altitude';'Mach Number';'Delta Temp from ISA'};
%       user_in=inputdlg2(cond,'Sim i/p Values',1,[0;0;0]);
%       user_in
%
%       lab={'Title';'Sub-title';'X Label';'Y Label';'No of Plots'};
%       prm={'include model name';'simulation conditions'};
%       prm=[prm;{'name [units]';'name [units]';'-ve for standard sets'}];
%       user_in=inputdlg2({lab,{''},prm},'Sim Plot Settings',[0;0;0;0;1]);
%       user_in
%
%   See also: INPUTDLG, MENU, LISTDLG, listdlg2, selctdlg3.

%   Author: Mike Thomson   6 August 2001 

%------------------------------------------------------------------------
% Set spacing and sizing constants for the GUI layout
%-------------------------------------------------------------------------
dlgUnits  = 'points'; % units used for all objects
dlgColor   = [0.8,0.8,0.8];
bgColor  = [0.45,0.45,0.45];
edColor  = [1,1,1];

%Window positioning
winTopGap   = 35;       % gap between top of screen and top of figure **
winSideGap  = 10;       % gap between side of screen and side of figure **

% ** figure function 'Position' parameter sets "available" area. You must 
% allow space around it for the whole window size - the OS adds
% a title bar (aprx 42 points on Mac and Windows) and a window border
% (usu 2-6 points). Otherwise user cannot move the window.
% Also you may be prevented from setting bottom below 26 points.
% 800, 600 pixels -> 600, 450 points.

%Gaps
pane2Gap=5;
pane1Gap=1;
textPad = [0,0,12,2];   % extra [0,0,Width,Height] on uicontrols to pad text

% obj sizes + textPad make min sizes
% objWide=12; objHigh=12; objGap=2; % original values -- changed by Michela
objWide=20; objHigh=20; objGap=20;

%Extras
okWide      = 40;       % for OK & Cancel buttons
okHigh      = 15;       % for OK & Cancel buttons
scrollWide  = 12;       % 

%=========================================================================
% PERFORM CALLBACK ACTION
%=========================================================================
if ischar(cellItems)
   fragName=cellItems;
else
   fragName='none';
end;
switch fragName

case 'ipDlg_figResize'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   %get figure size
   figPos = get(figId,'Position');
   
   % Get panel size data
   PnS=get(hData.FrameBox,'Userdata'); % [panelWide;panelHigh;pnlRTWide;pnlCTHigh]
   
   % Check min size
   minWide = 50 + PnS(3) + pane1Gap*2;
   minWide = max(minWide,2*okWide+pane2Gap*3);
   minHigh = 50 + PnS(4) + pane1Gap*2 + okHigh + pane2Gap*2;
   
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
   
   % Set Pane 2 sizes
   Pane2High=okHigh+pane2Gap*2;
   set( hData.Pane2(1), 'Position', [-10, 0, winWide+20, Pane2High] );
   x=(winWide - 2*okWide)/3;
   set( hData.Pane2(2), 'Position', [x, pane2Gap, okWide, okHigh] );
   set( hData.Pane2(3), 'Position', [2*x+okWide, pane2Gap, okWide, okHigh] );
   
   % Set pwFrame positions
   pwFrameLeft=0;
   pwFrameBott=Pane2High;
   pwFrameWide=winWide;
   pwFrameHigh=winHigh - Pane2High;
   pc{1}=[pwFrameLeft, pwFrameBott, PnS(3), pwFrameHigh];
   pc{2}=[pwFrameLeft, pwFrameBott+pwFrameHigh-PnS(4), pwFrameWide, PnS(4)];
   set( hData.PwFrame, {'Position'}, pc' );

   % Set Scroll positions - use h & v to indicate slider present
   viewPos=[pwFrameLeft+PnS(3), pwFrameBott, pwFrameWide-PnS(3), pwFrameHigh-PnS(4)];
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
   pc{1}=[pwFrameLeft, pwFrameBott, PnS(3), pane1Gap+h];
   pc{2}=[pwFrameLeft, viewPos(2)+viewPos(4), PnS(3), PnS(4)];
   pc{3}=[viewPos(1)+viewPos(3)-v, viewPos(2)+viewPos(4), pane1Gap+v, PnS(4)];
   set( hData.TitFrame, {'Position'}, pc' );
   
   % Reset the objects positions
   inputdlg2('ipDlg_scroll',figId);
   
case 'ipDlg_scroll'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   % Get panel data (in fact it might be better to store these in hData)
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
      pos=num2cell( [RTPos + [ones(size(RTPos,1),1)*[(pane1Gap),pnlOff(2)-sclV] zeros(size(RTPos,1),2)] ] ,2);
      set( hData.Panel.RTitle, {'Position'}, pos );
   end;
   if ~isempty(hData.Panel.CTitle),
      CTPos=hData.Panel.ctPos;
      pos=num2cell( [CTPos + [ones(size(CTPos,1),1)*[pnlOff(1)-sclH,(SlP(2)+SlP(4))] zeros(size(CTPos,1),2)] ] ,2);
      set( hData.Panel.CTitle, {'Position'}, pos );
   end;

case 'ipDlg_OkClick'
   % Set OK button Userdata to trigger OK completion
   set(gcbo,'Userdata',1);
   
case 'ipDlg_CnlClick'
   % Get OK button from handle data
   hData=get(figId, 'Userdata');
   
   % Set OK button Userdata & release dialog
   set(hData.Pane2(2),'Userdata',0);
   
otherwise
   
%=========================================================================
% INPUT PARAMETER CHECKS
%=========================================================================
% Check parameter list
%-------------------------------------------------------------------------
error(nargchk(1,4,nargin));

%-------------------------------------------------------------------------
% Set defaults
%-------------------------------------------------------------------------
if nargin<2,
   figId='Input Dialog 2';
end;
if nargin<3,
   charMode={0,1};
end;
if nargin<4,
   inputDef=[];
end;

%-------------------------------------------------------------------------
% Check PROMPT sizes & types
%-------------------------------------------------------------------------
if ~iscell(cellItems),
   error('A cell array is expected as the Prompt list.');
end;

% Dismantle the input cell array
noPItems=0; % initialise flag for no pItems
[r,c]=size(cellItems);
if r~=1 & c~=1,
   if ~iscell(cellItems{1,1}),
      %no rownames
      %no colnames
      pItems=cellItems;   % only prompt items supplied
   else
      error('Prompt list should be a cell vector of cells or a cell matrix of strings.');
   end;
elseif ~iscell(cellItems{1,1}),
   %no rownames
   %no colnames
   pItems=cellItems;   % only prompt items supplied
elseif length(cellItems)==1 & iscell(cellItems{1}),
   [r,c]=size(cellItems{1});
   %no rownames
   %no colnames
   pItems=cellItems{1}; % only prompt items supplied
elseif length(cellItems)==2,
   [r1,c1]=size(cellItems{1});
   [r2,c2]=size(cellItems{2});
   if min(r1,c1)==1 & min(r2,c2)==1,
      rowTitle=cellItems{1}; rowTitle=rowTitle(:); % rows title vector 
      colTitle=cellItems{2}; colTitle=colTitle(:)'; % columns title vector
      nRow=length(rowTitle);
      nCol=length(colTitle);
      pItems=cell(nRow,nCol); % define an empty set of prompts for ease later
      noPItems=1;    % flag for no pItems
   else
      pItems=cellItems{2};
      if length(cellItems{1})==c2,
         %no rownames
         colTitle=cellItems{1}; colTitle=colTitle(:)'; % title vector matches columns
      elseif length(cellItems{1})==r2,
         rowTitle=cellItems{1}; rowTitle=rowTitle(:); % title vector matches rows
         %no colnames
      else
         error('The first cell in Prompt list is the wrong size.');
      end;
   end;
elseif length(cellItems)==3,
   pItems=cellItems{3};     % all items supplied
   [r,c]=size(cellItems{3});
   rowTitle=cellItems{1}; rowTitle=rowTitle(:);
   colTitle=cellItems{2}; colTitle=colTitle(:)';
   if length(rowTitle)~=r | length(colTitle)~=c,
      error('A title in Prompt list is the wrong size.');
   end;
else
   error('Prompt list is the wrong size.');
end;

[nRow,nCol]=size(pItems);

%-------------------------------------------------------------------------
% Check MODE & DEFAULT sizes
%-------------------------------------------------------------------------
% Characters or numbers?
if ~iscell(charMode),
   cMode=charMode;
   nMode=1;
else
   cMode=charMode{1};
   if length(charMode)<2,
      nMode=1;
   else
      nMode=charMode{2};
   end;
end;
[r,c]=size(cMode);
if ~isnumeric(cMode),
   error('Mode must be numeric');
end;
if r==1 & c==1,
   cMode=cMode*ones(nRow,nCol);
elseif r==1 & c==nCol,
   cMode=ones(nRow,1)*cMode;
elseif c==1 & r==nRow,
   cMode=cMode*ones(1,nCol);
elseif r~=nRow | c~=nCol,
   error('Bad Mode size');
end;

% How many lines per edit?
[r,c]=size(nMode);      % nMode was set with cMode
if ~isnumeric(nMode),
   error('Mode must be numeric');
end;
if r==1 & c==1,
   nMode=nMode*ones(nRow,nCol);
elseif r==1 & c==nCol,
   nMode=ones(nRow,1)*nMode;
elseif c==1 & r==nRow,
   nMode=nMode*ones(1,nCol);
elseif r~=nRow | c~=nCol,
   error('Bad Mode size');
end;
for i=1:nRow*nCol,
   if cMode(i)==1,  nMode(i)=1; end;
end

% Default edit values
if isempty(inputDef),
   iDef=cell(nRow,nCol);
else
[r,c]=size(inputDef);
% If single value default
if r==1 & c==1,
   if ischar(inputDef),
      for i=1:nRow*nCol, iDef{i}=inputDef; end;
      iDef=reshape(iDef,nRow,nCol);
   elseif isnumeric(inputDef),
      for i=1:nRow*nCol, iDef{i}=num2str(inputDef); end;
      iDef=reshape(iDef,nRow,nCol);
   elseif iscell(inputDef),
      if ischar(inputDef{1}),
         for i=1:nRow*nCol, iDef{i}=inputDef{1}; end;
      elseif isnumeric(inputDef{1}) & length(inputDef{1})==1,
         for i=1:nRow*nCol, iDef{i}=num2str(inputDef{1}); end;
      else
         error('Bad Default cell type / size');
      end;
      iDef=reshape(iDef,nRow,nCol);
   else
      error('Default is the wrong type.');
   end;
% If matrix provided - check size & if not cells make cells
elseif r==nRow & c==nCol,
   if ~iscell(inputDef),
      for i=1:nRow*nCol,
         if ~ischar(inputDef(i)),
            iDef{i}=num2str(inputDef(i));
         else
            iDef{i}=inputDef(i);
         end;
      end;
      iDef=reshape(iDef,nRow,nCol);
   else
      %check all are strings
      for i=1:nRow*nCol,
         if isnumeric(inputDef{i}),
            iDef{i}=num2str(inputDef{i});
         elseif ischar(inputDef{i})
            iDef{i}=inputDef{i};
         else
            error('Bad Default cell type');
         end;
      end;
      iDef=reshape(iDef,nRow,nCol);
   end;
% Must be wrong size
else
   error('Default is the wrong size.');
end;
end;

%=========================================================================
% BUILD THE GUI
%=========================================================================
% Create a generically-sized invisible figure window
%------------------------------------------------------------------------
ipFig = figure('Units'        ,dlgUnits, ...
               'NumberTitle'  ,'off', ...
               'IntegerHandle','off', ...
               'MenuBar'      ,'none',...
               'Name'         ,figId, ...
               'Visible'      ,'off', ...
               'Colormap'     ,[]);

%------------------------------------------------------------------------
% Add contents of the scrolled panels - in pane 1
%------------------------------------------------------------------------
% Note that these will be moved later on.

% Make the buttons in the panel - position wrt panel in the figure UserData
% The order these are specified determines the order for moving focus
% with the tab button.
for i=1:nRow,
   for j=1:nCol,
      hEdit(2*i-1,j) = uicontrol( ...
            'Style'     ,'text',...
            'Units'     ,dlgUnits, ...
            'Background',dlgColor,...
            'String'    ,pItems{i,j} );
      hEdit(2*i,j) = uicontrol( ...
            'Style'     ,'edit',...
            'Units'     ,dlgUnits, ...
            'Background',edColor,...
            'Horizontal','left',...
            'Max'       ,nMode(i,j),...
            'String'    ,iDef{i,j} );
   end; % for
end; % for

% Store the contents object handles in a structure
hPanel.Object=hEdit;

%------------------------------------------------------------------------
% Add the scroll sliders
%------------------------------------------------------------------------
% Note that these will be sized & moved later on.

hScrollH = uicontrol(...
         'Style','slider',...
         'Units',dlgUnits, ...
         'Min',0,'Max',1 ,...
         'Value',0 , ...
         'Callback','inputdlg2(''ipDlg_scroll'',gcbf);',...
         'SliderStep',[0.1 1]);

hScrollV = uicontrol(...
         'Style','slider',...
         'Units',dlgUnits, ...
         'Min',0,'Max',1 ,...
         'Value',0 , ...
         'Callback','inputdlg2(''ipDlg_scroll'',gcbf);',...
         'SliderStep',[0.1 1]);
      
h2Scrolls = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % if both frames - bot right

%------------------------------------------------------------------------
% Add the panelWindow surround frames
%------------------------------------------------------------------------
hPwFrame(1) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To frame left text
hPwFrame(2) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To frame top text

%------------------------------------------------------------------------
% Add the panel title objects
%------------------------------------------------------------------------
% Note that these will be moved later on.
% Make the titles around the panel
if exist('rowTitle')==1,
   for i = 1 : nRow,
      hTitleRow(i,1) = uicontrol( ...
        'Style'       ,'text', ...
        'String'      ,rowTitle{i}, ...
        'Units'       ,dlgUnits, ...
        'Horizontal'  ,'center',...
        'Background'  ,dlgColor );
  end; % for
end; %if

if exist('colTitle')==1,
   for j = 1 : nCol,
      hTitleCol(j) = uicontrol( ...
        'Style'       ,'text', ...
        'String'      ,colTitle{j}, ...
        'Units'       ,dlgUnits, ...
        'Horizontal'  ,'center',...
        'Background'  ,dlgColor );
  end; % for
end; %if

%------------------------------------------------------------------------
% Do full size check for objects & titles
%------------------------------------------------------------------------
%  & set panel titles' & objects' Userdata here
% Object size
oExtSize = get( hEdit, {'Extent'} );
oTexts = cat( 1, oExtSize{:} );    % convert to an n x 4 matrix
oWides = reshape(oTexts(:,3),2*nRow,nCol);
oHighs = reshape(oTexts(:,4),2*nRow,nCol);
oMaxWide = max([ones(1,nCol)*objWide;oWides])'+ textPad(3);    % calculate the largest width & height
oMaxHigh = max([ones(1,nRow*2)*objHigh;oHighs'])'+ textPad(4); % add some blank space around text
if noPItems, oMaxHigh(1:2:2*nRow)=1; end;

% Row Title size - if there
if exist('rowTitle')==1,
   rtTexts = get( hTitleRow, {'Extent'} );   % get ext, convert to nx4 matrix
   rtTexts = cat( 1, rtTexts{:} );
   rtWide = max(rtTexts(:,3))+ textPad(3); % one width for all
   rtHighs = rtTexts(:,4) + textPad(4);    % vector of heights for all
   oMaxHigh(2:2:2*nRow) = max(oMaxHigh(2:2:2*nRow),...
      rtHighs-oMaxHigh(1:2:2*nRow));       % stretch edits if titles large
   rtHighs = max(rtHighs,oMaxHigh(1:2:2*nRow)+oMaxHigh(2:2:2*nRow));
                                           % fit titles if prompts large
else
   rtWide=1;
end; %if

% Col Title size - if there
if exist('colTitle')==1,
   ctTexts = get( hTitleCol, {'Extent'} );   % get ext, convert to nx4 matrix
   ctTexts = cat( 1, ctTexts{:} );
   ctHigh = max(ctTexts(:,4))+ textPad(4); % one height for all
   ctWides = ctTexts(:,3) + textPad(3);    % vector of widths for all
   oMaxWide = max(ctWides,oMaxWide);       % stretch prompts if titles large
   ctWides = oMaxWide;                     % fit titles if prompts large
else
   ctHigh=1;
end; %if

% Object Positions
xPos=cumsum( ones(nCol,1)*objGap + [0;oMaxWide(1:nCol-1)] );
yAlt=[ones(1,nRow);zeros(1,nRow)];
yPos=flipud( cumsum( yAlt(:)*objGap + [0;oMaxHigh(2*nRow:-1:2)] ));
if noPItems, yPos(1:2:2*nRow)=yPos(1:2:2*nRow)-1; end;
% Now make up matrix of positions & sizes for all objects
[x,y]=meshgrid(xPos,yPos);
[w,h]=meshgrid(oMaxWide,oMaxHigh);
% Finally rearrange into vectors & make cells for uiControls
hPanel.oPos=[x(:),y(:),w(:),h(:)];

% Title Positions
if exist('rowTitle')==1,
   rtPos=[zeros(nRow,1),yPos(2:2:2*nRow),ones(nRow,1)*rtWide,rtHighs];
   hPanel.rtPos=rtPos;     % Store panel title pos & size in structure
   % Store the title object handles in a structure
   hPanel.RTitle=hTitleRow;
else
   hPanel.rtPos=[];        % Watch out for this empty pos!!!
   hPanel.RTitle=[];
end;
if exist('colTitle')==1,
   ctPos=[xPos,zeros(nCol,1),ctWides,ones(nCol,1)*ctHigh];
   hPanel.ctPos=ctPos;     % Store panel title size & pos in structure
   % Store the title object handles in a structure
   hPanel.CTitle=hTitleCol;
else
   hPanel.ctPos=[];        % Watch out for this empty pos!!!
   hPanel.CTitle=[];
end;

% Set panel size for objects & Titles
panelWide=xPos(nCol)-xPos(1)+oMaxWide(nCol)+2*objGap;
panelHigh=yPos(1)-yPos(nRow*2)+oMaxHigh(1)+2*objGap;
pnlRTWide=rtWide;
pnlCTHigh=ctHigh;


%------------------------------------------------------------------------
% Add the panel title end frames
%------------------------------------------------------------------------
hFrameBox=axes('Units'   ,'points',...
               'XLimMode','manual',...
           'XLim',[0,100],'XTick',[],...
           'YLim',[0,100],'YTick',[],...
                  'Color',bgColor,...
             'Userdata'  ,[panelWide,panelHigh,pnlRTWide,pnlCTHigh]);
hBox=rectangle('Position',[0,0,100,100]);
hTitFrame(1) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To cover bottom left
hTitFrame(2) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To frame top left
hTitFrame(3) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To frame top right

%------------------------------------------------------------------------
% Store all handles in a structure for retrieval
%------------------------------------------------------------------------
hData.FrameBox=hFrameBox;
hData.Box=hBox;
hData.Panel=hPanel;
hData.PwFrame=hPwFrame;
hData.TitFrame=hTitFrame;
hData.Scroll=[hScrollH,hScrollV,h2Scrolls];

%------------------------------------------------------------------------
% Create pane 2
%------------------------------------------------------------------------
hOkFrame=uicontrol('Style','frame','Units',dlgUnits,...
   'Background',dlgColor  );

hOkBut=uicontrol('Units',dlgUnits,...
   'Background',dlgColor,...   
   'Callback'  ,'inputdlg2(''ipDlg_OkClick'');', ...
   'Userdata'  ,-1,...
   'String'    ,'OK' );

hCnlBut=uicontrol('Units',dlgUnits,...
   'Background',dlgColor,...   
   'Callback'  ,'inputdlg2(''ipDlg_CnlClick'',gcbf);', ...
   'String'    ,'Cancel' );

% Set callbacks for figure close & resize
set(ipFig, 'CloseRequestFcn' ,['inputdlg2(''ipDlg_CnlClick'', gcbf);'],...
           'ResizeFcn'       ,['inputdlg2(''ipDlg_figResize'',gcbf);']);

%------------------------------------------------------------------------
% Store the handle structure in the figure Userdata
%------------------------------------------------------------------------
hData.Pane2=[hOkFrame, hOkBut, hCnlBut];
set(ipFig, 'Userdata', hData);

%------------------------------------------------------------------------
% Calculate sizes & set positions
%------------------------------------------------------------------------
% Retrieve screen dimensions (in correct units)
oldUnits = get(0,'Units');         % remember old units
set( 0, 'Units', dlgUnits );       % convert to desired units
screenSize = get(0,'ScreenSize');  % record screensize
set( 0, 'Units',  oldUnits );      % convert back to old units

% Calc max size required - h & v indicate if srolls are required
reqWide = max(panelWide+pnlRTWide);% + pane1Gap
reqHigh = max(panelHigh+pnlCTHigh) + okHigh + pane2Gap*2;% + pane1Gap

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

%=========================================================================
% ACTIVATE
%=========================================================================
% Make figure visible
%------------------------------------------------------------------------
set( ipFig, 'Visible','on', 'HandleVisibility','callback' );

%------------------------------------------------------------------------
% Wait for completion (i.e OK button UserData must be assigned)...
%------------------------------------------------------------------------
waitfor(hOkBut,'Userdata');

%------------------------------------------------------------------------
% ...selection has been made. Assign result and delete the Selection figure
%------------------------------------------------------------------------
result=[];
while get(hOkBut,'Userdata'),
   set(hOkBut,'Userdata',0);  % Reset to get out if all is ok
   % get the data in string cell matrix
   cellData = get(hEdit([1:nRow]*2,[1:nCol]),'String');
   if ~iscell(cellData),
      cellData={cellData}; % convert a single string to cell 
   end;
   k=find(cMode); % easy to do single loop
   [i,j]=find(cMode);  % for error dialog
   % Check if any number-mode items have chars
   broken=0;
   for n=1:length(k),
      if isempty(cellData{k(n)}),
         num=0;
      else
         num=str2num(cellData{k(n)});
      end;
      if isempty(num),
         errordlg(['Cell ' num2str(i(n)) ',' num2str(j(n)) ' should be numeric']);
         % If so, wait again & restart check
         set(hEdit(i,j),'Selected','on'); % Set focus to cell i,j
         set(hOkBut,'Userdata',-1);
         waitfor(hOkBut,'Userdata');
         result=[];
         broken=1;
         break;
      end;
      cellData{k(n)}=num;
   end;
   if all(cMode(:)) & ~broken,
      cellData=cat(2,cellData{:});
      result = reshape(cellData,nRow,nCol); 
   elseif ~all(cMode(:)) & ~broken,
      result=reshape(cellData,nRow,nCol);
   end;

end;

delete(ipFig)

end; %switch

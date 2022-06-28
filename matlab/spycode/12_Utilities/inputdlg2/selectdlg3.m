function result = selectdlg3( cellItems, figId, selMode, selDeft )
%selectdlg3   Generate a tabbed, scrolled window of choices for user selection.
%   Choice = selectdlg3(Itemlist) returns an index into Itemlist.
%   Itemlist is a cell vector (length nt+1) containing:
%     a string cell matrix of nt rows {tab_labels;tab_titles} (tab_titles optional)
%     nt Choice cell vectors - each containing: 
%        a string cell vector of row titles (optional)
%        a string cell vector of column titles (optional)
%        a string cell array of m*n choice item names
%        or just an array of m*n choice item names
%
%   Choice = selectdlg3(Itemlist, Title) where:
%   Title is a string title for the selection window.
%
%   Choice = selectdlg3(Itemlist, Title, Mode) where:
%   Mode is selection mode : 0 for mutiple (default) or 1 for single - 
%     if scalar, it applies to whole (Mode=1 allows only a single button)
%     if vector, it must have length of 3 : [row_mode, col_mode, tab_mode]
%        row_mode=1 means only 1 row in any given col allowed
%        col_mode=1 means only 1 col in any given row allowed
%        but if both row & col, only 1 button on the tab allowed
%        tab_mode=1 means only the tab in view returns its settings
%        e.g. Mode=[1,0,1] : only 1 button per col, from only current tab.
%
%   Choice = selectdlg3(Itemlist, Title, Mode, Default) where:
%   Default is a px3 index matrix to the button(s) initially selected.
%        Index values outside the array of choices are ignored.
%
%   selectdlg3 displays arrays of radio buttons in a resizable figure 
%   window with tabbed panels. The calling process is stopped to await the 
%   user selection. The choice(s) selected by the user is/are returned as  
%   Choice, an mx3 index (row, col, tab) into the Itemlist cell array. 
%   Choice is empty if no selection is made, or the dialog is cancelled 
%   or closed.
%
%   For example:
%       tabs={'Car/Tyre';'Day'};
%       tits={'Select car/tyre combination';'Condition for each day'};
%       cars={'Porsche';'Mercedes';'Audi';'BMW';'VW'};
%       tyres={'Michelin','Firestone','Continental','Dunlop'};
%       numb={'First';'Second';'Third'};
%       humid={'Wet','Medium','Dry'};
%       choice1={cars,tyres,cell(5,4)};
%       choice2={numb,humid,cell(3,3)};
%       def=[[[1:5]',ones(5,2)];[[1:3]',ones(3,2)*2]];
%       sel = selectdlg3({[tabs,tits],choice1,choice2},'Race Selection',[0,1,0],def); 
%       type=[cars(sel([1:5],1)),tyres(sel([1:5],2))']
%       day=[numb(sel([6:8],1)),humid(sel([6:8],2))']
%
%   See also: MENU, LISTDLG, TABDLG, selectdlg, selectdlg2, listdlg2.

%   Author: Mike Thomson   4 August 2001 

%------------------------------------------------------------------------
% Set spacing and sizing constants for the GUI layout
%-------------------------------------------------------------------------
dlgUnits  = 'points'; % units used for all objects
dlgColor   = [0.8,0.8,0.8];
bgColor  = [0.95,0.95,0.95];
tabColor  = [0.7,0.7,0.7];

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
pane1Gap=5;
pane2Gap=5;
tabGap=1;
textPad = [0,0,10,2];   % extra [0,0,Width,Height] on uicontrols to pad text
selHigh = 4;

%Extras
okWide      = 40;       % for OK & Cancel buttons
okHigh      = 15;       % for OK & Cancel buttons
scrollWide  = 12;       % 

%Set tab button size
tabButWide=40;
tabButHigh=15;

% Min Object sizes
objWide=30; objHigh=10; objGap=4;

%=========================================================================
% PERFORM CALLBACK ACTION
%=========================================================================
if ischar(cellItems)
   fragName=cellItems;
else
   fragName='none';
end
switch fragName

case 's3Dlg_buttonClick'
   hData=get(figId, 'Userdata');
   i=selDeft(1);
   j=selDeft(2); % button coords passed in with selDeft
   k=selDeft(3);
   % If both selMode(1) & selMode(2)
   if selMode(1) & selMode(2),
      [r,c]=size(hData.Tab(k).Object);
      rows=setdiff([1:r],i);
      cols=setdiff([1:c],j);
      obj=hData.Tab(k).Object(rows,:); % all the other rows in all cols
      set(obj,{'Value'},{0});
      obj=hData.Tab(k).Object(i,cols); % all the other cols in this row
      set(obj,{'Value'},{0});
      set(hData.Tab(k).Object(i,j),{'Value'},{1}); % don't permit deselect
   end
   
   %if selMode(1), clear other rows in this col
   if selMode(1),
      r=size(hData.Tab(k).Object,1);
      rows=setdiff([1:r],i);
      obj=hData.Tab(k).Object(rows,j); % all the other rows in this col
      set(obj,{'Value'},{0});
      set(hData.Tab(k).Object(i,j),{'Value'},{1}); % don't permit deselect
   end
   %if selMode(2), clear other cols in this row
   if selMode(2),
      c=size(hData.Tab(k).Object,2);
      cols=setdiff([1:c],j);
      obj=hData.Tab(k).Object(i,cols); % all the other cols in this row
      set(obj,{'Value'},{0});
      set(hData.Tab(k).Object(i,j),{'Value'},{1}); % don't permit deselect
   end
   
case 's3Dlg_figResize'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   %get figure size
   figPos = get(figId,'Position');  % record fig - user re-size
   
   % Get panel size data
   PnS=get(hData.TabButton,{'Userdata'});
   PnS=cat(1,PnS{:});
   
   % Check min size
   minWide = 50 + max(PnS(:,3)) + pane1Gap*2;
   minWide = max(minWide,2*okWide+pane2Gap*3);
   minHigh = 50 + max(PnS(:,4)) + tabButHigh + ...
      pane1Gap*2 + okHigh + pane2Gap*2;
   
   if figPos(3)<minWide,
      winWide = minWide;
   else
      winWide = figPos(3);
   end %if
   
   if figPos(4)<minHigh,
      winHigh = minHigh;
   else
      winHigh = figPos(4);
   end %if
   
   % Check if top is off the screen
   oldUnits = get(0,'Units');         % remember old units
   set( 0, 'Units', dlgUnits );       % convert to desired units
   screenSize = get(0,'ScreenSize');  % record screensize
   set( 0, 'Units',  oldUnits );      % convert back to old units
   
   if screenSize(4)-winTopGap < figPos(2)+winHigh,
      figPos(2)=screenSize(4)-winTopGap-winHigh;
   end
   
   set(figId, 'Position', [figPos(1), figPos(2), winWide, winHigh]);
   
   % Set Pane 2 sizes
   Pane2High=okHigh+pane2Gap*2;
   set( hData.Pane2(1), 'Position', [-10, 0, winWide+20, Pane2High] );
   x=(winWide - 2*okWide)/3;
   set( hData.Pane2(2), 'Position', [x, pane2Gap, okWide, okHigh] );
   set( hData.Pane2(3), 'Position', [2*x+okWide, pane2Gap, okWide, okHigh] );
   
   % Set TabFrame sizes - NB these are also used later to position pwFrame
   tabFrameWide=winWide-2*pane1Gap;
   tabFrameHigh=winHigh-2*pane1Gap - Pane2High - tabButHigh;
   tabFrameTopbase=Pane2High+pane1Gap+tabFrameHigh;
   pc{1}=[0, Pane2High, pane1Gap, winHigh-Pane2High];
   pc{2}=[pane1Gap+tabFrameWide, Pane2High, pane1Gap, winHigh-Pane2High];
   pc{3}=[pane1Gap, Pane2High, tabFrameWide, pane1Gap];
   pc{4}=[pane1Gap, tabFrameTopbase, tabFrameWide, tabButHigh+pane1Gap];
   pc{5}=[pane1Gap-1, Pane2High+1, tabFrameWide+2, pane1Gap-2];
   pc{6}=[0.5, tabFrameTopbase+0.5, pane1Gap+0.5, tabButHigh+pane1Gap-1.5];
   pc{7}=[winWide-pane1Gap-1, tabFrameTopbase+0.5, pane1Gap, tabButHigh+pane1Gap-1.5];
   set( hData.TabFrame, {'Position'}, pc' );
   
   % Set Tab Button positions
   %    Will the buttons fit?
   nTabs=length(hData.TabButton);
   tPos=get(hData.TabButton,{'Position'});  % fetch button sizes
   tPos=cat(1,tPos{:});
   sumButWide=sum(tPos(:,3));
   butZoneWide=winWide-2*pane1Gap;
   bSlideWide=tabButHigh+1;
   if sumButWide > butZoneWide,
      butFrac=max(1.11,nTabs - (butZoneWide-bSlideWide)*nTabs / sumButWide);
      bSliMx=-bSlideWide + butFrac*sumButWide/nTabs;
      bSlidPos=[pane1Gap, winHigh-pane1Gap-tabButHigh, bSlideWide, tabButHigh];
      set(hData.TabSlide,'Position',bSlidPos, 'Visible','on', 'Value',-bSlideWide);
      set(hData.TabSlide,'Min',-bSlideWide, 'Max',bSliMx, 'SliderStep',[1/butFrac,1]);
   else
      set(hData.TabSlide, 'Visible','off', 'Min',0, 'Max',1, 'Value',0);
   end
  
   % Reset the tab format
   selectdlg3('s3Dlg_tabSelect',figId,get(hData.TabSel,'Userdata'));
   
case 's3Dlg_tabSelect'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   % Which tab?
   oldtab=get(hData.TabSel,'Userdata');
   if nargin>2,
      tab=selMode;      % button number passed in as selMode
   else
      tab=find(gcbo==hData.TabButton); % find index number of button
      if tab==oldtab,
         return;     % just return if we're already in this tab
      end %if
   end %if
   
   % Get panel size data
   PnS=get(hData.TabButton(tab),'Userdata'); % [panelWide;panelHigh;pnlRTWide;pnlCTHigh]
   tFr=get( hData.TabFrame, {'Position'});
   tFr=cat(1,tFr{[2,4]});  % convert to matrix
   pwFrameLeft=tFr(2,1);
   pwFrameBott=tFr(1,2)+tFr(1,3);
   pwFrameWide=tFr(2,3);
   pwFrameHigh=tFr(2,2)-tFr(1,2)-tFr(1,3);
   ttSize=hData.TabTitSz(tab,:);

   % Set pwFrame positions
   pc{1}=[pwFrameLeft, pwFrameBott, PnS(3), pwFrameHigh];
   pc{2}=[pwFrameLeft, pwFrameBott+pwFrameHigh-PnS(4)-ttSize(2), pwFrameWide, PnS(4)];
   set( hData.PwFrame, {'Position'}, pc' );

   % Set Scroll positions - use h & v to indicate slider present
   viewPos=[pwFrameLeft+PnS(3), pwFrameBott, pwFrameWide-PnS(3), pwFrameHigh-PnS(4)-ttSize(2)];
   h=0;v=0;
   if PnS(1)>viewPos(3),
      h=scrollWide;
   end
   if PnS(2)>viewPos(4)-h,
      set( hData.Scroll(2), 'Visible','on' );
      v=scrollWide;
   else
      set( hData.Scroll(2), 'Visible','off' );
   end
   if PnS(1)>viewPos(3)-v,
      set( hData.Scroll(1), 'Visible','on' );
      h=scrollWide;
   else
      set( hData.Scroll(1), 'Visible','off' );
   end
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
   end
   if hStp<=0, hStp=1; end;
   if (PnS(2)-viewPos(4)+h) > 0,
      vStp=(viewPos(4)-h)/(PnS(2)-viewPos(4)+h); % sets slider knob size
   end
   if vStp<=0, vStp=1; end;
   set( hData.Scroll(1), 'Max',hSliMx, 'SliderStep',[min(0.1*hStp,1) hStp], 'Value',0);
   set( hData.Scroll(2), 'Max',vSliMx, 'SliderStep',[min(0.1*vStp,1) vStp], 'Value',vSliMx);
   set( hData.Scroll(3), 'Position', [viewPos(1)+viewPos(3)-scrollWide, viewPos(2), scrollWide, scrollWide] );
   if h&v,
      set( hData.Scroll(3), 'Visible','on' );
   else
      set( hData.Scroll(3), 'Visible','off' );
   end
   
   % Set TabSel Userdata
   set( hData.TabSel, 'Userdata', tab );
   
   % Set TabTitle pars
   pos=[pwFrameLeft,pwFrameBott+pwFrameHigh-ttSize(2),pwFrameWide,ttSize(2)];
   set( hData.TabTitle, 'Position',pos,...
      'String',hData.TabTitTx(tab));
   
   % Set TitFrame positions
   clear pc; % reset size
   pc{1}=[pwFrameLeft, pwFrameBott, PnS(3), tabGap+h];
   pc{2}=[pwFrameLeft, viewPos(2)+viewPos(4), PnS(3), PnS(4)];
   pc{3}=[viewPos(1)+viewPos(3)-v, viewPos(2)+viewPos(4), tabGap+v, PnS(4)];
   set( hData.TitFrame, {'Position'}, pc' );
   
   % Make previous Tab's objects invisible if it's not this one (resizing)
   if oldtab~=tab,
      set(hData.Tab(oldtab).Object,{'Visible'},{'off'});
      set(hData.Tab(oldtab).RTitle,{'Visible'},{'off'});
      set(hData.Tab(oldtab).CTitle,{'Visible'},{'off'});
      set(hData.TabButton(oldtab), 'Background',dlgColor);
   end %if
   
   % Make this Tab's objects visible
   set(hData.Tab(tab).Object,{'Visible'},{'on'});
   set(hData.Tab(tab).RTitle,{'Visible'},{'on'});
   set(hData.Tab(tab).CTitle,{'Visible'},{'on'});
   set(hData.TabButton(tab), 'Background',tabColor);
   
   % Nudge the tab buttons
	slProp=get(hData.TabSlide, {'Value';'Min';'Max'});
	tPos=get(hData.TabButton(tab),'Position');  % fetch this button pos
	butnShift=slProp{1}+max(tPos(1)+tPos(3)-(pwFrameLeft+pwFrameWide-2*pane1Gap),0);
	butnShift=butnShift+min(tPos(1)-pwFrameLeft-tabButHigh-2*pane1Gap,0);
	butnShift=max(min(butnShift,slProp{3}),slProp{2});
	set(hData.TabSlide, 'Value',butnShift);
   % Position the tab buttons
	selectdlg3('s3Dlg_scrollTabs',figId);
   
   % Reset the objects positions
   selectdlg3('s3Dlg_scroll',figId);
   
case 's3Dlg_scrollTabs'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   % Move Tab buttons' positions
   nTabs=length(hData.TabButton);      
   tab=get( hData.TabSel, 'Userdata' ); % Which Tab are we in?
   butnShift=get(hData.TabSlide, {'Value','Userdata'});  % fetch slider shift & button widths
   tButWide=butnShift{2};
   tCumWide=[0;cumsum(tButWide)];       % pos offsets - 0 for 1st
   winPos=get(figId, 'Position');
   tabFrameTopbase=winPos(4)-pane1Gap-tabButHigh;
   for k=1:nTabs,
      pc{k}=[pane1Gap+tCumWide(k)-butnShift{1}, tabFrameTopbase, tButWide(k), tabButHigh];
   end
   pc{tab}=pc{tab}+[0,0,0,2];           % enlarge the current tab button
   set( hData.TabButton, {'Position'}, pc' );
   
   % Move TabSel position
   oldtab=get(hData.TabSel,'Userdata');
   set( hData.TabSel, 'Position', [pane1Gap+tCumWide(oldtab)-butnShift{1}, tabFrameTopbase-selHigh/2, tButWide(oldtab)-1, selHigh] );
   
case 's3Dlg_scroll'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   % Which Tab are we in? (in fact it might be better to store these in hData)
   tab=get( hData.TabSel, 'Userdata' );
   PnS=get(hData.TabButton(tab),'Userdata'); % [panelWide;panelHigh;pnlRTWide;pnlCTHigh]
   SlP=get(hData.Scroll(2),'Position');      % for panel positioning

   % Get object positions wrt fig & wrt panel
   ObjPos=hData.Tab(tab).oPos;
   
   % Get both scroll values
   sclH=get(hData.Scroll(1), 'Value');
   sclV=get(hData.Scroll(2), 'Value');
   
   % Set panel offsets
   pnlOff=[PnS(3)+pane1Gap max(SlP(2),SlP(2)+SlP(4)-PnS(2))];
   
   % Set Object positions
   pos=num2cell( [ObjPos + [ones(size(ObjPos,1),1)*[pnlOff(1)-sclH,pnlOff(2)-sclV] zeros(size(ObjPos,1),2)] ] ,2);
   set( hData.Tab(tab).Object, {'Position'}, pos );
   
   % Get title positions wrt fig &  wrt panel & set Title positions
   if ~isempty(hData.Tab(tab).RTitle),
      RTPos=hData.Tab(tab).rtPos;
      pos=num2cell( [RTPos + [ones(size(RTPos,1),1)*[(pane1Gap),pnlOff(2)-sclV] zeros(size(RTPos,1),2)] ] ,2);
      set( hData.Tab(tab).RTitle, {'Position'}, pos );
   end
   if ~isempty(hData.Tab(tab).CTitle),
      CTPos=hData.Tab(tab).ctPos;
      pos=num2cell( [CTPos + [ones(size(CTPos,1),1)*[pnlOff(1)-sclH,(SlP(2)+SlP(4))] zeros(size(CTPos,1),2)] ] ,2);
      set( hData.Tab(tab).CTitle, {'Position'}, pos );
   end

case 's3Dlg_OkClick'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   % Which Tab are we in?
   tab=get( hData.TabSel, 'Userdata' );
   
   % Set OK button Userdata to trigger dialog completion
   set(gcbo,'Userdata',tab);
   
case 's3Dlg_CnlClick'
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
   figId='Selection Dialog 3';
end
if nargin<3,
   selMode=0;
end
if nargin<4,
   selDeft=[0,0,0];
end

%-------------------------------------------------------------------------
% Check Itemlist sizes
%-------------------------------------------------------------------------
if ~iscell(cellItems),
   error('A cell array is expected as the Itemlist.');
end

% Tab labels & titles
if size(cellItems,1)~=1 & size(cellItems,2)~=1,
   error('The Itemlist must be a vector.');
end
tabs=cellItems{1};
tabLabels=tabs(:,1);
if ~iscell(tabLabels), error('Tab labels must be in a cell vector'); end;
nTabs=min(size(tabLabels,1),length(cellItems)-1);
if size(tabs,2)>1,
   tabTitles=tabs(:,2);
else
   tabTitles=cell(nTabs,1);
end

% Choice items
for t=1:nTabs,
   if length(cellItems{t+1})>3 | ~iscell(cellItems{t+1}),
      error('Wrong size or type of choice item list');
   end
end

%-------------------------------------------------------------------------
% Check Mode & Default sizes
%-------------------------------------------------------------------------
if length(selMode)==1,
   selMode=selMode*ones(1,3);
elseif length(selMode)~=3,
   error('Bad Mode size');
end

if size(selDeft,2)~=3,
   error('Default must have 3 columns.');
elseif all(selMode) & size(selDeft,1)~=1,
   error('When using single-select mode, Default must be a single item.');
end
if size(selDeft,1)>1 | selDeft(1,1)~=0,
   if any(any(selDeft<ones(size(selDeft,1),3))),
      error('A Default value cannot be < 1.'); % how about just ignoring those <1
   end
end
if any(diff(selDeft(:,3))),
   iniTab=1;             %Set the initial tab 1 cos defts are on >1 tab
elseif size(selDeft,2)==1 & selDeft(1,3)==0,
   iniTab=1;             %Set the initial tab 1 cos tab is 0
elseif selDeft(1,3)>0 & selDeft(1,3)<=nTabs,
   iniTab=selDeft(1,3);  %Set the initial tab cos all defts are on 1 tab
else
   iniTab=1;
end

%=========================================================================
% BUILD THE GUI
%=========================================================================
% Create a generically-sized invisible figure window
%------------------------------------------------------------------------
sel3Fig = figure('Units'      ,dlgUnits, ...
                 'NumberTitle'  ,'off', ...
                 'IntegerHandle','off', ...
                 'MenuBar'      ,'none',...
                 'Name'         ,figId, ...
                 'Visible'      ,'off', ...
                 'Color'        ,bgColor,...
                 'Colormap'     ,[]);

%------------------------------------------------------------------------
% Add contents of the scrolled panels 
%------------------------------------------------------------------------
% Note that these need to be invisible at first & will be moved & shown later on.

for k=1:nTabs,
pnlItems=cellItems{k+1};
   
% Check choice cell sizes & types
if ~iscell(pnlItems),
   error('A cell array is expected for each tab''s Choice list.');
end

% Dismantle the input cell array
[r,c]=size(pnlItems);
if r~=1 & c~=1,
   if ~iscell(pnlItems{1,1}),
      rowTitle{k}=[];    %no rownames
      colTitle{k}=[];    %no colnames
      pItems=pnlItems;   % only button items supplied
   else
      error('Choices list should be a cell vector of cells or a cell matrix of strings.');
   end
elseif ~iscell(pnlItems{1,1}),
   rowTitle{k}=[];    %no rownames
   colTitle{k}=[];    %no colnames
   pItems=pnlItems;   % only prompt items supplied
elseif length(pnlItems)==1 & iscell(pnlItems{1}),
   [r,c]=size(pnlItems{1});
   rowTitle{k}=[];     %no rownames
   colTitle{k}=[];     %no colnames
   pItems=pnlItems{1}; % only prompt items supplied
elseif length(pnlItems)==2,
   [r2,c2]=size(pnlItems{2});
   pItems=pnlItems{2};
   if length(pnlItems{1})==c2,
      rowTitle{k}=[];  %no rownames
      temp=pnlItems{1}; colTitle{k}=temp(:)'; % title vector matches columns
   elseif length(pnlItems{1})==r2,
      temp=pnlItems{1}; rowTitle{k}=temp(:); % title vector matches rows
      colTitle{k}=[];  %no colnames
   else
      error('The first cell in Choice list is the wrong size.');
   end
elseif length(pnlItems)==3,
   pItems=pnlItems{3};     % all items supplied
   [r,c]=size(pnlItems{3});
   if size(pnlItems{1},1)~=r | size(pnlItems{2},2)~=c,
      error('A title in Choice list is the wrong size.');
   end
   temp=pnlItems{1}; rowTitle{k}=temp(:);
   temp=pnlItems{2}; colTitle{k}=temp(:)';
else
   error('Choice list is the wrong size.');
end

[nRow,nCol]=size(pItems);

% Make the buttons in each panel - position wrt panel in the UserData
hBtn=[];
for i=1:nRow,
   for j=1:nCol,
      chMod=mat2str(selMode);
      chBtn=[',[' int2str(i) ',' int2str(j) ',' int2str(k) ']'];
      hBtn(i,j) = uicontrol( ...
            'Style'     ,'radiobutton',...
            'Units'     ,dlgUnits, ...
            'Callback'  ,['selectdlg3(''s3Dlg_buttonClick'',gcbf,' chMod chBtn ');'], ...
            'Visible'   ,'off',...
            'String'    ,pItems{i,j} );
   end % for
end % for

if selDeft(1,1),
   iDef=find(selDeft(:,3)==k);
   if ~isempty(iDef),
      for d=1:length(iDef),
         i=selDeft(iDef(d),1);
         j=selDeft(iDef(d),2);
         if i<=nRow & j<=nCol,
            set(hBtn(i,j),'Value',1);
         end
      end
   end
end

% Store the contents object handles in a structure
hTab(k).Object=hBtn;

end %for

%------------------------------------------------------------------------
% Add the scroll sliders
%------------------------------------------------------------------------
% Note that these will be sized & moved later on.

hScrollH = uicontrol(...
         'Style','slider',...
         'Units',dlgUnits, ...
         'Min',0,'Max',1 ,...
         'Value',0 , ...
         'Callback','selectdlg3(''s3Dlg_scroll'',gcbf);',...
         'SliderStep',[0.1 1]);

hScrollV = uicontrol(...
         'Style','slider',...
         'Units',dlgUnits, ...
         'Min',0,'Max',1 ,...
         'Value',0 , ...
         'Callback','selectdlg3(''s3Dlg_scroll'',gcbf);',...
         'SliderStep',[0.1 1]);
      
h2Scrolls = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',tabColor, 'Foreground',tabColor);  % if both frames - bot right

%------------------------------------------------------------------------
% Add the panelWindow surround frames
%------------------------------------------------------------------------
hPwFrame(1) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',tabColor, 'Foreground',tabColor);  % To frame left text
hPwFrame(2) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',tabColor, 'Foreground',tabColor);  % To frame top text

%------------------------------------------------------------------------
% Add the panel title objects
%------------------------------------------------------------------------
% NB these need to be invisible at first & will be positioned & shown later.

for k=1:nTabs,
   
% Get title data & sizes for each tab
   RText=rowTitle{k};
   CText=colTitle{k};
   [nRow,nCol]=size(hTab(k).Object);
   
% Make the row titles
if ~isempty(RText),
   hTitleRow=[]; % re-initialise for this tab
   for i = 1 : nRow,
      hTitleRow(i,1) = uicontrol( ...
        'Style'       ,'text', ...
        'String'      ,RText{i}, ...
        'Units'       ,dlgUnits, ...
        'Horizontal'  ,'center',...
        'Visible'     ,'off',...
        'Background'  ,tabColor );
   end % for
   hTab(k).RTitle=hTitleRow; % Store panel title handles in structure
else
   hTab(k).RTitle=[];        % Watch out for this invalid handle!!!
end %if

if ~isempty(CText),
   hTitleCol=[]; % re-initialise for this tab
   for j = 1 : nCol,
      hTitleCol(j) = uicontrol( ...
        'Style'       ,'text', ...
        'String'      ,CText{j}, ...
        'Units'       ,dlgUnits, ...
        'Horizontal'  ,'center',...
        'Visible'     ,'off',...
        'Background'  ,tabColor );
   end % for
   hTab(k).CTitle=hTitleCol; % Store panel title handles in structure
else
   hTab(k).CTitle=[];        % Watch out for this invalid handle!!!
end %if

%------------------------------------------------------------------------
% Do full size check for objects & titles
%------------------------------------------------------------------------
%  & set panel titles' & objects' Userdata here
% Object sizes
oTexts = get( hTab(k).Object, {'Extent'} );   % get ext, convert to nx4 matrix
oTexts = cat( 1, oTexts{:} );
oWides = reshape(oTexts(:,3),nRow,nCol);
oHighs = reshape(oTexts(:,4),nRow,nCol);
oMaxWide = max([ones(1,nCol)*objWide;oWides])'+ textPad(3);  % calculate the largest width & height
oMaxHigh = max([ones(1,nRow)*objHigh;oHighs'])'+ textPad(4); % add some blank space around text

% Row Title sizes - if there
if ~isempty(RText),
   rtTexts = get( hTitleRow, {'Extent'} ); % get ext, convert to nx4 matrix
   rtTexts = cat( 1, rtTexts{:} );
   rtWide = max(rtTexts(:,3))+ textPad(3); % one width for all
   rtHighs = rtTexts(:,4) + textPad(4);    % vector of heights for all
   oMaxHigh = max(oMaxHigh, rtHighs);      % stretch edits if titles large
   rtHighs = oMaxHigh;                     % fit titles if prompts large
else
   rtWide=1;
end %if

% Col Title sizes - if there
if ~isempty(CText),
   ctTexts = get( hTitleCol, {'Extent'} ); % get ext, convert to nx4 matrix
   ctTexts = cat( 1, ctTexts{:} );
   ctHigh = max(ctTexts(:,4))+ textPad(4); % one height for all
   ctWides = ctTexts(:,3) + textPad(3);    % vector of widths for all
   oMaxWide = max(ctWides,oMaxWide);       % stretch prompts if titles large
   ctWides = oMaxWide;                     % fit titles if prompts large
else
   ctHigh=1;
end %if

% Object Positions
xPos=cumsum( ones(nCol,1)*objGap + [0;oMaxWide(1:nCol-1)] );
yPos=flipud( cumsum( ones(nRow,1)*objGap + [0;oMaxHigh(nRow:-1:2)] ));
% Now make up matrix of positions & sizes for all objects
[x,y]=meshgrid(xPos,yPos);
[w,h]=meshgrid(oMaxWide,oMaxHigh);
% Finally rearrange into a position vector & store in structure
hTab(k).oPos=[x(:),y(:),w(:),h(:)];

% Row Title positions - if there
if ~isempty(RText),
   rtPos=[zeros(nRow,1),yPos,ones(nRow,1)*rtWide,rtHighs];
   hTab(k).rtPos=rtPos;     % Store panel title pos & size in structure
else
   hTab(k).rtPos=[];        % Watch out for this empty pos!!!
end %if

% Col Title positions - if there
if ~isempty(CText),
   ctPos=[xPos,zeros(nCol,1),ctWides,ones(nCol,1)*ctHigh];
   hTab(k).ctPos=ctPos;     % Store panel title size & pos in structure
else
   hTab(k).ctPos=[];        % Watch out for this empty pos!!!
end %if

% Set panel size for objects & Titles
panelWide(k)=xPos(nCol)-xPos(1)+oMaxWide(nCol)+2*objGap;
panelHigh(k)=yPos(1)-yPos(nRow)+oMaxHigh(1)+2*objGap;
pnlRTWide(k)=rtWide;
pnlCTHigh(k)=ctHigh;

end %for

%------------------------------------------------------------------------
% Add the panel title end frames
%------------------------------------------------------------------------
hTitFrame(1) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',tabColor, 'Foreground',tabColor);  % To cover bottom left
hTitFrame(2) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',tabColor, 'Foreground',tabColor);  % To frame top left
hTitFrame(3) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',tabColor, 'Foreground',tabColor);  % To frame top right

%------------------------------------------------------------------------
% Define a box for the tab frame
%------------------------------------------------------------------------
hTabFrame(3) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor);  % To frame bottom tab
hTabFrame(4) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor);  % To frame top tab

%------------------------------------------------------------------------
% Create tab buttons & selector patch etc
%------------------------------------------------------------------------
for k=1:nTabs,
   hTabButton(k)=uicontrol('Units',dlgUnits,...
      'Background',dlgColor,...   
      'Callback'  ,'selectdlg3(''s3Dlg_tabSelect'',gcbf);', ...
      'Userdata'  ,[panelWide(k),panelHigh(k),pnlRTWide(k),pnlCTHigh(k)],...
      'String'    ,tabLabels{k} );
end %for
tTexts=get(hTabButton,{'Extent'});
tTexts = cat( 1, tTexts{:} );        % convert to an n x 4 matrix
tWides = tTexts(:,3) + textPad(3);   % vector of widths for all
tPos=num2cell([ones(nTabs,2),tWides,ones(nTabs,1)],2); %pos & height done later
set(hTabButton,{'Position'},tPos);   % set widths to initialise the tab slider

hTabSel=uicontrol('Style','frame','Units',dlgUnits,...
   'Background',tabColor,'Foreground',tabColor,...   
   'Userdata'  ,iniTab );

hTabSlide=uicontrol('Style','Slider', 'Units',dlgUnits,...
         'Min',0,'Max',nTabs ,...
         'Value',0 , ...
         'Visible','off',...
         'Callback','selectdlg3(''s3Dlg_scrollTabs'',gcbf);',...
         'Userdata',tWides,...
         'SliderStep',[0.1 1]);
      
hTabFrame(1) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor);                         % To frame left tab
hTabFrame(2) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor);                         % To frame right tab
hTabFrame(5) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To cover bottom frame ends
hTabFrame(6) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To cover scrolled buttons
hTabFrame(7) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor, 'Foreground',dlgColor);  % To cover scrolled buttons

hTabTitle = uicontrol('Style','text', 'Units',dlgUnits,...
   'Background',tabColor, 'Horizontal','center');  % For title in panel
ttSize = [];

% Set the size of the Tab Title
for k=1:nTabs,
   set(hTabTitle,'String',tabTitles(k)); 
   ttSize(k,:)=get(hTabTitle,'Extent') + textPad;
end

%------------------------------------------------------------------------
% Store all handles & data in a structure for retrieval
%------------------------------------------------------------------------
hData.Tab=hTab;
hData.TabButton=hTabButton;
hData.TabSel=hTabSel;
hData.TabSlide=hTabSlide;
hData.TabTitle=hTabTitle;
hData.TabTitSz=ttSize(:,[3:4]);
hData.TabTitTx=tabTitles;
hData.PwFrame=hPwFrame;
hData.TitFrame=hTitFrame;
hData.TabFrame=hTabFrame;
hData.Scroll=[hScrollH,hScrollV,h2Scrolls];

%------------------------------------------------------------------------
% Create pane 2
%------------------------------------------------------------------------
hOkFrame=uicontrol('Style','frame','Units',dlgUnits,...
   'Background',dlgColor ,'Foreground',dlgColor );

hOkBut=uicontrol('Units',dlgUnits,...
   'Background',dlgColor,...   
   'Callback'  ,'selectdlg3(''s3Dlg_OkClick'',gcbf);', ...
   'Userdata'  ,-1,...
   'String'    ,'OK' );

hCnlBut=uicontrol('Units',dlgUnits,...
   'Background',dlgColor,...   
   'Callback'  ,'selectdlg3(''s3Dlg_CnlClick'',gcbf);', ...
   'String'    ,'Cancel' );

% Set callbacks for figure close & resize
set(sel3Fig, 'CloseRequestFcn' ,['selectdlg3(''s3Dlg_CnlClick'', gcbf);'],...
             'ResizeFcn'       ,['selectdlg3(''s3Dlg_figResize'',gcbf);']);

%------------------------------------------------------------------------
% Store the handle structure in the figure Userdata
%------------------------------------------------------------------------
hData.Pane2=[hOkFrame, hOkBut, hCnlBut];
set(sel3Fig, 'Userdata', hData);

%------------------------------------------------------------------------
% Calculate sizes & set positions
%------------------------------------------------------------------------
% Retrieve screen dimensions (in correct units)
oldUnits = get(0,'Units');         % remember old units
set( 0, 'Units', dlgUnits );       % convert to desired units
screenSize = get(0,'ScreenSize');  % record screensize
set( 0, 'Units',  oldUnits );      % convert back to old units

% Calc max size required - h & v indicate if srolls are required
reqWide = max(max((panelWide+pnlRTWide),ttSize(:,3)')) + pane1Gap*2;
reqHigh = max(panelHigh+pnlCTHigh) + tabButHigh + max(ttSize(:,4)) +...
   pane1Gap*2 + okHigh + pane2Gap*2;

h=0;v=0;
if reqHigh>screenSize(4)-winTopGap-winSideGap,
   v=scrollWide;
end
if reqWide+v>screenSize(3)-2*winSideGap,
   winWide=screenSize(3)-2*winSideGap;
   h=scrollWide;
else
   winWide=reqWide+v;
end

if reqHigh+h>screenSize(4)-winTopGap-winSideGap,
   winHigh=screenSize(4)-winTopGap-winSideGap;
else
   winHigh=reqHigh+h;
end

% Perform the window resize - triggers callback
winWide=winWide+0.5; % an annoying bug may lose 0.5 on width
winHigh=winHigh+0.5; % an annoying bug may lose 0.5 on height
set(sel3Fig, 'Position', [winSideGap, screenSize(4)-winTopGap-winHigh, winWide, winHigh]);

%=========================================================================
% ACTIVATE
%=========================================================================
% Make figure visible
%------------------------------------------------------------------------
set( sel3Fig, 'Visible','on', 'HandleVisibility','callback' );

%------------------------------------------------------------------------
% Wait for choice to be made (i.e OK button UserData must be assigned)...
%------------------------------------------------------------------------
waitfor(hOkBut,'Userdata');

%------------------------------------------------------------------------
% ...selection has been made. Assign k and delete the Selection figure
%------------------------------------------------------------------------
k = get(hOkBut,'Userdata'); % this is the final tab when ok clicked

result=[];
if k<=0,
   result=[];
elseif selMode(3),
   objValues=get(hData.Tab(k).Object,{'Value'}); % get all btn states on this tab
   [r,c]=size(hData.Tab(k).Object);
   objValues=reshape(cat(2,objValues{:}),r,c);
   [i,j]=find(objValues);                        % get index answers
   result=[i(:),j(:),ones(length(i),1)*k];
else
   for k=1:nTabs,
      objValues=get(hData.Tab(k).Object,{'Value'}); % get all btn states on all tabs
      [r,c]=size(hData.Tab(k).Object);
      objValues=reshape(cat(2,objValues{:}),r,c);
      [i,j]=find(objValues);                      % get index answers
      result=[result;[i(:),j(:),ones(length(i),1)*k]];
   end %for
   
end %if

delete(sel3Fig);

end %switch
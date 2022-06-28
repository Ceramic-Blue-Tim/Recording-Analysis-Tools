function sel = listdlg2( inItems, figId, selMode, inDeft )
%listdlg2   Generate tabbed sets of multi-column lists of choices for user input.
%
%   Selection = listdlg2(ItemStruct) where:
%   ItemStruct is a structure vector (length=no_tabs) containing:
%        .tag - a string tab label
%        .title - a title for the tab page
%        .name - a string cell vector of column names 
%        .list - a cell vector of string cell vectors of choice item names 
%        .mode - selection modes : 0 for mutiple (default) or 1 for single - 
%          Mode=1 -> only 1 from each column, it must have same no cols as .list
%
%   Selection = listdlg2(ItemStruct, Title) where:
%   Title is a string title for the selection window.
%
%   Selection = listdlg2(ItemStruct, Title, Mode) where:
%   Mode is tab selection mode : 0 for mutiple (default) or 1 for single - 
%        i.e. Mode=1 allows a result from only 1 tab.
%
%   Selection = listdlg2(ItemStruct, Title, Mode, Default) where:
%   Default is a structure vector (length=no_tabs) defining the choices 
%        initially selected.
%        Default.index is a cell vector, one cell per column, each listing
%        the indexes of the choices to be set in that column. Use [] for none.
%        Default.tab is an integer index of the tab to which these apply (optional).
%        The form of Default is the same as the function output.
%
%   listdlg2 will display columns of choices in a figure window.
%
%   The choices selected by the user are returned as a structure vector Selection.   
%   The size of Selection is nTab, each element corresponding each tab.
%   Selection.index is a cell vector, one cell per column, each listing
%   the indexes of the choices made from that column. Selection.tab
%   is an integer index of the tab to which these apply - this will match  
%   the index of Selection unless Mode=1.
%   Any [], entries indicate no selection made, Selection.index=[] & 
%   Selection.tab=0 if no selection is made.
%
%   For example:
%       results(1).tag='axes';
%       results(1).title='Choose axes for plot';
%       results(1).name={'x axis';'y axis'};
%       vars={'time';'p1';'p20';'p30';'nh';'nl'};
%       results(1).list={vars,vars};
%       results(1).mode=[1,0];
%       results(2).tag='lines';
%       results(2).title='Choose line styles for plot';
%       results(2).name={'category';'style'};
%       styl={'line style';'colour';'symbols';'style & colour';'symbols & colour';'style & symbols';'all'};
%       results(2).list={{'engine type';'engine build';'test type'},styl};
%       results(2).mode=[0,1];
%       results(3).tag='decimation';
%       results(3).title='Choose marker decimation option';
%       results(3).name={'level'};
%       results(3).list={{'none';'10';'20';'all'}};
%       results(3).mode=1;
%       tit='Select Plot Details';
%       deft(1).index={1,1};
%       deft(2).index={[1;2;3],[1;2;3]};
%       deft(3).index={1};
%       sel = listdlg2(results,tit,1,deft); 
%       xname=vars(sel(1).index(1))
%       ynames=vars(sel(1).index(2))
%
%   See also: LISTDLG, INPUTDLG, TABDLG, selectdlg3, inpdlg.

%   Author: Mike Thomson   4 June 2002 

%-------------------------------------------------------------------------
% Set spacing and sizing constants for the GUI layout
%-------------------------------------------------------------------------
dlgUnits  = 'points'; % units used for all objects
dlgColor   = [0.8,0.8,0.8];
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
textPad = [0,0,10,2];    % extra [0,0,Width,Height] on uicontrols to pad text
listPad = [0,0,20,10];   % extra [0,0,Width,Height] on uicontrols to pad lists
selHigh = 4;

%Extras
okWide      = 40;       % for OK & Cancel buttons
okHigh      = 15;       % for OK & Cancel buttons
allHigh     = 10;       % for select all buttons
scrollWide  = 12;       % 

%Set tab button size
tabButWide=40;
tabButHigh=15;

% Min Object sizes
objWide=30; objHigh=10; objGap=4;

%=========================================================================
% PERFORM CALLBACK ACTION
%=========================================================================
if ischar(inItems)
   fragName=inItems;
else
   fragName='none';
end
switch fragName

case 'lstDlg_allSelect'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   % Which Tab are we in? & which column?
   tab=get( hData.TabSel, 'Userdata' );
   col=find(gcbo==hData.Tab(tab).SelAll);
   
   % Set all list on
   len=get(hData.Tab(tab).Object(col),'Userdata');
   set(hData.Tab(tab).Object(col),'Value',[1:len]);
   
case 'lstDlg_figResize'
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
   
%    if figPos(3)<minWide,
       winWide = max(minWide,figPos(3));
%    else
%       winWide = figPos(3);
%    end %if
   
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
   listdlg2('lstDlg_tabSelect',figId,get(hData.TabSel,'Userdata'));
   
case 'lstDlg_tabSelect'
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
   tFr=get( hData.TabFrame, 'Position');
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

   % Set Scroll positions - use h to indicate slider present
   viewPos=[pwFrameLeft+PnS(3), pwFrameBott, pwFrameWide-PnS(3), pwFrameHigh-PnS(4)-ttSize(2)];
   h=0;
   if PnS(1)>viewPos(3),
      set( hData.Scroll, 'Visible','on' );
      h=scrollWide;
   else
      set( hData.Scroll, 'Visible','off' );
   end
   titOff=viewPos(2)+viewPos(4);
   objOff=max( viewPos(2)+h,  titOff-PnS(2) );
   objResize=max(min(0,viewPos(4)-h-PnS(2)),objHigh-PnS(2));
   set( hData.Scroll, 'Position', [viewPos(1:2), viewPos(3), scrollWide] ,...
                         'Userdata', [objOff,titOff,objResize] ); % Userdata read in lstDlg_scroll

   % Set Scroll parameter values 
   hStp=1;
   hSliMx=PnS(1)-viewPos(3);    % slider value at rhs
   if hSliMx<=0, hSliMx=1; end;
   if (PnS(1)-viewPos(3))>0,
      hStp=(viewPos(3))/(PnS(1)-viewPos(3)); % sets slider knob size
   end
   if hStp<=0, hStp=1; end;
   set( hData.Scroll, 'Max',hSliMx, 'SliderStep',[min(0.1*hStp,1) hStp], 'Value',0);
   
   % Set TabSel Userdata
   set( hData.TabSel, 'Userdata', tab );
   
   % Set TabTitle pars
   pos=[pwFrameLeft,pwFrameBott+pwFrameHigh-ttSize(2),pwFrameWide,ttSize(2)];
   set( hData.TabTitle, 'Position',pos,...
      'String',hData.TabTitTx{tab});
   
   % Set TitFrame positions
   clear pc; % reset size
   pc{1}=[pwFrameLeft, pwFrameBott, PnS(3), tabGap+h];
   pc{2}=[pwFrameLeft, viewPos(2)+viewPos(4), PnS(3), PnS(4)];
   pc{3}=[viewPos(1)+viewPos(3), viewPos(2)+viewPos(4), tabGap, PnS(4)];
   set( hData.TitFrame, {'Position'}, pc' );
   
   % Make previous Tab's objects invisible if it's not this one (resizing)
   if oldtab~=tab,
      set(hData.Tab(oldtab).Object,{'Visible'},{'off'});
      set(hData.Tab(oldtab).SelAll,{'Visible'},{'off'});
      set(hData.Tab(oldtab).CTitle,{'Visible'},{'off'});
      set(hData.TabButton(oldtab), 'Background',dlgColor);
   end %if
   
   % Make this Tab's objects visible
   set(hData.Tab(tab).Object,{'Visible'},{'on'});
   set(hData.Tab(tab).SelAll,{'Visible'},{'on'});
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
	listdlg2('lstDlg_scrollTabs',figId);
   
   % Reset the objects positions
   listdlg2('lstDlg_scroll',figId);
   
case 'lstDlg_scrollTabs'
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
   
case 'lstDlg_scroll'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   % Which Tab are we in? (in fact it might be better to store these in hData)
   tab=get( hData.TabSel, 'Userdata' );
   PnS=get(hData.TabButton(tab),'Userdata'); % [panelWide;panelHigh;pnlRTWide;pnlCTHigh]
   htOff=get(hData.Scroll,'Userdata'); % for panel height positioning
   
   % Get object positions wrt fig & wrt panel
   ObjPos=hData.Tab(tab).oPos;
%   SelPos=hData.Tab(tab).bPos;
   
   % Get horiz scroll value
   sclH=get(hData.Scroll, 'Value');
   
   % Set panel offsets
   pnlOff=[PnS(3)+pane1Gap-sclH htOff(1) 0 htOff(3)];
   
   % Set Object positions
   pos=[ObjPos + ones(size(ObjPos,1),1)*pnlOff ];
   set( hData.Tab(tab).Object, {'Position'}, num2cell(pos,2) );
   set( hData.Tab(tab).SelAll, {'Position'}, num2cell([pos(:,1),pos(:,2)-objGap-allHigh,pos(:,3),pos(:,4)*0+allHigh,],2) );
   
   % Get title positions wrt fig &  wrt panel & set Title positions
   if ~isempty(hData.Tab(tab).CTitle),
      CTPos=hData.Tab(tab).ctPos;
      pos=num2cell( [CTPos + ones(size(CTPos,1),1)*[pnlOff(1),htOff(2),0,0] ] ,2);
      set( hData.Tab(tab).CTitle, {'Position'}, pos );
   end

case 'lstDlg_OkClick'
   % Get handle data
   hData=get(figId, 'Userdata');
   
   % Which Tab are we in?
   tab=get( hData.TabSel, 'Userdata' );
   
   % Set OK button Userdata to trigger dialog completion
   set(gcbo,'Userdata',tab);
   
case 'lstDlg_CnlClick'
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
% Check ItemStruct sizes
%-------------------------------------------------------------------------
if ~isstruct(inItems),
   error('A structure is expected as the ItemStruct.');
end
nTabs=length(inItems);
strItems=inItems;

% Check fields
if ~isfield(strItems,'tag'),
   strItems(1).tag={''};      %  if necessary use deal to assign all values
end

% Tab titles
if ~isfield(strItems,'title'),
   strItems(1).title={''};
end

% Choice items
if ~isfield(strItems,'list'),
   error('Your Item Structure must have a ''list'' field.');
else
   for t=1:nTabs,
      nCols(t)=length(strItems(t).list(:));
   end
end

% Column names
if ~isfield(strItems,'name'),
   for t=1:nTabs,
      strItems(t).name=cell(nCols(t),1);
   end
else
   for t=1:nTabs,
      if length(strItems(t).name)~=nCols(t), 
         error(['The ItemStruct.name(' int2str(t) ') should be ' int2str(nCols(t)) ' items long.']); 
      end;
   end
end

% Column modes
if ~isfield(strItems,'mode'),
   for t=1:nTabs,
      strItems(t).mode=zeros(1,nCols(t));
   end
else
   for t=1:nTabs,
      if length(strItems(t).mode)~=nCols(t), 
         error(['The ItemStruct.mode(' int2str(t) ') should be ' int2str(nCols(t)) ' items long.']); 
      end;
   end
end

%-------------------------------------------------------------------------
% Set defaults for p2 - p4
%-------------------------------------------------------------------------
if nargin<2,
   figId='List Dialog';
end
if nargin<3,
   selMode=0;
end
iniTab=1;  %Set default initial tab selected
if nargin<4,
   for t=1:nTabs,
      selDeft(t).index=cell(1,nCols(t));
   end
else
   if ~isfield(inDeft,'tab') & length(inDeft)~=nTabs,
      error('Wrong Default size');
   elseif ~isfield(inDeft,'tab'),
      selDeft=inDeft;
   else
      if length(inDeft)==1,
         iniTab=inDeft.tab;  %Set initial tab selected
      end
      % Go 1:nTabs assigning defts
      for t=1:nTabs,
         %find .tab==t, else set zeros
         i=find(cat(1,inDeft.tab)==t);
         if isempty(i),
            selDeft(t).index=cell(1,nCols(t));
         else
            selDeft(t).index=inDeft(i).index;
         end%if
      end%for
   end%if
end%if

%-------------------------------------------------------------------------
% Check Default sizes against Mode
%-------------------------------------------------------------------------
% Are there enough cols, any indexes too high?
% For each tab, if .mode==1, use only first & must have a value
for t=1:nTabs,
   if length(selDeft(t).index(:))~=nCols(t), error('Wrong Default size'); end;
   for c=1:nCols(t),
      % Discard any index out of range
      outRange=find(selDeft(t).index{c}>length(strItems(t).list{c}(:)));
      selDeft(t).index{c}=setdiff(selDeft(t).index{c},selDeft(t).index{c}(outRange));
      % Check with mode
      if strItems(t).mode(c)==1, 
         if isempty(selDeft(t).index{c}),
            selDeft(t).index{c}=1;
         else
            selDeft(t).index{c}=selDeft(t).index{c}(1); 
         end;
      end;
   end
end

%=========================================================================
% BUILD THE GUI
%=========================================================================
% Create a generically-sized invisible figure window
%-------------------------------------------------------------------------
% Note that this needs to be invisible at first & will be moved & shown later on.
inoutFig = figure('Units'      ,dlgUnits, ...
                  'NumberTitle'  ,'off', ...
                  'IntegerHandle','off', ...
                  'MenuBar'      ,'none',...
                  'Name'         ,figId, ...
                  'Visible'      ,'off', ...
                  'Color'        ,tabColor,...
                  'Colormap'     ,[]);

%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% Add contents of the scrolled panels 
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% Make the nCols choice lists per tab
%------------------------------------------------------------------------
for t=1:nTabs,
	%listText=strItems{t+1};
   hChoice=[];
	for c=1:nCols(t),
		hChoice(c) = uicontrol( ...
                    'Style'     ,'listbox',...
                    'Units'     ,dlgUnits, ...
                    'Min'       ,0, ...
                    'Max'       ,2, ...
                    'Value'     ,selDeft(t).index{c}, ...
                    'Userdata'  ,length(strItems(t).list{c}), ...
                    'String'    ,strItems(t).list{c} );
	end %For
%                    'Min'       ,strItems(t).mode(c), ...
   
   
	% Store the contents object handles in a structure
	hTab(t).Object=hChoice;

	% Get Extent for later - Min effects the mode which affects Extent
	oExtTexts{t} = get( hChoice, {'Extent'} );   % get extent 
   % Set the Mode with Min
   set( hChoice, {'Min'}, num2cell(strItems(t).mode') );

end %For

%------------------------------------------------------------------------
% Add the select-all buttons
%------------------------------------------------------------------------
onOff={'on';'off'};
for t=1:nTabs,
	for c=1:nCols(t),
      hSelAll(c)=uicontrol( ...
                    'Style'     ,'pushbutton',...
                    'Units'     ,dlgUnits, ...
                    'Enable'    ,onOff{strItems(t).mode(c)+1}, ...
                    'Callback'  ,'listdlg2(''lstDlg_allSelect'',gcbf);', ...
                    'String'    ,'Select all' );
	end %For   
   
	% Store the contents object handles in a structure
	hTab(t).SelAll=hSelAll;

end %For

%------------------------------------------------------------------------
% Add the scroll sliders
%------------------------------------------------------------------------
% Note that these will be sized & positioned later on.

hScrollH = uicontrol(...
         'Style','slider',...
         'Units',dlgUnits, ...
         'Min',0,'Max',1 ,...
         'Value',0 , ...
         'Callback','listdlg2(''lstDlg_scroll'',gcbf);',...
         'SliderStep',[0.1 1]);

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

for t=1:nTabs,
   
% Make the Col titles - even if empty
hTitleCol=[]; % re-initialise for this tab
for c = 1 : nCols(t),
   hTitleCol(c) = uicontrol( ...
     'Style'       ,'text', ...
     'String'      ,strItems(t).name(c), ...
     'Units'       ,dlgUnits, ...
     'Horizontal'  ,'center',...
     'Visible'     ,'off',...
     'Background'  ,tabColor );
end % for
hTab(t).CTitle=hTitleCol; % Store panel title handles in structure

%------------------------------------------------------------------------
% Do full size check for objects & titles
%------------------------------------------------------------------------
%  & set panel titles' & objects' Userdata here
% Object extent sizes
oTexts = oExtTexts{t}; 
oTexts = cat( 1, oTexts{:} );
oWides = oTexts(:,3)';
oHighs = oTexts(:,4);
oMaxWide = max([ones(1,nCols(t))*objWide;oWides])'+ listPad(3);  % calculate the largest width & height
oMaxHigh = max([objHigh;oHighs])+ listPad(4);     % add some blank space around text

% Col Title sizes 
ctTexts = get( hTitleCol, {'Extent'} ); % get ext, convert to nx4 matrix
ctTexts = cat( 1, ctTexts{:} );
ctHigh = max(ctTexts(:,4))+ textPad(4); % one height for all
ctWides = ctTexts(:,3) + textPad(3);    % vector of widths for all
oMaxWide = max(ctWides,oMaxWide);       % stretch prompts if titles large
ctWides = oMaxWide;                     % fit titles if prompts large

% Object Positions
xPos=cumsum( ones(nCols(t),1)*objGap + [0;oMaxWide(1:nCols(t)-1)] );
yPos=2*objGap+allHigh;
hTab(t).oPos=[xPos,ones(nCols(t),1)*yPos,oMaxWide,ones(nCols(t),1)*oMaxHigh]; % List posns
%hTab(t).bPos=[xPos,ones(nCols(t),1)*objGap,oMaxWide,ones(nCols(t),1)*allHigh]; % SelectAll button posns

% Col Title positions
ctPos=[xPos,zeros(nCols(t),1),ctWides,ones(nCols(t),1)*ctHigh];
hTab(t).ctPos=ctPos;     % Store panel title size & pos in structure

% Set panel size for objects & Titles
panelWide(t)=xPos(nCols(t))-xPos(1)+oMaxWide(nCols(t))+2*objGap;
panelHigh(t)=oMaxHigh+3*objGap+allHigh;
pnlRTWide(t)=1; %delete this?
pnlCTHigh(t)=ctHigh;

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

%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% Add rest of the window 
%-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% Define a box for the tab frame
%------------------------------------------------------------------------
hTabFrame(3) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor);  % To frame bottom tab
hTabFrame(4) = uicontrol('Style','frame','Units',dlgUnits, ...
   'Background',dlgColor);  % To frame top tab

%------------------------------------------------------------------------
% Create tab buttons & selector patch etc
%------------------------------------------------------------------------
for t=1:nTabs,
   hTabButton(t)=uicontrol('Units',dlgUnits,...
      'Background',dlgColor,...   
      'Callback'  ,'listdlg2(''lstDlg_tabSelect'',gcbf);', ...
      'Userdata'  ,[panelWide(t),panelHigh(t),pnlRTWide(t),pnlCTHigh(t)],...
      'String'    ,strItems(t).tag );
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
         'Callback','listdlg2(''lstDlg_scrollTabs'',gcbf);',...
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
for t=1:nTabs,
   set(hTabTitle,'String',strItems(t).title); 
   ttSize(t,:)=get(hTabTitle,'Extent') + textPad;
end

%------------------------------------------------------------------------
% Store all handles in a structure for retrieval
%------------------------------------------------------------------------
hData.Tab=hTab;
hData.TabButton=hTabButton;
hData.TabSel=hTabSel;
hData.TabSlide=hTabSlide;
hData.TabTitle=hTabTitle;
hData.TabTitSz=ttSize(:,[3:4]);
[hData.TabTitTx{1:nTabs}]=deal(strItems.title);
hData.PwFrame=hPwFrame;
hData.TitFrame=hTitFrame;
hData.TabFrame=hTabFrame;
hData.Scroll=hScrollH;

%------------------------------------------------------------------------
% Create pane 2
%------------------------------------------------------------------------
hOkFrame=uicontrol('Style','frame','Units',dlgUnits,...
   'Background',dlgColor ,'Foreground',dlgColor );

hOkBut=uicontrol('Units',dlgUnits,...
   'Background',dlgColor,...   
   'Callback'  ,'listdlg2(''lstDlg_OkClick'',gcbf);', ...
   'Userdata'  ,-1,...
   'String'    ,'OK' );

hCnlBut=uicontrol('Units',dlgUnits,...
   'Background',dlgColor,...   
   'Callback'  ,'listdlg2(''lstDlg_CnlClick'',gcbf);', ...
   'String'    ,'Cancel' );

% Set callbacks for figure close & resize
set(inoutFig, 'CloseRequestFcn' ,['listdlg2(''lstDlg_CnlClick'', gcbf);'],...
             'ResizeFcn'       ,['listdlg2(''lstDlg_figResize'',gcbf);']);

%------------------------------------------------------------------------
% Store the handle structure in the figure Userdata
%------------------------------------------------------------------------
hData.Pane2=[hOkFrame, hOkBut, hCnlBut];
set(inoutFig, 'Userdata', hData);

%------------------------------------------------------------------------
% Calculate sizes & set positions
%------------------------------------------------------------------------
% Retrieve screen dimensions (in correct units)
oldUnits = get(0,'Units');         % remember old units
set( 0, 'Units', dlgUnits );       % convert to desired units
screenSize = get(0,'ScreenSize');  % record screensize
set( 0, 'Units',  oldUnits );      % convert back to old units
% Only use top 1/6th of the screen
dlgSize = screenSize./[1,1,3,2];

% Calc max size required - h & v indicate if srolls are required
reqWide = max(max((panelWide+pnlRTWide),ttSize(:,3)')) + pane1Gap*2;
reqHigh = max(panelHigh+pnlCTHigh) + tabButHigh + max(ttSize(:,4)) +...
   pane1Gap*2 + okHigh + pane2Gap*2;

h=0;v=0;
if reqHigh>dlgSize(4)-winTopGap-winSideGap,
   v=scrollWide;
end
if reqWide+v>dlgSize(3)-2*winSideGap,
   winWide=dlgSize(3)-2*winSideGap;
   h=scrollWide;
else
   winWide=reqWide+v;
end

if reqHigh+h>dlgSize(4)-winTopGap-winSideGap,
   winHigh=dlgSize(4)-winTopGap-winSideGap;
else
   winHigh=reqHigh+h;
end

% Perform the window resize - triggers callback
winWide=winWide+0.5; % an annoying bug may lose 0.5 on width
winHigh=winHigh+0.5; % an annoying bug may lose 0.5 on height
set(inoutFig, 'Position', [winSideGap, screenSize(4)-winTopGap-winHigh, winWide, winHigh]);

%=========================================================================
% ACTIVATE
%=========================================================================
% Make figure visible
%------------------------------------------------------------------------
set( inoutFig, 'Visible','on', 'HandleVisibility','callback' );

%------------------------------------------------------------------------
% Wait for choice to be made (i.e OK button UserData must be assigned)...
%------------------------------------------------------------------------
waitfor(hOkBut,'Userdata');

%------------------------------------------------------------------------
% ...selection has been made. Assign k and delete the Selection figure
%------------------------------------------------------------------------
t = get(hOkBut,'Userdata'); % this is the final tab when ok clicked

if t<=0,
   sel.index=[];
   sel.tab=0;
elseif selMode,
   objValues=get(hData.Tab(t).Object,{'Value'}); % get all list states on this tab
   [sel.index{1:nCols(t)}]=deal(objValues{:});
   sel.tab=t;
else
   for t=1:nTabs,
      objValues=get(hData.Tab(t).Object,{'Value'}); % get all list states on all tabs
      [sel(t).index{1:nCols(t)}]=deal(objValues{:});
      sel(t).tab=t;
   end %for
   
end %if

delete(inoutFig);

end %switch
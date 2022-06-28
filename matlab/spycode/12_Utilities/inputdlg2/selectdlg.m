function k = selectdlg( xcItems, xHeader, selMode, selDeft )
%selectdlg   Generate a scrolled column of choices for user selection.
%   Choice = selectdlg(Itemlist) returns the user selection. 
%   Itemlist is a string cell array.
%
%   Choice = selectdlg(Itemlist, Header) 
%   Header is a prompt string displayed at the top of the slection list.
%
%   Choice = selectdlg(Itemlist, Header, Mode) 
%   Mode determines whether the user can make multiple selections
%    - 0 for multiple (default).
%
%   Choice = selectdlg(Itemlist, Header, Mode, Default) 
%   Default is a vector of index(es) to the button(s) initially selected.
%
%   selectdlg displays the items as a column of radio buttons in a 
%   fixed size figure window. The calling process is stopped to await the 
%   user selection. The buttons selected by the user are returned as 
%   Choice, an index into the Itemlist cell array. [] is returned if no 
%   selection is made, or the dialog is cancelled or closed.
%
%   For example:
%       items={'One','Two','Three','Four','Five','Six','Seven','Eight','Nine'};
%       sel = selectdlg(items); 
%       items(sel)
%
%   See also: MENU, LISTDLG, selectdlg2, selectdlg3, listdlg2.

%   Author: Mike Thomson   4 August 2001 

%=========================================================================
% SET UP
%=========================================================================
% Set spacing and sizing parameters for the GUI elements
%-------------------------------------------------------------------------
SelUnits    = 'points'; % units used for all HG objects
textPadding = [18 4];   % extra [Width Height] on uicontrols to pad text
uiGap       = 5;        % space between uicontrols
uiBorder    = 5;        % space between edge of figure and any uicontol
winTopGap   = 35;       % gap between top of screen and top of figure **
winLeftGap  = 15;       % gap between side of screen and side of figure **
okWide      = 40;       % for OK & Cancel buttons
scrollWide  = 12;       % 
minWide     = 2*okWide + 3*uiGap;
guicolor    = [0.7 0.7 0.7];

% ** "figure" ==> viewable figure. You must allow space for the OS to add
% a title bar (aprx 42 points on Mac and Windows) and a window border
% (usu 2-6 points). Otherwise user cannot move the window.

if ischar(xcItems)
   fragName=xcItems;
else
   fragName='none';
end;
switch fragName
   
case 'selDlg_buttonClick'
% If in single selection mode, reset other button(s)
   if selMode>0,
      hBtn=get(gcbf,'UserData');
      set(hBtn, {'Value'}, {0});
      set(gcbo, 'Value', 1);
   end;

case 'selDlg_scrollV'
% Find objects
   scrollV=get(gcbo,'Value');
   hBtn=get(gcbf,'UserData');
   numItems = length(hBtn);
   btnPos = get(hBtn(1),'UserData');
   btnBottGap = uiBorder + uiGap + btnPos(4);
% Calculate button positions
   cUIPos = local_selectPos(numItems,btnPos(3),btnPos(4),scrollV,uiGap,btnPos(1),btnBottGap);
% Adjust all buttons
   set( hBtn, {'Position'}, cUIPos );

case 'selDlg_okClick'
   hBtn=get(gcbf,'UserData');
   btnSet = get(hBtn,{'Value'});
   set(gcbo,'userdata',btnSet);
   
case 'selDlg_cancelClick'
   okBtn=findobj(gcbf,'Tag','okButton');
   set(okBtn,'userdata',{0});
   
otherwise
%-------------------------------------------------------------------------
% set up the slection GUI
%-------------------------------------------------------------------------

% Check input
error(nargchk(1,4,nargin));

% Set defaults
if nargin<2,
   xHeader='Make a selection';
end;
if nargin<3,
   selMode=0;
end;
if nargin<4,
   selDeft=0;
end;

% Check input sizes
if ~iscell(xcItems),
  error('A cell array is expected as the choice list.');
end
[r,c]=size(xcItems);
if r~=1 & c~=1,
   error('The cell array must be a vector.');
end
[r,c]=size(selMode);
if r~=1 | c~=1,
   error('Mode must be a scalar, 1 for multi, 0 for single.');
end;
if iscell(selDeft),
   selDeft=cat(1,selDeft{:});
else
   selDeft=selDeft(:);
end;
if ~selMode & any(selDeft>length(xcItems)),
   error('You can''t have more Defaults than items.');
elseif selMode & length(selDeft)~=1,
   error('When using single-select mode, Default size must be a scalar');
end;
if any(selDeft>length(xcItems)),
   error('A Default value cannot be > number of items.');
end;

cellO=1;
if size(xcItems,1)==1, cellO=2;end;  % to return answer in same orientation as xcItems

%-------------------------------------------------------------------------
% Calculate the number of items in the list
%-------------------------------------------------------------------------
numItems = length( xcItems );

%=========================================================================
% BUILD
%=========================================================================
% Create a generically-sized invisible figure window
%------------------------------------------------------------------------
selFig = figure( 'Units'        ,SelUnits, ...
                 'NumberTitle'  ,'off', ...
                 'IntegerHandle','off', ...
                 'MenuBar'      ,'none',...
                 'Name'         ,'Select Dialog', ...
                 'Resize'       ,'off', ...
                 'Visible'      ,'off', ...
                 'Color'        ,[0.85 0.85 0.85],...
                 'Colormap'     ,[]);

%------------------------------------------------------------------------
% Add generically-spaced buttons below the header text
%------------------------------------------------------------------------
% Loop to add buttons in reverse order (to automatically initialize numitems).
% Note that buttons may overlap, but are placed in correct position relative
% to each other. They will be resized and spaced evenly later on.

for idx = numItems : -1 : 1; % start from top of screen and go down
    n = numItems - idx + 1;  % start from 1st button and go to last
    % make a button
    hBtn(n) = uicontrol( ...
               'Style'     ,'radiobutton',...
               'Units'     ,SelUnits, ...
               'Background',[0.6 0.6 0.6],...
               'Position'  ,[uiBorder uiGap*idx 10 10], ...
               'Callback'  ,['selectdlg(''selDlg_buttonClick'',1,',int2str(selMode),');'], ...
               'String'    ,xcItems{n} );
end % for
for i=1:length(selDeft),
   if selDeft(i), set(hBtn(selDeft(i)),'Value',1); end;
end

set(selFig ,'UserData',hBtn);

%------------------------------------------------------------------------
% Add a couple of frames to define the button area ends (after buttons)
%------------------------------------------------------------------------
hFrame1 = uicontrol(...
	'Units','points', ...
   'BackGround',guicolor,...
	'Style','frame');
hFrame2 = uicontrol(...
	'Units','points', ...
   'BackGround',guicolor,...
	'Style','frame');

%------------------------------------------------------------------------
% Add generically-sized header text with same background color as figure
%------------------------------------------------------------------------
hText = uicontrol( ...
        'Style'       ,'text', ...
        'String'      ,xHeader, ...
        'Units'       ,SelUnits, ...
        'BackGround'  ,guicolor,...
        'Position'    ,[ 100 100 100 20 ], ...
        'Horizontal'  ,'center' );

% Record extent of text string
maxsize = get( hText, 'Extent' );
textWide  = maxsize(3);
textHigh  = maxsize(4);

%=========================================================================
% TWEAK
%=========================================================================
% Calculate Optimal UIcontrol dimensions based on max text size
%------------------------------------------------------------------------
cAllExtents = get( hBtn, {'Extent'} );  % put all data in a cell array
AllExtents  = cat( 1, cAllExtents{:} ); % convert to an n x 4 matrix
maxsize     = max( AllExtents(:,3:4) ); % calculate the largest width & height
maxsize     = maxsize + textPadding;    % add some blank space around text
btnHigh     = maxsize(2);
btnWide     = maxsize(1);

%------------------------------------------------------------------------
% Retrieve screen dimensions (in correct units)
%------------------------------------------------------------------------
oldUnits = get(0,'Units');         % remember old units
set( 0, 'Units', SelUnits );      % convert to desired units
screensize = get(0,'ScreenSize');  % record screensize
set( 0, 'Units',  oldUnits );      % convert back to old units

%------------------------------------------------------------------------
% How many rows and columns of buttons will fit in the screen?
% Note: vertical space for buttons is the critical dimension
% --window can't be moved up, but can be moved side-to-side
%------------------------------------------------------------------------
okGap = uiGap + btnHigh;
openSpace = screensize(4) - 1.5*winTopGap - 2*uiBorder - textHigh - okGap;
numRows = min( floor( openSpace/(btnHigh + uiGap) ), numItems );
if numRows == 0; numRows = 1; end % Trivial case--but very safe to do
buttonSpace = numRows * (btnHigh + uiGap);
panelSpace = numItems * (btnHigh + uiGap);
numCols = ceil( numItems/numRows );
scrollF = 1 + buttonSpace/panelSpace;
scrollV = panelSpace - buttonSpace;

%------------------------------------------------------------------------
% Resize figure to place it in top left of screen
%------------------------------------------------------------------------
% Calculate the window size needed to display all buttons
winHigh = buttonSpace + textHigh + 2*uiBorder + okGap;

% If needed, add the scroll slider
if numRows<numItems,
   winWide = btnWide + 2*uiBorder + scrollWide;
   hScrollV = uicontrol(...
         'Parent',selFig, ...
         'Style','slider',...
         'Units','points', ...
         'Min',0,'Max',scrollV ,...
         'Value',scrollV , ...
         'Callback','selectdlg(''selDlg_scrollV'');',...
         'SliderStep',[0.1*scrollF scrollF]);
else
   winWide = btnWide + 2*uiBorder;
end

% Make sure the text header fits & the footer buttons
winWide = max(winWide,(2*uiBorder + textWide));
winWide = max(minWide,winWide);


% Determine final placement coordinates for bottom of figure window
bottom = screensize(4) - (winHigh + winTopGap);

% Set figure window position
set( selFig, 'Position', [winLeftGap bottom winWide winHigh] );

%------------------------------------------------------------------------
% Size uicontrols to fit everyone in the window and see all text
%------------------------------------------------------------------------
% Position scroll slider if it's there
if numRows<numItems,
   set( hScrollV, 'Position',[winWide-scrollWide okGap+uiBorder scrollWide buttonSpace-uiGap] );
end

% Calculate button offset data for centralised buttons
btnLeftGap = (winWide - btnWide)/2 - uiBorder;
btnBottGap = uiBorder + okGap;

% Calculate button positions
cUIPos = local_selectPos(numItems,btnWide,btnHigh,scrollV,uiGap,btnLeftGap,btnBottGap);

% Adjust all buttons
set( hBtn, {'Position'}, cUIPos );
set( hBtn(1), 'UserData', cat(1,cUIPos{1,:}) );

%------------------------------------------------------------------------
% Align the Text and Buttons horizontally and distribute them vertically
%------------------------------------------------------------------------

% Calculate placement position of the Header
textWide = winWide - 2*uiBorder;

% Move Header text into correct position near the top of figure
set( hText, ...
   'Position', [ uiBorder winHigh-uiBorder-textHigh textWide textHigh ] );

% Position frames
set( hFrame1, ...
   'Position',[0 0 winWide okGap+uiBorder])
set( hFrame2, ...
   'Position',[0 okGap+uiBorder+buttonSpace-uiGap winWide textHigh+uiBorder+uiGap])

%------------------------------------------------------------------------
% Add in the OK and Cancel buttons
%------------------------------------------------------------------------
okSpace=(winWide-2*(okWide+uiBorder)-uiGap)/3; % Extra space if text or buttons are wider
okBtn = uicontrol( ...
           'Units'          ,SelUnits, ...
           'Position'       ,[uiBorder+okSpace uiBorder okWide btnHigh], ...
           'Callback'       ,'selectdlg(''selDlg_okClick'');', ...
           'Tag'            ,'okButton',...
           'String'         ,'OK' );

CancelBtn = uicontrol( ...
           'Units'          ,SelUnits, ...
           'Position'       ,[uiBorder+uiGap+okWide+okSpace*2 uiBorder okWide btnHigh], ...
           'Callback'       ,'selectdlg(''selDlg_cancelClick'');', ...
           'String'         ,'Cancel' );

%=========================================================================
% ACTIVATE
%=========================================================================
% Set callbacks for figure close
%------------------------------------------------------------------------
set(selFig, 'CloseRequestFcn' ,['selectdlg(''selDlg_cancelClick'');']);

%------------------------------------------------------------------------
% Make figure visible
%------------------------------------------------------------------------
set( selFig, 'Visible','on', 'HandleVisibility','callback' );

%------------------------------------------------------------------------
% Wait for choice to be made (i.e OK button UserData must be assigned)...
%------------------------------------------------------------------------
waitfor(okBtn,'userdata');

%------------------------------------------------------------------------
% ...selection has been made. Assign k and delete the Selection figure
%------------------------------------------------------------------------
celldata = get(okBtn,'userdata');
k=find(cat(cellO,celldata{:}));

delete(selFig)

end; %switch

%#########################################################################
%   END   :  main function selectdlg
%#########################################################################

function cUIPos = local_selectPos(numItems,btnWide,btnHigh,scrollV,uiGap,btnLeftGap,btnBottGap)

% Calculate coordinates of bottom-left corner of all buttons
xPos = btnLeftGap + ones(numItems,1); % all in a column
yPos = btnBottGap + [numItems-1:-1:0]'*( btnHigh + uiGap ) - scrollV; % one column

% Combine with desired button size to get a cell array of position vectors
allBtn   = ones(numItems,1);
uiPosMtx = [ xPos(:), yPos(:), btnWide*allBtn, btnHigh*allBtn ];
cUIPos   = num2cell( uiPosMtx( 1:numItems, : ), 2 );

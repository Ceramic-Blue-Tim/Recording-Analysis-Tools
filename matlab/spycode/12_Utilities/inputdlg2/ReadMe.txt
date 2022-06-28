dispdlg		Scrolled window displaying data
selectdlg	Scrolled column of radio buttons
selectdlg2	Scrolled matrix of radio buttons
selectdlg3	Tabbed scrolled window of radio buttons
listdlg2	Tabbed window with rows of input lists
inputdlg2	Scrolled matrix of input edit boxes


I developed these GUI dialogs as an exercise in learning about GUI programming in Matlab.
In particular I wanted to explore ways to produce general dialogs with scroll bars and tabs 
in a re-sizeable window.

I don't suppose selectdlg & selectdlg2 have any real useful advantage over menu.
Likewise inputdlg2 doesn't offer much more than listdlg.

selectdlg3 & listdlg2 have tabs & I have found these of some use.

dispdlg can only be used to display relatively small amounts of data. 

inpdlg is another function available from Matlab Central.


To use the functions put them anywhere on the Matlab search path.

To use the custom help files: 
  If you don't already have custom help:
    copy the contents of "userhelp.zip" into "...\MATLAB6p?\userhelp"; 
    move the file "...\MATLAB6p?\userhelp\customerdoc.xml" to "...\MATLAB6p?\help\customerdoc.xml";
    restart matlab and you should find the user help files available in the Matlab Help 
    window, Help Navigator pane, at the bottom of the Contents tab.

  If you already use the custom help:
    edit your "...\MATLAB6p?\userhelp\customerdoc.xml" file to include reference to the 
    provided html files.

function closeGUI(h)
selection = questdlg('Close This GUI?',...
    'Close Function',...
    'Yes','No','Yes');
switch selection,
    case 'Yes',
        close(h)
    case 'No'
        return
end
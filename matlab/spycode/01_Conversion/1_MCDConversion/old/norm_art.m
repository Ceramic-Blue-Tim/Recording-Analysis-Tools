function []=norm_art(start_folder)

%NOMR_ART.m
%function for assigning right artifact time stamp to all channels belonging
%to the same experiment phase when stimulating from a pair of electrodes

%it's useful for constructing PSTH when stimulation
%is delivered throught 2 channels and thus artifacts are localized
%spatially and are evident for some electrode raw data and not for some
%other


%get the folder containing peak detection and the rigth number of artifact
%to be found
start_folder = uigetdir(pwd,'Select the destination folder');
if  strcmp(num2str(start_folder),'0')
    display ('End Of Function')
    return
end
prompt={'Number of artifacts to be found','Minimum distance between two artifact',...
        'Does any experiment phase keep the same artifact information? ''Y''=YES,''N''=NO'};
title='ARTIFACT INFORMATION';
lines=1;
default={'30','4.5','Y'};
answer=inputdlg(prompt,title,lines,default);
n_art=str2num(answer{1,1});
d_art=str2num(answer{2,1});
k_art=answer{3,1};
if (isempty(d_art)) || (isempty(n_art)) || ~xor(strcmp(k_art,'Y') , strcmp(k_art,'N'))
    msgbox('Error inserting artifact information','WARNING','error');
    return
end
redefine=0;
cd(start_folder);
p_fold_content=dir;
i=3;
while i~=length(p_fold_content)+1       %CYCLE ON PTRAIN FOLDERS
    cd(start_folder);
    p_fold=p_fold_content(i).name;
    if strcmp(k_art,'N') || redefine==1                  
        prompt={[p_fold ' - Number of artifact'],[p_fold '- Minimum distance']};
        title='REDEFINE ARTIFACT INFORMATION';
        lines=1;
        default={num2str(n_art),num2str(d_art)};
        answer=inputdlg(prompt,title,lines,default);
        n_art=str2num(answer{1,1});                
        d_art=str2num(answer{2,1});
        redefine=0;
    end
    cd(p_fold);
    p_file_content=dir;
    for j=3:length(p_file_content)  %CYCLE ON PTRAIN FILES
        wrong=0;
        p_file=p_file_content(j).name;
        load(p_file);              
        clear peak_train
        if length(artifact)~=n_art && j~=length(p_file_content)
            continue
        elseif length(artifact)~=n_art && j==length(p_file_content)
            h=warndlg('No right artifact array found. Please click ''OK'' to redefine parameters','WARNING!!');
            waitfor(h,'KeyPressFcn');
            redefine=1;
            break
        end
        for k=1:length(artifact)-1
            dist=artifact(k+1)-artifact(k);
            if dist<d_art, wrong=1; break, end
        end
        if wrong && j~=length(p_file_content)
            continue
        elseif wrong && j==length(p_file_content)
            h=warndlg('No right artifact array found. Please click ''OK'' to redefine parameters','WARNING!!');
            waitfor(h,'KeyPressFcn');
            redefine=1;
            break
        end
        right=artifact;
        for h=3:length(p_file_content)            %cycle for copying the right artifact array in all files
            p_file=p_file_content(h).name;
            load(p_file);
            artifact=right;
            save(p_file,'peak_train','artifact');
        end
        i=i+1;
        break
    end
end
clear answer n_art d_art k_art p_fold_content p_fold p_file_content wrong p_file dist right artifact redefine i j k h

function[Pos_extracted_spikes, Neg_extracted_spikes]=spike_sorting(Fs, time_ms, num_electrode, Pos_all_spikes, Neg_all_spikes, HP_Signal_fix, analyze_num)
tl=length(time_ms);
H_signal=zeros(tl,num_electrode);
time=[2: -0.05: -1];
t = rot90(time);
Pos_extracted_spikes={};
Neg_extracted_spikes={};
%Spike sorting

for i=1:num_electrode
    H_signal=HP_Signal_fix(:, i);   
    poslocs=Pos_all_spikes{i,1};
    c_pos = length(poslocs);
    tt = length(t);

    if c_pos>analyze_num
        c_pos=analyze_num;
    end
    HP_pos_all_spikes=zeros(tt, c_pos );

    
    for k =1:c_pos 
        T1=(poslocs(k)*Fs)-20;
        T2=(poslocs(k)*Fs)+40;
        if T1>0
            H_extract = H_signal(T1:T2);
            HP_pos_all_spikes(: , k)= +H_extract;
            
        else
        end
   
    end
    
    Pos_extracted_spikes{i,1}=HP_pos_all_spikes;

end

for i=1:num_electrode
    
    H_signal=HP_Signal_fix(:, i);   
    neglocs=Neg_all_spikes{i,1};
    c_neg = length(neglocs);
    tt = length(t);
   
   
    if c_neg>analyze_num
        c_neg=analyze_num;
    end
     HP_neg_all_spikes=zeros(tt, c_neg );
    for l =1:c_neg
        T1=(neglocs(l)*Fs)-20;
        T2=(neglocs(l)*Fs)+40;
        if T1>0 
            H_extract = H_signal(T1:T2);
            HP_neg_all_spikes(: , l)= +H_extract;
                       
        else
        end
    end
    
    Neg_extracted_spikes{i,1}=HP_neg_all_spikes;
end

function [con_xhfd]=h_fractal_dimension(LP_Signal_fix, bin ,bin_d, electrode, kmax)
%function xhfd=hfd(x,kmax)
%Input:
%x: (either column or row) vector of length N
%kmax: maximum value of k
%Output:
%xhfd: Higuchi fractal dimension of x


 fig1 = figure;
 fig1.PaperUnits      = 'centimeters';
    fig1.Units           = 'centimeters';
    fig1.Color           = 'w';
    fig1.InvertHardcopy  = 'off';
    fig1.Name            = ['#', num2str(electrode),' fractal D'];
    fig1.DockControls    = 'on';
    fig1.WindowStyle    = 'docked';
    fig1.NumberTitle     = 'off';
    set(fig1,'defaultAxesXColor','k');
    figure(fig1);

x_single=LP_Signal_fix(:, electrode);
x_lim=reshape(x_single, [], bin);
X_lim{1, 1}=x_lim;

for k=1:bin_d

temp_x_lim= circshift(x_lim,-k,2);
X_lim{k+1, 1}=temp_x_lim;
end
X_lim_mat=cell2mat(X_lim);
for rep=1:bin_d
X_lim_mat_size=size(X_lim_mat, 2);
X_lim_mat(:, X_lim_mat_size)=[];
end


for t=1:bin-bin_d

x= X_lim_mat(:, t);

if ~exist('kmax','var')||isempty(kmax)
    kmax=5;
end

x=x(:)';
N=length(x);

Lmk=zeros(kmax,kmax);
for k=1:kmax
    for m=1:k
        Lmki=0;
        for i=1:fix((N-m)/k)
            Lmki=Lmki+abs(x(m+i*k)-x(m+(i-1)*k));
        end
        Ng=(N-1)/(fix((N-m)/k)*k);
        Lmk(m,k)=(Lmki*Ng)/k; % Here is the problem in the code by Mr. Tikkuhirvi & Mr. Aino
    end
end

Lk=zeros(1,kmax);

for k=1:kmax
    Lk(1,k)=sum(Lmk(1:k,k))/k;
end

lnLk=log(Lk);
lnk=log(1./[1:kmax]);

b=polyfit(lnk,lnLk,1);
xhfd=b(1);


con_xhfd(t, 1) =xhfd;

end

subplot(211);
plot(x_single);

subplot(212)
plot(con_xhfd);

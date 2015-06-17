close all;

% Test the modulated signal with AGWN

% Create AWGN Signal for both the DSSS and DSB-LC 

n = length(dsblc_mod_sig); 
white_noise = randn(1,n);
% normalize
white_noise = white_noise/max(abs(white_noise));
t = tc(1:n);

figure('Color', [1 1 1]);
plot(t,white_noise)
xlabel('Time (sec)');
ylabel('x(t)');
title('AWGN');

figure('Color', [1 1 1]);
for m = 1:5
    AWGN_DSSS(m,:) = (m)*white_noise + dsblc_mod_sig;
    [MAGA f] = ComputeSpectrum(AWGN_DSSS(m,:),fs,2^16);
    
end


output = [];
for m = 1:5
    display(sprintf(['AWGN_DSSS with Noise at ', num2str(m)]));
    output(m,:) = SYNCH_DEMOD(t,AWGN_DSSS(m,:),blmod_sig,carrier,fs,700,50,1000,filt_order);
    info_sig = Despread(t,output(m,:),prbn,encode,bitres,true);
    
end

for m = 1:5
    subplot(5,1,m);
    plot(info_sig);
    xlabel('Time (s)');
    ylabel('Bit Values');
    title(sprintf(['DSSS Demoluated w/ SNR of ',num2str(m)]));
    %ylim([0 500]);
end
saveas(gcf,'./images/awgn_dsss','png');
% Receive the signal and analyze it for errors


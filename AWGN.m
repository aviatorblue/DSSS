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
    subplot(5,1,m);
    plot(f,MAGA);
    xlabel('Frequency (Hz)');
    ylabel('|X(f)|');
    title('AWGN-DSSS FFT');
    ylim([0 500]);
end
saveas(gcf,'./images/awgn_dsss','png');

figure('Color', [1 1 1]);
for m = 1:5
    AWGN_DSBLC(m,:) = (m)*white_noise + dsblc;
    [MAGA f] = ComputeSpectrum(AWGN_DSBLC(m,:),fs,2^16);
    subplot(5,1,m);
    plot(f,MAGA);
    xlabel('Frequency (Hz)');
    ylabel('|X(f)|');
    title('AWGN-DSB-LC FFT');
    ylim([0 500]);
end
saveas(gcf,'./images/awgn_dsblc','png');

for m = 1:5
    display(sprintf(['AWGN_DSSS with Noise at ', num2str(m)]));
    output = SYNCH_DEMOD(t,AWGN_DSS(m,:),blmod_sig,carrier,fs,700,50,1000,filt_order);
    info_sig = Despread(t,output,prbn,encode,bitres,true);
    
    display(sprintf(['AWGN_DSBLC with Noise at ', num2str(m)]));
    output = SYNCH_DEMOD(t,AWGN_DSBLC(m,:),signal,carrier,fs,700,50,1000,filt_order);
    info_sig = Despread(t,output,prbn,encode,bitres,false);
end
% Receive the signal and analyze it for errors

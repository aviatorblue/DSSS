close all;

% Modulate the signal
fc = 500; % 1 MHz
[tc Tp] = create_signal(fc,fs,len);
A = abs(max(encode));
carrier = cos(2*pi*tc/Tp);
carrier = carrier(1:length(encode));

A = abs(max(encode));
dsblc = (encode + A).*carrier;

% Test the modulated signal with AGWN

% Create AWGN Signal for both the DSSS and DSB-LC 

n = length(dsblc_mod_sig); 
white_noise = randn(1,n);
t = tc(1:n);

figure('Color', [1 1 1]);
plot(t,white_noise)
xlabel('Time (sec)');
ylabel('x(t)');
title('AWGN');

for m = 1:5
    AWGN_DSS(m,:) = (m)*white_noise + dsblc_mod_sig;
    [MAGA f] = ComputeSpectrum(AWGN_DSS(m,:),fs,2^16);
    figure('Color', [1 1 1]);
    subplot(2,1,1);
    plot(t,AWGN_DSS(m,:))
    xlabel('Time (sec)');
    ylabel('x(t)');
    title('AWGN-DSS');
    subplot(2,1,2);
    plot(f,MAGA);
    xlabel('Frequency (Hz)');
    ylabel('|X(f)|');
    title('AWGN-DSS FFT');
    display(sprintf(['AWGN_DSS with Noise at ', num2str(m)]));
    output = SYNCH_DEMOD(t,AWGN_DSS(m,:),blmod_sig,carrier,fs,1400,50,2000,filt_order);
    info_sig = Despread(t,AWGN_DSS(m,:),prbn,encode,bitres,true);

    
    AWGN_DSBLC(m,:) = (m)*white_noise + dsblc_mod_sig;
    [MAGA f] = ComputeSpectrum(AWGN_DSBLC(m,:),fs,2^16);
    figure('Color', [1 1 1]);
    subplot(2,1,1);
    plot(t,AWGN_DSBLC(m,:))
    xlabel('Time (sec)');
    ylabel('x(t)');
    title('AWGN-DSB-LC');
    subplot(2,1,2);
    plot(f,MAGA);
    xlabel('Frequency (Hz)');
    ylabel('|X(f)|');
    title('AWGN-DSB-LC FFT');
    display(sprintf(['AWGN_DSS with Noise at ', num2str(m)]));
    output = SYNCH_DEMOD(t,AWGN_DSBLC(m,:),dsblc,carrier,fs,1400,50,2000,filt_order);
    info_sig = Despread(t,AWGN_DSBLC(m,:),prbn,encode,bitres,false);

end



% Receive the signal and analyze it for errors


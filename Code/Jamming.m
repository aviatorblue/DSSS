% Jamming

% Create High Power signals in the spectrum of interest

[tc Tp] = create_signal(x,fs,len);
jam = cos(2*pi*tc/Tp);
jamout= jam(1:length(encode));

n = length(dsblc_mod_sig); 
white_noise = randn(1,n);
% normalize
white_noise = white_noise/max(abs(white_noise));
t = tc(1:n);

jam = jamout.*white_noise;

overall = dsblc_mod_sig + jam;

[MAGA f] = ComputeSpectrum(overall,fs,2^16);

figure('Color',[1 1 1]);
plot(f,MAGA);
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
title('DSSS Signal with Jamming');
ylim([0 500]);
saveas(gcf,'./images/jamming','png');

output = SYNCH_DEMOD(t,overall,blmod_sig,carrier,fs,700,50,1000,filt_order);

% Receive the signal and analyze it for errors

info_sig = Despread(t,output,prbn,encode,bitres,true);

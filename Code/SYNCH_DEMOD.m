function output = SYNCH_DEMOD(t,phi,sampled_signal,csig,fs,f0,fn,fp,filt_order)
% Synchronous Demodulation: This section takes and synchronously demodulates the signal ploting the 
% new signal in the temporal and frequency domain. 

y = phi.*csig;

[X f] = ComputeSpectrum(y,fs,2^20);

figure('Color',[1 1 1]);
subplot(2,1,1);
plot(t,y);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Synchronous Detection Signal');
subplot(2,1,2);
plot(f,X);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Synchronous Detection Signal Spectrum');
xlim([fn fp]);

% After Filtering SD: Behavior of the square law detector after the filter.

Wn = f0/(fs/2);
filter = fir1(filt_order,Wn,'low');
figure('Color',[1 1 1]);
freqz(filter);
xlim([0 4*f0/fs]);
new_sig = filtfilt(filter,1,y);
[X f] = ComputeSpectrum(new_sig,fs,2^20);

figure('Color',[1 1 1]);
subplot(2,1,1);
plot(t,new_sig);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Filtered Synchronous Detection Signal');
subplot(2,1,2);
plot(f,X);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Filtered Synchronous Detection Signal Spectrum');
xlim([fn fp]);

% Comparision SD: This section takes and compares the filtered signal with the original and
% provides an error based on that comparision.

%sampled_signal = window.*mt;
filter = fir1(filt_order,fn*2/fs,'high');
output = filtfilt(filter,1,new_sig);
atten = max(output);
orig = max(sampled_signal);
output = (orig/atten)*output;
plotgraph(t,output,'ro','Time (sec)','Amplitude',...
          'Comparison of Two Signals');
hold on;
plot(t,sampled_signal);
legend('Demod','Original');

% FFT Comparison SD: This section takes and compares the filtered signal with the original in
% the frequency domain.

[H f] = ComputeSpectrum(output,fs,2^16);
[X f] = ComputeSpectrum(sampled_signal,fs,2^16);

plotgraph(f,H,'ro','Frequency (Hz)','Amplitude',...
          'Comparison of Two Signals in the Frequency Domain');
hold on;
plot(f,X);
xlim([fn fp]);
legend('Demod','Original');


end


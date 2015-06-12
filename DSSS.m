%% EE 401: DSSS Final Project
%
% This script aims at generating an information signal from intelligent
% data and transfer the data using DSSS and recreating the data and
% comparing the original signal to the final signal. Note all frequencies
% are in MHz

clear all; close all; clc;
format short

% Create DSSS signal
run DSSS_signal_generation;

filt_order = round(length(mod_sig)/3-1);

% Bandlimit the signal

Wn = [0.2,0.4];
filter = fir1(filt_order,Wn,'bandpass');
figure('Color',[1 1 1]);
freqz(filter);
xlim([0 fs/2]);
blmod_sig = filtfilt(filter,1,mod_sig);

figure('Color',[1 1 1]);
plot(t,blmod_sig,'r');
title('Testing');
ylim([0 2]);

% Modulate the signal
fc = 1500; % 1 MHz
[tc Tp] = create_signal(fc,fs,len);
A = abs(max(encode));
carrier = cos(2*pi*tc/Tp);
carrier = carrier(1:length(encode));

A = abs(max(encode));
dsblc_mod_sig = (blmod_sig + A).*carrier;

[X f] = ComputeSpectrum(dsblc_mod_sig,fs,2^16);

figure('Color',[1 1 1]);
subplot(2,1,1);
plot(t,dsblc_mod_sig);
title('DSB-LC Modulate Signal');
subplot(2,1,2);
plot(f,X);
title('DSB-LC Modulate Signal FFT');

output = SYNCH_DEMOD(t,dsblc_mod_sig,blmod_sig,carrier,fs,1400,0,2000,filt_order);

% Receive the signal and analyze it for errors

Despread(t,output,prbn,encode,bitres);

% Generate DSB-LC AM signal for comparision

%run AWGN;

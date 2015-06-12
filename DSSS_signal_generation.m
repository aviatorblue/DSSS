% Develope Data Signal

string = 'Four score and seven years ago our fathers brought forth on ';
string = [string,'this continent, a new nation, conceived in Liberty, and '];
string = [string,'dedicated to the proposition that all men are created equal.'];


% Convert ASCII characters to Binary Strings
data = [];
for x = 1:length(string)
    bit = dec2bin(string(x),8);
    data = [data,bit];
end

%data = ['0','1','0','1','0','1'];
% Encode the signal for voting
bitres = 11;
encode = [];
for n = 1:length(data)
    if data(n) == '0'
        encode = [encode,zeros(1,bitres)];
    elseif data(n) == '1'
        encode = [encode,ones(1,bitres)];
    end
end

len = length(encode);

% Creating a pseudoradom binary sequence

reps = len;
div = len/reps;

pseudo = rand(1,len);

for x = 1:len/div
    if pseudo(x) >= 0.5 && pseudo(x) <= 1.0
        pseudo(x) = -1;
    elseif pseudo(x) >= 0  && pseudo(x) < 0.5
        pseudo(x) = 1;
    end
end

prbn = [];
for x = 1:div
   prbn = [prbn,pseudo];
end

% Plot the information signal

% Time plotting

fs = 6000; % ~2 GHz
factor = 1;
tend = len/fs;
tscale = tend*factor;
t = linspace(0,len/fs,len);

figure('Color',[1 1 1]);
subplot(2,1,1);
stairs(t*factor,encode);
xlim([0 tscale]);
ylim([0 2]);
xlabel('Time (\mus)');
ylabel('Logical True/False');
title('Encoded Information Signal');
subplot(2,1,2);
stairs(t*factor,encode);
ylim([0 2]);
xlim([tscale/2 2*tscale/3]);
xlabel('Time (\mus)');
ylabel('Logical True/False');
title('Encoded Information Signal');
saveas(gcf,'./encoded_signal','png');

[EN f] = ComputeSpectrum(encode,fs,2^20);

figure('Color',[1 1 1]);
stairs(f/factor,EN);
xlabel('Frequency (kHz)');
ylabel('Amplitude');
title('Encoded Information Signal Spectrum');
saveas(gcf,'./encoded_signal_fft','png');

% Plot the psuedo set

figure('Color',[1 1 1]);
subplot(2,1,1);
plot(t*factor,prbn);
xlim([0 tscale]);
ylim([-2 2]);
xlabel('Time (\mus)');
ylabel('Logical True/False');
title('Pseudorandom Binary Signal');
subplot(2,1,2);
stairs(t*factor,prbn);
ylim([-2 2]);
xlim([tscale/2 4*tscale/7]);
xlabel('Time (\mus)');
ylabel('Logical True/False');
title('Pseudorandom Binary Signal');
saveas(gcf,'./pseudo_signal','png');

[EN f] = ComputeSpectrum(pseudo,fs,2^20);

figure('Color',[1 1 1]);
stairs(f/factor,EN);
xlabel('Frequency (MHz)');
ylabel('Amplitude');
title('Pseudorandom Binary Signal Spectrum');
saveas(gcf,'./pseudo_signal_fft','png');

% Plotting the multiplied spectrum

mod_sig = prbn.*encode;

figure('Color',[1 1 1]);
subplot(2,1,1);
stairs(t*factor,mod_sig);
ylim([-2 2]);
xlim([0 tscale]);
xlabel('Time (\mus)');
ylabel('Logical True/False');
title('Mixed Signal');
subplot(2,1,2);
stairs(t*factor,mod_sig);
ylim([-2 2]);
xlim([tscale/2 4*tscale/7]);
xlabel('Time (\mus)');
ylabel('Logical True/False');
title('Mixed Signal');
saveas(gcf,'./dsss','png');

% Plotting the frequency spectrum of the signals

[EN f] = ComputeSpectrum(mod_sig,fs,2^20);

figure('Color',[1 1 1]);
stairs(f/factor,EN);
xlabel('Frequency (MHz)');
ylabel('Amplitude');
title('Mixed Signal Spectrum');
saveas(gcf,'./dsss_fft','png');
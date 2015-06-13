% Develope Data Signal

string = 'Four score and seven years ago our fathers brought forth on ';
string = [string,'this continent, a new nation, conceived in Liberty, and '];
%string = [string,'dedicated to the proposition that all men are created equal.'];


% Convert ASCII characters to Binary Strings
data = [];
for x = 1:length(string)
    bit = dec2bin(string(x),8);
    data = [data,bit];
end

%data = ['0','0','0','1','0','1','0','0','0','1','0','1','0','0','0','1','0','1'];
% Encode the signal for voting
bitres = 8;
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

reps = 4;
div = len/reps;

pseudo = rand(1,div);
prbn = [];
for x = 1:div
    if pseudo(x) >= 0.5 && pseudo(x) <= 1.0
        prbn = [prbn,-1*ones(1,reps)];
    elseif pseudo(x) >= 0  && pseudo(x) < 0.5
        pseudo(x) = 1;
        prbn = [prbn,ones(1,reps)];
    end
end


% Plot the information signal

% Time plotting

fs = 4000; % ~2 GHz
factor = 1;
tend = len/fs;
tscale = tend;
t = linspace(0,len/fs,len);

[EN f] = ComputeSpectrum(encode,fs,2^20);

figure('Color',[1 1 1]);
subplot(2,1,1);
stairs(t,encode);
ylim([0 2]);
xlim([tscale/2 2*tscale/3]);
xlabel('Time (\mus)');
ylabel('Logical True/False');
title('Encoded Information Signal');
subplot(2,1,2);
stairs(f,EN);
xlabel('Frequency (kHz)');
ylabel('Amplitude');
title('Encoded Information Signal Spectrum');
saveas(gcf,'./images/encoded_signal','png');

% Plot the psuedo set

[EN f] = ComputeSpectrum(pseudo,fs,2^20);

figure('Color',[1 1 1]);
subplot(2,1,1);
stairs(t,prbn);
ylim([-2 2]);
xlim([tscale/2 4*tscale/7]);
xlabel('Time (s)');
ylabel('Logical True/False');
title('Pseudorandom Binary Signal');
subplot(2,1,2);
stairs(f,EN);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Pseudorandom Binary Signal Spectrum');
saveas(gcf,'./images/pseudo_signal','png');

% Plotting the multiplied spectrum

mod_sig = prbn.*encode;
[EN f] = ComputeSpectrum(mod_sig,fs,2^20);

figure('Color',[1 1 1]);
subplot(2,1,1);
stairs(t,mod_sig);
ylim([-2 2]);
xlim([tscale/2 4*tscale/7]);
xlabel('Time (\mus)');
ylabel('Logical True/False');
title('Mixed Signal');
subplot(2,1,2);
stairs(f,EN);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Mixed Signal Spectrum');
saveas(gcf,'./images/dsss','png');

% Plotting the frequency spectrum of the signals
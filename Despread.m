function info_sig = Despread(t,mod_sig,prbn,encode,bitres,bool)
% Receive Data
    if bool == true
        output = mod_sig.*prbn;
    elseif bool == false
        output = mod_sig;
    end

[info_sig origin reconsig] = decode(output,encode,bitres);
len = length(info_sig);

% data_out = binaryVectorToASCII(info_sig);

output = abs(output);

figure('Color',[1 1 1]);
plot(t,output,'r');
hold on;
stairs(t,reconsig);
title('Compare Output Signal');
xlabel('Time (\mus)');
ylabel('Amplitude');
ylim([0 5]);

% Decode signal and repoduce information

figure('Color',[1 1 1]);
plot(info_sig);
hold on;
plot(origin,'ro');
title('Information Signal');
ylim([0 2]);

% Compare the two signal to produce a standard error

error = 0;
for d = 1:length(reconsig)
    if reconsig(d) ~= encode(d)
        error = error + 1;
    end
end

std_error = error/d*100;

display(sprintf(['The standard error was ',num2str(error),' bits or ',...
                  num2str(std_error),' percent']));


end


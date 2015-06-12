function [info_sig origin reconsig] = decode(output,encode,bitres)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

reconsig = [];
info_sig = [];

y = 1;
for x = 1:length(output)
    if abs(output(x)) > 0.6
        reconsig(x) = 1;
    else
        reconsig(x) = 0;
    end
    
    if mod(x,bitres) == 0
        vote = 0;
        orig = 0;
        for h = 1:bitres
        vote = vote + reconsig(x+1-bitres);
        orig = vote + encode(x+1-bitres);
        end
        vote = vote/bitres;
        orig = orig/bitres;
        % Vote for reconstructed signal
        if vote > 0.5
            info_sig(y) = 1;
        else
            info_sig(y) = 0;
        end
        % Vote for original singal
        if orig > 0.5
            origin(y) = 1;
        else
            origin(y) = 0;
        end
        y = y + 1;
    end       
end

end


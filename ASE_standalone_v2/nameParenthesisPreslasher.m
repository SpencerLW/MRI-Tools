function [ outstring ] = nameParenthesisPreslasher( instring )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    outstring='';letstore='a';
    for i=1:length(instring)
        let=instring(i);
        if (let=='(' | let==')') && letstore~='\'
            outstring=[outstring, '\'];
        end
        outstring=[outstring,let];
        letstore=let;
    end
    instring=outstring;

end


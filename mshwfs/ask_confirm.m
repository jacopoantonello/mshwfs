% ASK_CONFIRM.
%   ASK_CONFIRM(S). Wait for user confirmation.
%
% Author: Jacopo Antonello, <jacopo@antonello.org>

function ask_confirm(s)
str = input(sprintf('USER INPUT: %s [yn] ', s), 's');
if ~strcmp(str, 'y')
    throw(MException('VerifyOutput:IllegalInput', 'Stop'));
end
end



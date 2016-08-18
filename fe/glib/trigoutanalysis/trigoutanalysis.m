
clear all
clc

%% Steps:
% 1: Read file using function generated from import gui
% 2: Search for incorrect packet indices 
% 3: Extract TX_O_0, TX_O_1, RX_O_0, RX_O_1 for these indices
% 4: Convert hex cell types into binary
% 5: Compare binary values using loop and count number of bits that flipped
% 6: Calculate BER

%% 1: Read file using function generated from import gui
[TX_O_0, TX_O_1, RX_O_0, RX_O_1, pcktCount, pcktCount_c, pChk_ic_0, flag_packet] = importfile('trigout_1.xlsx');

%% 2: Search for incorrect packet indices 
incorrect_ind = find(pChk_ic_0);
endr = size(incorrect_ind, 1);
incorrect_ind = incorrect_ind(2:endr, :);

%% 3: Extract TX_O_0, TX_O_1, RX_O_0, RX_O_1 for these indices
%
% Pre-process register contents
%

% Concatenate TX_O_0 and TX_O_1 to obtain entire register contents
len = size(TX_O_0, 1) - 1;

TX_O = zeros(len, 80);
RX_O = zeros(len, 80);

for i = 2:len
    TX_O(i, 1:40) = char(TX_O_0(i));
    TX_O(i, 41:80) = char(TX_O_1(i));
end

TX_O = char(TX_O);

% Concatenate RX_O_0 and RX_O_1 to obtain entire register contents
for i = 2:len
    RX_O(i, 1:40) = char(RX_O_0(i));
    RX_O(i, 41:80) = char(RX_O_1(i));
end

RX_O = char(RX_O);

%
% Extract values
%
TX_O_incorrect = TX_O(incorrect_ind, :);
RX_O_incorrect = RX_O(incorrect_ind, :);

%% 4: Convert hex cell types into binary
TX_O_incorrect_bin = hexToBinaryVector(TX_O_incorrect);
RX_O_incorrect_bin = hexToBinaryVector(RX_O_incorrect);

%% 5: Compare binary values using loop and count number of bits that flipped
lenR = size(TX_O_incorrect_bin, 1);
lenC = size(TX_O_incorrect_bin, 2);

bits = 0;
bits_ = 0;
bits__ = 0;

% TX_O_incorrect(1:2, :)
% RX_O_incorrect(1:2, :)

for i = 1:lenR   
   for j = 1:lenC        
       if TX_O_incorrect_bin(i,j) ~= RX_O_incorrect_bin(i,j)
          bits = bits + 1;
       end   
   end
   
    bits_(i) = bits;
   
    if i == 1
       bits__(i) = bits_(i);
    end
    
    if i > 1
       bits__(i) = bits_(i) - bits_(i-1);
    end
end

str = sprintf('# of error bits in each incorrect packet\n----------------------------------------\n');
disp(str)
disp(bits__)

%% 6: Calculate BER
lenC_ = lenC + 2*4;

str = sprintf('Total # of erroneous packets\n-----------------------');
disp(str)
disp(lenR)

pckts_inc = lenR;
per = lenR/936 * 100;
str = sprintf('Percentage incorrect packets\n----------------------------');
disp(str)
disp(per)


bitstot = len*lenC;  % total # of samples X length of a sample in binary
str = sprintf('Total # of bits observed\n-----------------------');
disp(str)
disp(bitstot)

str = sprintf('Total # of erroneous bits\n-----------------------');
disp(str)
disp(bits)

ber = bits/bitstot;
str = sprintf('BER\n---');
disp(str)
disp(ber)

avg = bits/lenR;
str = sprintf('Average # of incorrect bits in a packet\n---------------------------------------');
disp(str)
disp(avg)




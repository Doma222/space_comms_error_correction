clear; clc;

% --- variables
ArraySize = 1e5;
distance_vec = logspace(log10(0.035), log10(2), 25); % in millions km
nr_distances = length(distance_vec);


% --- Generate Original Array
OriginalArray = randi([0,1] , ArraySize , 1);
len_og = length(OriginalArray);


% -----------------------------------------------------------------------

% Original Array
original_output = original_wrapper(OriginalArray , distance_vec , ArraySize, nr_distances ,len_og);

% Hamming Array
[hamming_output, hamming_m ] = hamming_wrapper(OriginalArray , distance_vec , ArraySize , nr_distances ,len_og);


% Plot Hamming
Hamming_plot(distance_vec, hamming_output, original_output, hamming_m, distance_vec);





% -- ORIGINAL --
function original_output = original_wrapper(OriginalArray , distance_vec , ArraySize, nr_noises ,len_og)
   

    % bit -> signal
    EncodedSignal_og = pskmod(OriginalArray , 2 ,0); 

    % noise
    All_ErrorSignals_og = noise(EncodedSignal_og , distance_vec , 1);


    % signal -> bit
    All_og = zeros(len_og , nr_noises);

    for i = 1:nr_noises

        All_og(:,i) = pskdemod(All_ErrorSignals_og(:,i) , 2);
    end

    % BER
    ber_vec_og = zeros(1,nr_noises);

    for i = 1:nr_noises

        % compare original bits with original after noise
        [num_errors_og, ber_vec_og(i)] = biterr(OriginalArray , All_og(:,i));

        fprintf('Distance = %.3f million km | OG: Raw Errors: %d | BER: %.5f\n' ,distance_vec(i), num_errors_og, ber_vec_og(i));

        fprintf('\n')
    end

    original_output = ber_vec_og;

end



% -- HAMMING --
function [hamming_output, hamming_m ]= hamming_wrapper(OriginalArray , distance_vec , ArraySize, nr_noises ,len_og)
    
    % variables
    hamming_m = 3;
    hamming_codeRate = (2^hamming_m - hamming_m - 1)/(2^hamming_m - 1);

    % -----

    % Encoding
    EncodedArray_h = Hamming_Codec(OriginalArray , hamming_m , 'encode' , ArraySize);

    % bit -> signal
    EncodedSignal_h = pskmod(EncodedArray_h , 2 ,0);

    % noise
    All_ErrorSignals_h = noise(EncodedSignal_h , distance_vec , hamming_codeRate); 

    % signal -> bit and decoding
    All_DecodedArrays_h = zeros(len_og , nr_noises);

    for i = 1:nr_noises
        
        % signal -> bit
        Corrupted_Array_now_h = pskdemod(All_ErrorSignals_h(:,i) , 2);

        % decode and save
        All_DecodedArrays_h(:,i) = Hamming_Codec(Corrupted_Array_now_h , hamming_m , 'decode' , ArraySize);

    end

    % BER 
    ber_vec_h = zeros(1,nr_noises);

    for i = 1:nr_noises

        % compare original bits with decoded Hamming
        [num_errors_h, ber_vec_h(i)] = biterr(OriginalArray , All_DecodedArrays_h(:,i));

        fprintf('Distance = %.3f million km | H: Raw Errors: %d | BER: %.5f\n' , distance_vec(i), num_errors_h, ber_vec_h(i));

        fprintf('\n')
    end
    
    hamming_output = ber_vec_h;

end

function ErrorSignal_arr = noise(EncodedSignal , distance_vec , codeRate)
    
    d_ref = 0.1; % distance reference at 100,000 km 
    EbNo_ref = 10; % snr reference in dB at d_ref

    %pre allocating the memory

    num_points = length(distance_vec);
    len_signals = length(EncodedSignal);
    ErrorSignal_arr = zeros(len_signals , num_points);
    
    for i = 1:length(distance_vec)

        d = distance_vec(i);
        
        % how many dB of signal strength was lost from distance
        path_loss = 20 * log10(d / d_ref);

        effective_EbNo = EbNo_ref - path_loss;

        snr_db = effective_EbNo + 10 * log10(codeRate);

        ErrorSignal_arr(: ,i) = awgn(EncodedSignal , snr_db , "measured");
    end
    
end

% -- BURST ERRORS -- 
% p - Probability of transitioning from the Good state to the Bad state
%  r - Probability of transitioning from the Bad state to the Good state
%  errorProbGood - Probability of error in good state 
%  errorProbBad - Probability of error in bad state

function outputsignal = burst(inputSignal , p , r , errorProbGood , errorProbBad)
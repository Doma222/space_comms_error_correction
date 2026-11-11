

function OutputArray = Hamming_Codec(InputArray , m , action , oglen)

    n = 2^m - 1;
    k = 2^m - m - 1;

    switch lower(action)
        case 'encode'
            OutputArray = local_encode(InputArray , n , k , oglen);

        case 'decode'
            OutputArray = local_decode(InputArray , n , k , oglen);
        
        otherwise
            error('Invalid action. Use ''encode'' or ''decode''.');

    end

    
end


function encoded = local_encode(data , n , k , oglen)
    
    % is og array multiple of k , if not add padding
    rembits = mod(oglen , k) ;

    if rembits ~= 0 %needs padding
        padding = k-rembits;
        data = [data(:); zeros(padding , 1)];
    end

    encoded = encode(data , n ,k , 'hamming/binary');



end

function decoded = local_decode(data , n , k , oglen)
    decoded = decode(data , n , k , 'hamming/binary');
    decoded = decoded(1:oglen);
end

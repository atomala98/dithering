function [noise] = createDither(bit_resolution, length, PDF, isShaped)
% bit_resolution - liczba bitów sygnału
% length - liczba próbek
% PDF - funkcja rozkładu prawdopodobieństwa
% isShaped - czy należy zastosować noise shaping
%
% noise - utworzony szum ditheringu
% 
% Funkcja na podstawie liczby bitów wylicza dopuszczalny zakres odchyleń od
% sygnału podstawowego w wysokości 1 LSB w każdą stronę, następnie na tej
% podstawie tworzy losowy szum w podanym zakresie. Zależnie od wyboru
% użytkownika dodawany jest również noise shaping.
%
%
    d = 1/(2^(bit_resolution-1));

    R1 = [-d/2, 0];
    R2 = [0, d/2];
    
    R = R1 + R2;
    
    if PDF == "triangular"
        noise = (min(R1) + range(R1) .* rand(length, 1)) + (min(R2) + range(R2) .* rand(length, 1));
    elseif PDF == "rectangular"
        noise = min(R) + range(R) .* rand(length, 1);
    else
        noise = zeros(length, 1);
        return
    end

    if isShaped == true
        shaped_noise = zeros(length, 1);

        shaped_noise(1) = noise(1);

        for i = 2:length
           shaped_noise(i) = noise(i) - noise(i-1);
        end
        
        noise = shaped_noise;
    end


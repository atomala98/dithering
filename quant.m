function [quanted_signal, tDepth] = quant(y, bit_depth, auto, min_new, max_new)
% y - sygnał wejściowy
% bit_depth - liczba bitów
% auto (true/false) - automatyczne ustalanie wartości minimalnej i maksymalnej
% min_new - wartość minimalna zakresu
% max_new - wartość maksymalna zakresu
%
% quanted_signal - skwantowany sygnał
% tDepth - teoretyczna rozdzielczość bitowa
% 
% Funkcja na podstawie zadanych parametrów oblicza poziomy kwantyzacji, a
% następnie przypisuje te wartości kwantowanemu sygnałowi. Każdej próbce
% przypisywana jest najbliższa wartość poziomu kwantyzacji.


            if size(y, 2) == 2
                y = y(:, 1);
            end
            quants = [];            %wektor poziomów kwantyzacji
            if(auto)
                min_y = min(y);
                max_y = max(y);
            else
                min_y = min_new;
                max_y = max_new;
            end
            
            range = max_y - min_y;          %zakres pomiarowy
            delta = range / (2^bit_depth - 1);      %krok kwantyzacji
            quants = [quants, min_y];
            for i = 1:1:(2^bit_depth-1)     %obliczanie poziomów kwantyzacji
                quants = [quants, min_y + i * delta];
            end
            quanted_signal = zeros(1, size(y, 1));      %wektor, do którego zostanie wpisany skwantowany sygnał
            for a = 1:size(y, 1)            %przypisywanie wartości poziomów kwantyzacji
                for b = 1:size(quants, 2)
                    if y(a) >= quants(b) && y(a) < quants(b) + delta/2
                        quanted_signal(a) = quants(b);
                    elseif y(a) >= quants(b) - delta/2 && y(a) < quants(b)
                        quanted_signal(a) = quants(b);
                    end
                end
                if y(a) >= quants(end) + delta/2        %przypisanie wartości próbkom, których wartości wychodziły poza zakres pomiarowy
                    quanted_signal(a) = quants(end);
                elseif y(a) < quants(1) - delta/2
                    quanted_signal(a) = quants(1);
                end
            end
            nLevels = 0;            %liczba teoretycznych poziomów kwantyzacji
            found = false;
            for b = 1:size(quants, 2)
                found = false;
                for a = 1:size(quanted_signal, 2)
                    if quanted_signal(a) == quants(b)
                        found = true;
                    end
                end
                if found == true
                    nLevels = nLevels + 1;
                end
            end
            tDepth = log2(nLevels);         %teoretyczna rozdzielczość bitowa
        end


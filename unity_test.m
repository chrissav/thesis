% =========================================================================
% INITIALIZE TCP and VICON CONNECTION 
% =========================================================================

N = 19; % number of data elements from unity
M = 7; % number of data elements from VICON

t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server');
fopen(t);

if(M > 0)
    vFrame = LCMCoordinateFrame('vicon',JLCMCoder(vicon.ViconLCMCoder()),'v');
    vFrame.subscribe('VICON_wand');
end

% =========================================================================
%% READ FROM TCP CONNECTION 
% =========================================================================

STATE = 0; 
READY = 0; 
ACQUIRING = 1; 
SAVING = 2; 

Observations = zeros(1, N + M); 
time_stamp = 0; 
file_name = '';
size = 10; 
while(1) 
    if(t.BytesAvailable > size)
        data = fread(t, t.BytesAvailable);
        str = char(data');
        if( str(1) == 'B' && STATE == READY)
            Observations = zeros(1, N+M); 
            time_stamp = sscanf(str, 'B: %s \n'); 
            disp(time_stamp); 
            STATE = ACQUIRING;
        elseif ( str(1) == 'E' && ACQUIRING )
            file_name = sscanf(str, 'E: %s \n'); 
            disp(file_name);
            STATE = SAVING; 
        elseif( STATE == ACQUIRING ) 
            DataFrame = strsplit(char(data'), '\n');
            for i = 1:length(DataFrame)
                C = strsplit(char(DataFrame{i}), '\t');
                D = str2double(C); 

                if( M > 0 )
                    y = vFrame.getNextMessage(1000); %// Vicon data
                    if isempty(y)
                         y = zeros(M,1);
                    end
                    if( length(D) == N )
                        D = cat(2, D, y');  % note:  cat(2, 3,[4; 5; 6]', [7; 8; 9]') works
                    end
                end
                if( length(D) == (N+M) )
                    D = cat(2, D, y');  % note:  cat(2, 3,[4; 5; 6]', [7; 8; 9]') works
                end
                Observations = cat(1, Observations, D);
            end
        end
            
        if( STATE == SAVING ) 
            disp('Saving the data'); 
            STATE = READY; 
            csvwrite(['C:\Users\Lukas Gemar\thesis\Analysis\Data-3-16\', file_name, '.csv'], Observations); 
        end
    end
end


%%

% =========================================================================
% READ VICON 
% =========================================================================

% y = vFrame.getNextMessage(1000); // Vicon data
% if isempty(y)
%     y = zeros(7,1);
% end
% Observations = cat(1, Observations, cat(2,tGlobal,data',y')); // note:  cat(2, 3,[4; 5; 6]', [7; 8; 9]') works


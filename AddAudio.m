
release(afr); 
release(adw);
%%%%%%%%%%%%%%%%%%%%% Create MATLAB objects to read the audio file %%%%%%%%
afr1 = dsp.AudioFileReader('C:\Program Files\MATLAB\AudioFiles\The Car Song.mp3');
afr2 = dsp.AudioFileReader('C:\Program Files\MATLAB\AudioFiles\The Car Song.mp3');

%%%%%%%%%%% Create MATLAB object to play the altered audio %%%%%%%%%%%%%%%%
adw = audioDeviceWriter('SampleRate', afr2.SampleRate);

%%%%%%%%%%%% every time an audio file reader is called, it %%%%%%%%%%%%%%%
%%%%%%%%%%%% returns the next 1024 x 2 array of the file   %%%%%%%%%%%%%%
%%%%%%%%%%%% If one copy is called first before we start   %%%%%%%%%%%%%%
%%%%%%%%%%%% The loop, it is ahead by one step.             %%%%%%%%%%%%%%
counter = 0;
audio2 = afr2();
audio4 = zeros(1024,2);  %initialize temp matrix for splicing

firsthalf = audio2(257:end,1:2);%take the second half of the first chunk

while counter < 500
    audio4(1:768,1:2) = firsthalf;  %use it as the first half of the splice
    
    audio1 = afr1();
    audio2 = afr2();
    
                                                %use the first half of the
    audio4(769:end,1:2) = audio2(1:256,1:2);    %second chunk as the second
                                                %half of the splice.
                                                
    firsthalf = audio2(257:end,1:2);%take the second half of the second 
                                    %chunk and save it for next time
                                    
    audio3 = (audio1 * 1) + (audio4 * .3);
%     if counter == 1       This is an alternate way of creating echo,
%        afr2.reset();      reset starts the second copy at the beginning
%     end                   It is limited to multiples of the chunk size
 
    adw(audio3);            %play the audio chunk
    counter = counter + 1;  %then move to the next chunk
end
afr1.reset();
counter = 0;
while counter < 500
    audio1 = afr1();
    adw(audio1);
    counter = counter +1;
end
release(afr); 
release(adw);
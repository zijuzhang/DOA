%% SRP Estimate of Direction of Arrival at Microphone Array
% Frequency-domain delay-and-sum test
%  
%%

% x = filter(Num,1,x0);
c = 340.0;

% XMOS circular microphone array radius
d = 0.0457;
%%
% more test audio file in ../../TestAudio/ folder
path = '../../TestAudio/respeaker/mic1-4_2/';
[s1,fs] = audioread([path,'����-2.wav']);
s5 = audioread([path,'����-3.wav']);
s4 = audioread([path,'����-4.wav']);
s2 = audioread([path,'����-5.wav']);
signal = [s1,s5,s4,s2];
M = size(signal,2);
%%
t = 0;

% minimal searching grid
% step = 1;
% 
% P = zeros(1,length(0:step:360-step));
% tic
% h = waitbar(0,'Please wait...');
% for i = 0:step:360-step
%     % Delay-and-sum beamforming
%     [ DS, x1] = DelaySumURA(signal,fs,512,512,256,d,i/180*pi);
%     t = t+1;
%     %beamformed output energy
%     P(t) = DS'*DS;
%     waitbar(i / length(step:360-step))
% end
% toc
% close(h) 
% [m,index] = max(P);
% figure,plot(0:step:360-step,P/max(P))
% ang = (index)*step

ang = 314;

[ DS0, x1] = DelaySumURA(signal,fs,1024,1024,512,d,ang/180*pi);
% DS = filter(HP_Num,1,DS0);
% audiowrite('DS0.wav',real(DS0),fs)
%% diffuse noise field MSC
N = 512;

f = (1:N/2+1)*fs/N;
% f(1) = 1e-8;
Fvv = zeros(N/2+1,M,M);
for i = 1:M
    for j = 1:M   
        if i == j
            Fvv(:,i,j) = ones(1,N/2+1);
        else
            if(mod(abs(i-j),2)==0)
                dij = d*2;
            else
                dij = d*sqrt(2);
            end
            Fvv(:,i,j) = sin(2*pi*f*dij*1/c)./(2*pi*f*dij*1/c);%T(1) = 0.999;%T(2) = 0.996;
        end
    end
end
signal0 = filter(HP_Num,1,signal);
[ super1, x1,~,DI] = superdirectiveMVDR(signal0,fs,N,N,N/2,d,316/180*pi,Fvv);

audiowrite('super8.wav',super1,fs)

% audiowrite('DS7.wav',real(DS),fs)
% audiowrite('signal1.wav',signal(:,1),fs)

[ z ] = postprocessing(x1,super1,fs,ang);
audiowrite('z4.wav',z,fs)






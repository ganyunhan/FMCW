clc
clear 
close all

%% 雷达系统参数设置
fc= 5.8e9;            % 雷达工作频率 载频
c = 3e8;              % 光速

%% 目标参数
r0 = 100; % 目标距离设置
v0 = 20.65;   % 目标速度设置
r1 = 100; % 目标距离设置
v1 = 10.65;   % 目标速度设置

%% CW波形参数设置
A = 1;                %幅值
K = 0.6;              %回波信号衰减
T = 1;                %采样长度T秒
Nr = 8000;            %ADC采样频率

t=linspace(0,T,Nr*T); %发射信号和接收信号的采样时间

Tx=zeros(1,length(t)); %发射信号
Rx=zeros(1,length(t)); %接收信号
Mix=zeros(1,length(t)); %混频信号

%% 信号生成
for i=1:length(t)
    
    r_t0(i) = r0 + v0*t(i); % 距离更新
    td0(i) = 2*r_t0(i)/c;    % 延迟时间
    r_t1(i) = r1 + v1*t(i); % 距离更新
    td1(i) = 2*r_t1(i)/c;    % 延迟时间
    
    Tx(i) = A*cos(2*pi*fc*t(i))+A*randn(size(t(i))); % 发射信号 实数信号,加噪
    Rx(i) = K*A*cos(2*pi*fc*(t(i)-td0(i)))+K*A*cos(2*pi*fc*(t(i)-td1(i)))+K*A*randn(size(t(i))); %接收信号 实数信号,加噪

    Mix(i) = Tx(i).*Rx(i);%差频、差拍、拍频、中频信号
end

%% 低通滤波
filorder = 8; 
cutf1 = 50; 
cutf2 = 1000; 
d = designfilt('bandpassfir','FilterOrder',filorder, ...
         'CutoffFrequency1',cutf1,'CutoffFrequency2',cutf2, ...
         'SampleRate',Nr);
Mix = filtfilt(d,Mix);

%% 信号plot
tx_fft = reshape(Tx,Nr,T);
tx_fft = fft(tx_fft,Nr);
tx_fft = abs(tx_fft);
tx_fft = tx_fft(1:Nr/2,:);

figure(1);
subplot(3,1,1);
plot(tx_fft(:,1));
xlabel('多普勒窗点');
ylabel('幅度');
title('发射信号fft')


rx_fft = reshape(Rx,Nr,T);
rx_fft = fft(rx_fft,Nr);
rx_fft = abs(rx_fft);
rx_fft = rx_fft(1:Nr/2,:);

subplot(3,1,2);
plot(rx_fft(:,1));
xlabel('多普勒窗点');
ylabel('幅度');
title('接收信号fft')


sig_fft = reshape(Mix,Nr,T);
sig_fft = fft(sig_fft,Nr);
sig_fft = abs(sig_fft);
sig_fft = sig_fft(1:Nr/2,:);

subplot(3,1,3);
plot(sig_fft(:,1));
xlabel('多普勒窗点');
ylabel('幅度');
title('差频信号fft')

%% 求速度
[~,fd0]=max(sig_fft);
v_calc1=(c*(fd0-1))/(2*fc);

sig_fft(fd0) = mean(sig_fft); %将最大值重新赋值为平均数，以便找到次大值

[~,fd1]=max(sig_fft);
v_calc0=(c*(fd1-1))/(2*fc);




%% FMCW雷达发射信号、回波信号、混频、距离维FFT、速度维FFT建模仿真。
%%=========================================================================
clear;
close all;
clc;

%% 雷达系统参数设置
rangeRes = 0.01;                % 雷达的距离分率
fc=77e9;                        % 雷达工作频率 载频
c = 3e8;                        % 光速
lamda = c/fc;                   % 载波波长

%% 目标参数
r0 = 20;                        % 目标距离设置
v0 = 8;                       % 目标速度设置
fd = 2*fc*v0/c;
td0 = 2*r0/c;

%% FMCW波形参数设置
B = c / 2;                      % 发射信号带宽60MHz
Tchirp = 8 * rangeRes * B / c;  % 扫频时间
slope_r = B / (Tchirp / 2);     % 调频上升chirp斜率
slope_f = - B / (Tchirp / 2);   % 调频下降chirp斜率

Nd=1;                           % chirp数量 
Nr=32768;                       % ADC采样点数
vres = lamda /4;                % 速度分辨率
Fs=Nr/Tchirp;                   % 模拟信号采样频率
delta_f=1/Tchirp;               % 扫频频率/fft频率分辨率

t=linspace(0,Nd*Tchirp,Nr*Nd);  %发射信号和接收信号的采样时间

Tx=zeros(1,length(t));          % 发射信号
Rx=zeros(1,length(t));          % 接收信号
freq=zeros(1,length(t));
freq_echo=zeros(1,length(t));
tb_mix=zeros(1,length(t));

r_t=zeros(1,length(t));
td=zeros(1,length(t));
delta_t=zeros(1,length(t));
fq=linspace(0,Fs/2,Nr/2);

%% 信号生成,分段
for i=1:length(t)
    
    r_t(i) = r0 + v0*t(i);      % 距离更新
    td(i) = 2*r_t(i)/c;         % 延迟时间
    n = floor(i/Nr);
    delta_t(i) = t(i)-td(i);

    if i <= Nr/2
        Tx(i) = cos(2*pi*(fc*t(i)+slope_r/2*(t(i)- n*Tchirp)^2));
    else
        Tx(i) = cos(2*pi*((fc+2*B)*t(i)+slope_f/2*(t(i)- n*Tchirp)^2));
    end

    if i <= td0*Nr/Tchirp
        Rx(i) = cos(2*pi*((fc)*delta_t(i)+slope_r/2*delta_t(i)^2));
    elseif td0*Nr/Tchirp < i && i<= Nr/2 + td0*Nr/Tchirp
        Rx(i) = cos(2*pi*((fc)*delta_t(i)  + slope_r/2*delta_t(i)^2));
    else
        Rx(i) = cos(2*pi*((fc +2*B)*delta_t(i) + slope_f/2*delta_t(i)^2));
    end

    if i <= Nr/2
        freq(i) = fc + slope_r*t(i); %发射信号时频图 只取第一个chirp
    else
        freq(i) = fc + 2*B + slope_f*t(i); %发射信号时频图 只取第一个chirp
    end

    if i <= td0*Nr/Tchirp
%         freq_echo(i) = fc + fd - slope_r*delta_t(i);
        freq_echo(i) = fc + fd  + slope_r*delta_t(i);
    elseif td0*Nr/Tchirp < i && i<= Nr/2 + td0*Nr/Tchirp        
        freq_echo(i) = fc + fd  + slope_r*delta_t(i);
    else
        freq_echo(i) = fc + fd  + 2*B + slope_f*delta_t(i);
    end

    tb_mix(i) = abs(freq_echo(i) - freq(i));
end

Mix = Tx(1:Nr).*conj(Rx(1:Nr));%差频、差拍、拍频、中频信号

%% 接收信号与发射信号的时频图
figure(1);
subplot(211);plot(freq);
hold on;
plot(freq_echo);
xlabel('时间');
ylabel('频率');
title('接收信号与发射信号时频图');
legend ('TX','RX');
subplot(212);plot(tb_mix);

%% 一维FFT
signal_fft = fft(Mix, Nr);
figure(2);
signal_fft = signal_fft(1:Nr/2);
plot(fq,abs(signal_fft));
title('Range from First FFT');
ylabel('Range [m]');
xlabel('Freq  [Hz]')
title('一维FFT')

%% 求位置和速度
[~,fb_n_index]=max(signal_fft);
fb_n=fq(fb_n_index);
signal_fft(fb_n_index) = mean(signal_fft); %将最大值重新赋值为平均数，以便找到次大值
[~,fb_p_index]=max(signal_fft);
fb_p=fq(fb_p_index);

r_calc=rangeRes*abs(fb_n-fb_p);
v_calc=vres*(fb_n+fb_p);

r_diff=r_calc-r0
v_diff=v_calc-v0
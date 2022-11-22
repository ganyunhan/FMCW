%% ============== %%
% ****** 相位法测角 ********
%  根据2个接收天线的信号进行角度测量
%=================%
close all
clear
clc
%% 能力要求
r_res_req = 1; % 距离分辨率
r_max_req = 50; % 最大测距
v_res_req = 2.5; % 速度分辨率
%% 系统参数
c = 3e8; % 光速
f0 = 24e9; % 载频
lamda = c/f0; % 波长
d =14e-3; % 天线间距
B = 250e6; % 扫频带宽
T_fft = lamda/(2*v_res_req); % fft 时长
Tm = T_fft; % 调频周期，令其和fft时长相等
fs = 256/T_fft; % 采样频率

t = 0 : 1/fs : T_fft - 1/fs; % 时间轴

K = B/Tm; % 扫频斜率
k1 = 2*K/c; % 频差-距离斜率
k2 = 2*f0/c;% 频差-速度斜率
r_res = c/(2*B); % 距离分辨力
v_res = lamda/(2*T_fft); % 速度分辨率
v_max = v_res*T_fft*fs/2; % 最大测速
df = 1/T_fft; % 频谱分辨率


%% 回波信号到达天线1和天线2，经混频后的输出信号
% 假设
r_obj = 20; %目标距离
v_obj = 5; %目标速度， 靠近为正，远离为负
theta = -10*pi/180; % 目标角度
% 有
delta_f = k1*r_obj + k2*v_obj; % 频移
tao = d*sin(theta)/c; % 延时时间

%混频后信号
% 相位差 = 2*pi*发射频率*延时时间 = 2*pi*f0*tao = 2*pi*d*sin(theta)/lamda
delta_w = 2*pi*d*sin(theta)/lamda; % 两路接收天线之间的相移
% 到达天线1的信号
s1 = exp(2j*pi*delta_f*t); 
% 到达天线2的信号
s2 = s1*exp(-1j*delta_w); 

%% 添加噪声
s1 = awgn(s1, 10);
s2 = awgn(s2, 10);
% fft
S1 = fft(s1);
S2 = fft(s2);
% S = S1 .* conj(S2) = S1 .* conj(S1*exp(1j*delta_w)) = |S1|*exp(-1j*delta_w);
% 频域相乘
S = S1 .* conj(S2);
% 相位
delta_w_esti = atan(imag(S)./real(S));
% 由 w = 2*pi*d*sin(theta)/lamda => theta = asin(lamda*w/(2*pi*d))， 
% 又 w -> [ -pi, pi ], 有 abs(theta) < asin(lamda/(2*d))，得测角范围为
% -asin(lamda/(2*d)) < theta  < asin(lamda/(2*d))
%另外，由于用 atan 反求角度，atan要求相位差范围为 [-pi/2, pi/2], 导致
% -asin(lamda/(4*d)) < theta  < asin(lamda/(4*d))
% 因此，还需要根据实部虚部所处的象限修正角度范围
for ii = 1 : length(delta_w_esti)
    if real(S(ii)) < 0 % 第2、3象限
        if imag(S(ii)) > 0 
            delta_w_esti(ii) = delta_w_esti(ii) + pi; % 第2象限
        else 
            delta_w_esti(ii) = delta_w_esti(ii) - pi; % 第3象限
        end
    end
end
theta_esti = asin(lamda*delta_w_esti/(2*pi*d)); % 个频点对应的角度（单位：弧度）
theta_measureRange = asin(lamda/(2*d)) * [ -1, 1];


figure, 
subplot(211), plot(abs(S)); legend('频谱')
subplot(212), plot(theta_esti*180/pi); 
hold on; plot(theta_measureRange(1)*180/pi*ones(1,length(theta_esti)), '-.')
hold on; plot(theta_measureRange(2)*180/pi*ones(1,length(theta_esti)), '-.')
legend('上图频率点对应的角度（单位：度）','测角下限', '测角上限')


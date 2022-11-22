%% ============== %%
% ****** ��λ����� ********
%  ����2���������ߵ��źŽ��нǶȲ���
%=================%
close all
clear
clc
%% ����Ҫ��
r_res_req = 1; % ����ֱ���
r_max_req = 50; % �����
v_res_req = 2.5; % �ٶȷֱ���
%% ϵͳ����
c = 3e8; % ����
f0 = 24e9; % ��Ƶ
lamda = c/f0; % ����
d =14e-3; % ���߼��
B = 250e6; % ɨƵ����
T_fft = lamda/(2*v_res_req); % fft ʱ��
Tm = T_fft; % ��Ƶ���ڣ������fftʱ�����
fs = 256/T_fft; % ����Ƶ��

t = 0 : 1/fs : T_fft - 1/fs; % ʱ����

K = B/Tm; % ɨƵб��
k1 = 2*K/c; % Ƶ��-����б��
k2 = 2*f0/c;% Ƶ��-�ٶ�б��
r_res = c/(2*B); % ����ֱ���
v_res = lamda/(2*T_fft); % �ٶȷֱ���
v_max = v_res*T_fft*fs/2; % ������
df = 1/T_fft; % Ƶ�׷ֱ���


%% �ز��źŵ�������1������2������Ƶ�������ź�
% ����
r_obj = 20; %Ŀ�����
v_obj = 5; %Ŀ���ٶȣ� ����Ϊ����Զ��Ϊ��
theta = -10*pi/180; % Ŀ��Ƕ�
% ��
delta_f = k1*r_obj + k2*v_obj; % Ƶ��
tao = d*sin(theta)/c; % ��ʱʱ��

%��Ƶ���ź�
% ��λ�� = 2*pi*����Ƶ��*��ʱʱ�� = 2*pi*f0*tao = 2*pi*d*sin(theta)/lamda
delta_w = 2*pi*d*sin(theta)/lamda; % ��·��������֮�������
% ��������1���ź�
s1 = exp(2j*pi*delta_f*t); 
% ��������2���ź�
s2 = s1*exp(-1j*delta_w); 

%% �������
s1 = awgn(s1, 10);
s2 = awgn(s2, 10);
% fft
S1 = fft(s1);
S2 = fft(s2);
% S = S1 .* conj(S2) = S1 .* conj(S1*exp(1j*delta_w)) = |S1|*exp(-1j*delta_w);
% Ƶ�����
S = S1 .* conj(S2);
% ��λ
delta_w_esti = atan(imag(S)./real(S));
% �� w = 2*pi*d*sin(theta)/lamda => theta = asin(lamda*w/(2*pi*d))�� 
% �� w -> [ -pi, pi ], �� abs(theta) < asin(lamda/(2*d))���ò�Ƿ�ΧΪ
% -asin(lamda/(2*d)) < theta  < asin(lamda/(2*d))
%���⣬������ atan ����Ƕȣ�atanҪ����λ�ΧΪ [-pi/2, pi/2], ����
% -asin(lamda/(4*d)) < theta  < asin(lamda/(4*d))
% ��ˣ�����Ҫ����ʵ���鲿���������������Ƕȷ�Χ
for ii = 1 : length(delta_w_esti)
    if real(S(ii)) < 0 % ��2��3����
        if imag(S(ii)) > 0 
            delta_w_esti(ii) = delta_w_esti(ii) + pi; % ��2����
        else 
            delta_w_esti(ii) = delta_w_esti(ii) - pi; % ��3����
        end
    end
end
theta_esti = asin(lamda*delta_w_esti/(2*pi*d)); % ��Ƶ���Ӧ�ĽǶȣ���λ�����ȣ�
theta_measureRange = asin(lamda/(2*d)) * [ -1, 1];


figure, 
subplot(211), plot(abs(S)); legend('Ƶ��')
subplot(212), plot(theta_esti*180/pi); 
hold on; plot(theta_measureRange(1)*180/pi*ones(1,length(theta_esti)), '-.')
hold on; plot(theta_measureRange(2)*180/pi*ones(1,length(theta_esti)), '-.')
legend('��ͼƵ�ʵ��Ӧ�ĽǶȣ���λ���ȣ�','�������', '�������')


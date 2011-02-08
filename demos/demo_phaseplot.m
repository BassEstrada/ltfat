%DEMO_PHASEPLOT  Give demos of nice phaseplots
%
%   This script creates a synthetic signal and then uses 'phaseplot' on it,
%   using several of the possible options
% 
%   For real-life signal only small parts should be analyzed. In the chosen 
%   demo the fundamental frequency of the speaker can be nicely seen.
%
%   FIGURE 1 Synthetic signal
%
%     Compare this to the pictures in reference 2 and 3. In 
%     the first two figures a synthetic signal is analyzed. It consists of a 
%     sinusoid, a small Delta peak, a periodic triangular function and a 
%     Gaussian. In the time-invariant version in the first part the periodicity 
%     of the sinusoid can be nicely seen also in the phase coefficients. Also
%     the points of discontinuities can be seen as asymptotic lines approached
%     by parabolic shapes. In the third part both properties, periodicity and 
%     discontinuities can be nicely seen. A comparison to the spectogram shows 
%     that the rectangular part in the middle of the signal can be seen by the
%     phase plot, but not by the spectogram.
% 
%     In the frequency-invariant version the fundamental frequency of the
%     sinusoid can still be guessed as the position of an horizontal
%     asymptotic line.
%
%   FIGURE 2 Synthetic signal, thresholded.
%
%     This figure shows the same as Figure 1, except that values with low
%     magnitude has been removed.
%
%   FIGURE 3 Speech signal.
%
%     The figure shows a part of the 'linus' signal. The fundamental
%     frequency of the speaker can be nicely seen.
%
%R  carmonmultiridge1 Carmona98practical gross1

disp('Type "help demo_phaseplot" to see a description of how this demo works.');

tt=0:98;
f1=sin(2*pi*tt/33); % sinusoid

f2=zeros(1,100);
f2(50)=1; % delta-like

f3=fftshift(firwin('tria',32)).';

f4 = fftshift(pgauss(100)).';
f4 = f4/max(f4);

sig = 0.9*[f1 0 f2 f3 -f3 f3 f4 0 0 0 0];

figure(1);
sgram(sig,'lin','nf');

figure(2);
subplot(3,1,1);
plot(sig);
title('Synthetic signal');
legend('off');

subplot(3,1,2);
phaseplot(sig,'freqinv'); 
title('Phaseplot of synthetic signal - frequency-invariant phase');

subplot(3,1,3);
phaseplot(sig,'timeinv')
title('Phaseplot of synthetic signal - time-invariant phase');

figure(3);
subplot(3,1,1);
plot(sig);
title('Synthetic signal');
legend('off');

subplot(3,1,2);
phaseplot(sig,'freqinv','thr',0.001)
title('Phaseplot of synthetic signal - thresholded version, freq. inv. phase');

subplot(3,1,3);
phaseplot(sig,'thr',0.001)
title('Phaseplot of synthetic signal - thresholded version, time inv. phase');

figure(4);
f=linus;
f = f(4500:8000);

subplot(3,1,1);
plot(f);
axis tight;
title('Speech signal: linus');

subplot(3,1,2);
phaseplot(f)
title('Phaseplot of linus');

subplot(3,1,3);
phaseplot(f,'thr',.001)
title('Phaseplot of linus - thresholded version');

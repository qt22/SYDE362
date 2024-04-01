clear; # clear the variables so something isn't sticking around...

# In part two let's answer some of those questions from Part 1

# We need to recalculate all that stuff from part 1, I'11ll condense the code
# a bit to get us to the good stuff...
fs = 44100; t = 0:1/fs:1;
f1 = 1000; f2 = 2000; f3 = 3000; f4 = 6000;
a1 = 0.1; a2 = 0.2; a3 = 0.3; a4 = 0.5;
p1 = 0; p2 = 0.5*pi; p3 = pi; p4 = 1.5*pi;
c1 = a1*cos(2*pi*f1*t+p1); c2 = a2*cos(2*pi*f2*t+p2);
c3 = a3*cos(2*pi*f3*t+p3); c4 = a4*cos(2*pi*f4*t+p4);
xt = c1+c2+c3+c4;

# Plot a short portion of each individual signal
figure(1);
clf;
subplot(4,1,1);
plot(t(1:100),c1(1:100));
ylabel('Amp'); # We haven't defined the units of amplitude
ylim([-1,1]);
subplot(4,1,2);
plot(t(1:100),c2(1:100));
ylabel('Amp'); # We haven't defined the units of amplitude
ylim([-1,1]);
subplot(4,1,3);
plot(t(1:100),c3(1:100));
ylabel('Amp'); # We haven't defined the units of amplitude
ylim([-1,1]);
subplot(4,1,4);
plot(t(1:100),c4(1:100));
ylabel('Amp'); # We haven't defined the units of amplitude
xlabel('Time (s)');
ylim([-1,1]);

# Looking at each curve, the amplitude values of each frequency
# used above go from -a to +a ...that makes sense!

# Let's take the same FFT as last time in Part 1!
N = 1024;
ft = fft(xt,N);
yt = real(abs(ft));
pt = arg(ft);
dF = fs/N;
freq = dF*(0:N-1)';

# Let's plot only up to N/2 entries of each vector this time...
# remember that the symmetry in Part 1 is a mathematical artifact,
# not actual information about the frequencies above fs/2 - we know
# we didn't mix in any 40 000 Hz, for example.
Nnf = floor(N/2);

figure(2);
clf;
subplot(2,1,1);
plot(freq(1:Nnf),yt(1:Nnf));
xlabel("Freq (Hz)");
xlim([0,fs/2]);
title("FFT Magnitude");
subplot(2,1,2);
plot(freq(1:Nnf),pt(1:Nnf));
xlabel("Freq (Hz)");
ylabel("Phase (rad)");
xlim([0,fs/2]);
title("Phase");

# ...but wait, why is the magnitude so big at the spikes in Figure 2???
# Shouldn't those be lined up with:
# f1 = 1000; f2 = 2000; f3 = 3000; f4 = 6000;
# a1 = 0.1; a2 = 0.2; a3 = 0.3; a4 = 0.5;
# p1 = 0; p2 = 0.5*pi; p3 = pi; p4 = 1.5*pi;

# It looks like someone else already asked this question
# https://www.mathworks.com/matlabcentral/answers/162846-amplitude-of-signal-after-fft-operation
# https://www.mathworks.com/help/matlab/ref/fft.html
# "In general, to return a FFT amplitude equal to the amplitude signal
# which you input to the FFT, you need to normalize FFTs by the number
# of sample points you're inputting to the FFT. ...[i]f you are only going
# to look at one side of the FFT [which we are], you can multiply
# the 'ft' array by 2." ...so let's do that!
ytscaled = 2*yt/N; # * note this is still not 100% right...

# Let's try both a line plot and a bar plot...probably won't make much
# difference with so many 'bins' (we've got N bins, but only plot N/2).
figure(3);
clf;
subplot(2,1,1);
plot(freq,ytscaled);
xlabel("Freq (Hz)");
title("FFT Magnitude");
xlim([0,fs/2]);
subplot(2,1,2);
bar(freq,ytscaled);
xlabel("Freq (Hz)");
title("FFT Magnitude");
xlim([0,fs/2]);

# looks a lot closer, but still not quite perfect. Those peaks in the FFT plots
# aren't perfect spikes though, so it looks like around the spikes there is
# some energy (for 6000 Hz, the peak should have a magnitude of 0.5,
# theoretically, but it's not quite there) what happens if we make a
# bigger N and a smaller N? Let's plot that next:

N = 16;
ft = fft(xt,N);
ytscaled = 2*real(abs(ft))/N;
pt = arg(ft);
dF = fs/N;
freq = dF*(0:N-1)';

figure(4);
clf;
subplot(2,1,1);
bar(freq,ytscaled);
xlabel("Freq (Hz)");
title("FFT Magnitude - Bin Width dF = 44100/16 = 2756.25 Hz");
xlim([0,fs/2]);

N = 44100;
ft = fft(xt,N);
ytscaled = 2*real(abs(ft))/N;
pt = arg(ft);
dF = fs/N;
freq = dF*(0:N-1)';

subplot(2,1,2);
plot(freq,ytscaled);
xlabel("Freq (Hz)");
title("FFT Magnitude - Bin Width dF = 44100/44100 = 1 Hz");
xlim([0,fs/2]);

# Look at that! With a very narrow dF, we get the original:
# f1 = 1000; f2 = 2000; f3 = 3000; f4 = 6000;
# a1 = 0.1; a2 = 0.2; a3 = 0.3; a4 = 0.5;
# ... but we also have to do a huge FFT (a big N with a long time window)
# and lose time resolution. With a very small N (a short time window),
# we have really good time resolution, but have poor frequency resolution
#... quite a tradeoff ; )

# Figure 4 is also great for seeing how the "bins" work. You can see
# the first bin contains the 1000 Hz spike (and other smaller values) is
# actually a bit too low.
# The second bin contains the 2000 and 3000 Hz spikes and is not high enough
# either.
# The third bin really only contains the 5000 Hz spike and is just
# about right. Note that the very small values that look like a
# straight line in the bottom graph actually do have values, they're just small,
# but with 1000's of bins in the bottom plot, those small-valued bins that look
# like zeros, but aren't zeros, can really add up.

# ...so FFT is great, but you need to know what it all means and how
# to use it properly. Makes sense...everything should be like that for
# Engineers... you know what it means, how to use it properly, and
# where th



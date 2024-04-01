# This is a Four Part walkthrough of getting understandable
# data plotted from the fft() function. Make sure to get all
# the way to the end...there are some intentionally bad paths
# followed, but then get figured out...

clear; # clear the variables so something isn't sticking around...

# Define a sampling frequency - how often we take a "sample"
fs = 44100;

# Create a time array at the sampling rate that is 1 second long
t = 0:1/fs:1;

# Create some cosine waves with different frequencies,
# amplitudes, and phases (valued 0 - 2*pi)

# Frequencies in Hz
f1 = 1000;
f2 = 2000;
f3 = 3000;
f4 = 6000;

# Amplitudes are unitless here, but could be volts, meters, etc.
a1 = 0.1;
a2 = 0.2;
a3 = 0.3;
a4 = 0.5;

# Phases in radians - values from 0 to 2*pi
p1 = 0;
p2 = 0.5*pi;
p3 = pi;
p4 = 1.5*pi;

# Calculate the cosine arrays
c1 = a1*cos(2*pi*f1*t+p1);
c2 = a2*cos(2*pi*f2*t+p2);
c3 = a3*cos(2*pi*f3*t+p3);
c4 = a4*cos(2*pi*f4*t+p4);

# Add them all together
xt = c1+c2+c3+c4;

# Plot the combined signal, xt
# Try zooming in to see the waveform in more detail
figure(1);
clf;
plot(t,xt);
xlabel('Time (s)');
ylabel('Amplitude'); # We haven't defined the units of amplitude

# When we take an FFT, we have to pick a portion of the signal
# to analyze. The xt signal has 44100 samples, so we could use
# all of them, but usually we use a smaller 'window'

# If we start at t = 0, and only look at 1024 samples, that means
# our FFT is only analyzing from t = 0 to 0.02322s. We aren't
# looking at the whole signal...so if something different happens
# outside of the window we're looking at, we won't capture that...

# Let's take an FFT! First we need to decide how many samples to use
# in our analysis - let's try 1024 to start.
N = 1024;

# When you take an FFT, it returns a complex numbered array the
# same size as N. If we want to plot it we often look at two plots:
# phase and magnitude, like in a bode plot!

# First take the FFT - remember this returns complex values
ft = fft(xt,N);

# Let's calculate the magnitude. You used to have to call real() to
# make sure that you didn't have leftover imaginary parts when you
# call abs(), but that no longer seems to be needed...
# ...in the old days you might get 9.3 + 0i, for example - so want
# to get rid of the imaginary part...
yt = real(abs(ft)); # I'll leave the real() in for old time's sake...

# we can use the "argument" function to calculate the phase angle
pt = arg(ft);

# We also need to define a frequency vector that indicates what
# the frequency is at the center of each 'bin'. Note that when you get
# an FFT array, it doesn't show you only the specific frequencies in the
# frequency vector, those frequencies are just the center of a band of
# frequencies that is dF wide. For example, if dF = 100, and one of the
# values in freq is 500, then the magnitude of the fft reported at
# 500 Hz is including frequencies from 450-550 hz.
dF = fs/N;
freq = dF*(0:N-1)';

# Enough talk...let's plot this stuff. Let's plot the entire vector for now...
figure(2);
clf;
subplot(2,1,1);
plot(freq,yt);
xlabel("Freq (Hz)");
title("FFT Magnitude");
subplot(2,1,2);
plot(freq,pt);
xlabel("Freq (Hz)");
ylabel("Phase (rad)");
title("Phase");

# ...but wait, why is the magnitude so big at the spikes???
# ...Something's wrong with the scaling...
# ...but wait, why is there symmetry around fs/2 (Nyquist frequency)?
# ...why are we using line graphs if we made such a big deal about bins?

# ...well, if we remember our DFT ideas, we remember that we end up with
# symmetry about fs/2. Often when looking at these plots we'll ignore half
# of the array above fs/2. Remember that for a sampling frequency, 'fs',
# the highest frequency we can capture accurately is fs/2. If we have any
# signals above fs/2 they will be 'aliased' and show up as lower frequencies
# than they actually are.

# Let's address some of these issues in FFTBasicsPart2.m!




N=50;
fs=100e6;
f=1e6;
ts=1/fs;
t = ts*(0:N-1);
x=0;
x=(((2^16)/2)-1)*sin(2*pi*f*t-pi/2);
x=round(x);
filename = 'SinusSignal_1M.xlsx'
xlswrite(filename,x);
plot(t,x)
N=100;
fs=200;
f=1;
ts=1/fs;
t = ts*(0:N-1);
x=0;
x=(((2^16)/2)-1)*sin(2*pi*f*t-pi/2);
x=round(x);
filename = 'SinusSignal.xlsx'
xlswrite(filename,x);
plot(t,x)
x=linspace(-4*pi,4*pi,200);
y=linspace(-4*pi,4*pi,200);
[x,y]=meshgrid(x,y);
z=sin(3*x)*cos(2*y)*exp(abs((x^2+y^2)/4))
plot3(x,y,z)
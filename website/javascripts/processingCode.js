// Generated by CoffeeScript 1.6.1
(function(){var e,t,n;e=function(){function e(e,t){this.p5=e;this.x=t.x;this.y=t.y;this.x_off=t.x_off;this.y_off=t.y_off;this.vel=t.vel||2;this.accel=t.accel||-0.003}e.prototype.draw=function(){if(this.vel>0){this.x_off+=7e-6;this.y_off+=7e-6;this.vel+=this.accel;this.x+=this.p5.noise(this.x_off)*this.vel-this.vel/2;this.y+=this.p5.noise(this.y_off)*this.vel-this.vel/2;this.p5.stroke(n(150,220),n(100,200),n(120,240),4);return this.p5.point(this.x,this.y)}return};return e}();n=function(e,t){var n,r,i;t==null&&(t=0);n=Math.random();e==null&&(r=[0,e],e=r[0],t=r[1]);e>t&&(i=[t,e],e=i[0],t=i[1]);return Math.floor(n*(t-e+1)+e)};t=function(t){t.setup=function(){t.size($(window).width(),$(window).height()*.8);t.background(20,52,49);return this.beans=[]};return t.draw=function(){var n,r,i,s,o,u,a,f,l;i=t.frameCount*.005;o=i+20;r=t.noise(i)*t.width;s=t.noise(o)*t.height;if(t.frameCount%10===0){n=new e(t,{x:r,y:s,x_off:i,y_off:o});this.beans.push(n)}f=this.beans;l=[];for(u=0,a=f.length;u<a;u++){n=f[u];l.push(n.draw())}return l}};$(document).ready(function(){var e,n;e=document.getElementById("processing");return n=new Processing(e,t)})}).call(this);
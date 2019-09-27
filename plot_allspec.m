% plot_allpharray.m
% 20/9/2019

load all_spec.dat

figure(1)
subplot(3,1,1)
title( 'SUN OBS ch120-123' )
for idx=0:599

 tcp1=sum(all_spec((idx*8+5)));
 tcp2=sum(all_spec((idx*8+6)));
 tcp3=sum(all_spec((idx*8+7)));
 tcp4=sum(all_spec((idx*8+8)));
 tcp(idx+1)=mean([tcp1,tcp2,tcp3,tcp4]);
 plot(idx,tcp1, 'r');
 hold on
 plot(idx,tcp2, 'g');
 plot(idx,tcp3, 'b');
 plot(idx,tcp4, 'k');
 grid on;

%plot( (1:128), all_spec((idx*8+5),:),'r')
 %plot( (129:256), all_spec((idx*8+6),:),'g') 
 %plot( (257:384), all_spec((idx*8+7),:),'b')
 %plot( (385:512), all_spec((idx*8+8),:),'k')
 %ylim([ 0 1100])
 %xlim([ 0 512])
 %title(strcat('file number:',num2str(idx)))
 %pause(0.6)
% hold off
end

 subplot(3,1,3)
 %figure(2)
 %plot(tcp);
 xlabel('File Index')
 ylabel('Corr Tpwr')
 
% Running mean to smooth the plot
 Nl=size(tcp)
 for cnt = 1:597
 start=cnt;
 stop=cnt+3;
 nsamples(cnt,:)=mean(tcp(start:stop));
  
 plot(nsamples);
 grid on;
 end
 
 
 

 subplot(3,1,2)
 plot(nsamples);
 grid on;

 print('sun_obs_corrTpwr_T7T3_ch120-123.png','-dpng')


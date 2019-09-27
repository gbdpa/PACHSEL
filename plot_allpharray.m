% plot_allpharray.m
% 20/9/2019

load all_pharray.dat

for idx=0:599

 
 plot( (1:128), all_pharray((idx*8+5),:),'r.')
 hold on
 plot( (129:256), all_pharray((idx*8+6),:),'g.') 
 plot( (257:384), all_pharray((idx*8+7),:),'b.')
 plot( (385:512), all_pharray((idx*8+8),:),'k.')
 ylim([ -180 180])
 title(strcat('file number:',num2str(idx)))
 pause(0.6)
 hold off
end

 xlabel('ch index')
 ylabel('phase in degree')

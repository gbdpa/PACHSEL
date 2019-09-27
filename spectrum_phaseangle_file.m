% phase-angle.m
%
clear all
close all
clc

Outbits = 5;  %No of output bits
N = 1; %No of channels
PipeCnt = [2:17];
Npipe = length(PipeCnt);
%Nsamples = 1024*2;
totalColumns =17;

for1sec = 41779200;
for10sec = 417792000;
for24ms = 104448;


	filesize_in_bytes = for1sec; 
	datsize = filesize_in_bytes/2;   %522,240;
	%%%Nsamples = datsize/(Npipe+1);
	Nsamples = datsize/totalColumns;

%	filesize_in_bytes = 4177920; %1044480; %1044480; %41779200; %1044480; #
%	datsize = filesize_in_bytes/2;   %522,240;
%	Nsamples = datsize/(Npipe+1);

Ninteg = 32;
AvgDat(Nsamples, Npipe*(Npipe+1)/2)= 0.0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
tic
	Dirname = './';
	infilename(1,:) = 'extract2.dat'; 

	NoOfFiles =1;
%	for NoOfFiles = 1:1
	    infilename(NoOfFiles,:);
	    fid0 = fopen([Dirname, infilename(NoOfFiles,:)], 'r');
        
	    [val, count] = fread (fid0, datsize, "uint16",0, "native");
	    fclose(fid0);    
  
	    [row,col]=size(val);
	    val2=reshape(val,totalColumns,row/totalColumns);
	    val3=val2';
	    clear count;
            clear val;
            clear val2; 
  
	    rpart = bitand(val3,31);
	    ipart = bitand(bitshift(val3,-5),31);
toc  
	  Ncol=totalColumns;
	  for col = 2:Ncol 
     	     NegIndex = find(rpart(:,col) >= (2^Outbits)/2);
	     rpart(NegIndex,col) = rpart(NegIndex,col)-2^Outbits;

	     NegIndex = find(ipart(:,col) >= (2^Outbits)/2);
	     ipart(NegIndex,col) = ipart(NegIndex,col)-2^Outbits;
	  end;
  
	  TimeSer = rpart+sqrt(-1)*ipart;

%%=======================

Npt=128; NFts = floor(Nsamples/Npt);
%reOrderIdx=[14,10,6,2, 1,5,9,13, 16,12,8,4,  3,7,11,15];
%reOrderIdx=[16,14,12,10, 8,6,4,2, 15,13,11,9,  7,5,3,1];
reOrderIdx=[15,13,11,9, 7,5,3,1, 16,14,12,10, 8,6,4,2];
for Idx=1:8
 
 corspec(1:Npt,Idx) = 0;
 
 for(AVidx=1:NFts)
    StartIdx = (AVidx-1)*Npt+1; EndIdx = (StartIdx-1)+Npt;
    outspec1 =  fft(TimeSer(StartIdx:EndIdx,reOrderIdx(Idx)+1 ));
    outspec2 =  fft(TimeSer(StartIdx:EndIdx,reOrderIdx(Idx+8)+1 ));
    outspec2c = conj(outspec2);

    corspec(1:Npt,Idx) = corspec(1:Npt,Idx) + ( outspec1 .* outspec2c);
 endfor;
 corspec_shifted(1:Npt,Idx) = fftshift(corspec(1:Npt,Idx)/NFts) ; 
 
end;




 m1=[128,128];
 m2=[256,256];
 m3=[384,384];
 m4=[512,512];
 b=[100,1500];

 %subplot(2,2,1)
 
 for Idx=1:4
    xindx = (1:128)+(Idx-1)*128;
    %plot(xindx, abs(corspec_shifted(1:Npt,Idx) ).*180/pi,"-")
    spec(Idx,:)=abs(corspec_shifted(1:Npt,Idx)).*180/pi;
    %hold on;
 endfor;   
 
 %plot(m1,b,'r'); plot(m2,b,'r'); plot(m3,b,'r'); plot(m4,b,'r');
 %axis([0   520     0    2000 ]); grid on
 %xlim([0   520]); grid on

 %subplot(2,2,2)
 for Idx=5:8
    xindx = (1:128)+(Idx-5)*128;
    %plot(xindx,   (abs(corspec_shifted(1:Npt,Idx) )).*180/pi,"-")
    spec(Idx,:)=abs(corspec_shifted(1:Npt,Idx) ).*180/pi;
    %hold on;
 endfor;   

 %plot(m1,b,'r'); plot(m2,b,'r'); plot(m3,b,'r'); plot(m4,b,'r');
 %axis([0   520     0    5000 ]); grid on
 %xlim([0   520]); grid on
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

 %subplot(2,2,3)

 m1=[128,128];
 m2=[256,256];
 m3=[384,384];
 m4=[512,512];
 b=[-150,150];

 for Idx=1:4
    xindx = (1:128)+(Idx-1)*128;
    %plot(xindx, angle(corspec_shifted(1:Npt,Idx) ).*180/pi,".")
    pharray(Idx,:)=angle(corspec_shifted(1:Npt,Idx))*180/pi;
    ph(Idx)=mean(angle(corspec_shifted(1:Npt,Idx)))*180/pi;
    %hold on;
 endfor;   
 
  %plot(m1,b,'r'); plot(m2,b,'r'); plot(m3,b,'r'); plot(m4,b,'r');
  % axis([0   520     -190   190 ]); grid on

 %subplot(2,2,4)
 for Idx=5:8
    xindx = (1:128)+(Idx-5)*128;
    %plot(xindx, angle(corspec_shifted(1:Npt,Idx) ).*180/pi,".")
    pharray(Idx,:)=angle(corspec_shifted(1:Npt,Idx))*180/pi;
    ph(Idx)=mean(angle(corspec_shifted(1:Npt,Idx)))*180/pi;
    %hold on;
 endfor;   
 ph
    %plot(m1,b,'r'); plot(m2,b,'r'); plot(m3,b,'r'); plot(m4,b,'r');
    %axis([0   520     -190   190 ]); grid on

save -ascii pharray.dat pharray
save -ascii spec.dat spec
 
 %print spectrum_phase_subplots.png


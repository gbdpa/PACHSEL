#!/bin/bash
# CygA transit obs with the G5 GEETEE East & West
#  - uses station phasing- 5 May 2019/ 6/apr/2019 25/03/2019
#
# CRAB_OBS.sh   06/sep/2018
# Receiver configuration used
# cd /home/MWA/digrec2/shSBC
#./boot.sh

#./ldgain_yx_T1P1ch27_maskCh109-112.sh 1 200 0
#./ldgain_yx_T2P2ch27_maskCh109-112.sh 2 0 200
#./ldgain_yx_T3P2ch110_maskCh25-28.sh 3 0 64
#./ldgain_yx_T4P1ch110_maskCh25-28.sh 4 64 0
#./ldgain_yx_T4P1ch110_maskCh25-28.sh 6 64 0

#  508  
#  509  ./ldgain_yx.sh 5 0 0
#  510  ./ldgain_yx.sh 7 0 0
#  511  ./ldgain_yx.sh 8 0 0

#  UDPDUMP2: ./reacquire.sh 0
#	all_stats_v3c   %(with::: graphics_toolkit("gnuplot") )
#  517  ./pa5.sh 
#  518  ./pachsel.sh 
#  519  ./pachsel_mapping.sh 25 26 27 28 109 110 111 112
#	./reacquire.sh 0
#	mini_spec_v3g_pachsel_png_without_fig

# CygA , CygA, CygA, CygA  --10may2019

rm tstamp.txt tstamp_lst.txt
touch tstamp.txt tstamp_lst.txt

cd /bigraid/SCRATCH

RXIP="172.17.20.112"  # gbd dr control pc

ts_temp=`date +%F_%T`
ts_temp2=`echo $ts_temp | sed -r 's/://g'`
ts=`echo $ts_temp2 | sed -r 's/-//g'`
 
ts_ppd=`date +%F`
ts_ppd2=`echo $ts_ppd | sed -r 's/://g'`
tsppd=`echo $ts_ppd2 | sed -r 's/-//g'`
us=_

# CygA 16:51:44 +5.0
dir=SUN_OBS_Tile_$ts

mkdir $dir

#CygARA=20:00:38 
#CygADec=40.6

cd /home/mwa/UDPDUMP2


ppd_cntr=100


for i in {1..600}; do
 
#ssh musca@$RXIP "cd /home/MWA/digrec2/swan_pointing_fromDESH/SWAN_POINTING/SCRATCH;./station_phasing_control 16:51:44 5.0 TODAY 15:00 19:00 34.5 17 16 5 G5GBDSWAN | grep CHKSUM | head -n 5"

#ssh musca@$RXIP "cd /home/MWA/digrec2/swan_pointing_fromDESH/SWAN_POINTING/SCRATCH;./station_phasing_control $CygARA $CygADec TODAY 19:00 23:00 34.5 17 16 5 TG5GBDSWAN | grep CHKSUM | head -n 5"

if [ $i -eq $ppd_cntr ]
  	then
		echo "running PPD "
		ssh musca@$RXIP "/home/MWA/digrec2/wMARC_1.1/www/wppd.sh; mv /home/MWA/digrec2/wMARC_1.1/www/wppd.png /home/MWA/digrec2/wMARC_1.1/www/wppd_$tsppd$us$i.png"   
	      ppd_cntr=`echo $ppd_cntr+100 |bc`   		
	fi


./acq_1sec_SFIX.sh
ssh musca@$RXIP "/home/mwa/UDPDUMP2/glstd | tail -n 1"  >> tstamp_lst.txt
ls -ltrh --full-time extract2.dat | awk '{print $6" "$7}' >> tstamp.txt 

sleep 16
#rsync -avP musca@172.17.20.112:/home/MWA/digrec2/swan_pointing_fromDESH/SWAN_POINTING/CONFIG/tdelay_list.txt .

#rsync -avP musca@172.17.20.112:/home/MWA/digrec2/shSBC/phase.dat .

#rsync -avP musca@172.17.20.112:/home/MWA/digrec2/swan_pointing_fromDESH/SWAN_POINTING/SCRATCH/present_delays.txt .

#rsync -avP musca@172.17.20.112:/home/MWA/digrec2/swan_pointing_fromDESH/SWAN_POINTING/CONFIG/ofs_phase_perch.txt .


#mv tdelay_list.txt /bigraid/SCRATCH/$dir/tdelay_list_CygA_$i.txt
#mv phase.dat /bigraid/SCRATCH/$dir/phase_CygA_$i.dat
#mv present_delays.txt /bigraid/SCRATCH/$dir/present_delays_CygA_$i.txt
#mv ofs_phase_perch.txt  /bigraid/SCRATCH/$dir/ofs_phase_perch_$i.txt

mv extract2.dat /bigraid/SCRATCH/$dir/extract2_$i.dat

echo ; echo acquired $i files ; echo 

done

mv noslips.txt /bigraid/SCRATCH/$dir
mv fixstatus.txt /bigraid/SCRATCH/$dir

mv  tstamp.txt  /bigraid/SCRATCH/$dir 
mv  tstamp_lst.txt /bigraid/SCRATCH/$dir

rsync -avP musca@$RXIP:~/digrec2/wMARC_1.1/www/wppd_$tsppd$us*.png /bigraid/SCRATCH/$dir/.

echo; echo  "-----"



echo ; echo files saved in directory: /bigraid/SCRATCH/$dir ; echo
echo  "--  SUN Acquisition over  ---" ; date; echo







#!/bin/bash

 

if [ "$1" = "" ] #|| [ "$2" = "" ] || [ "$3" = "" ]
then
  echo; echo USAGE:
  echo "<quick-process.sh> <data_dir path> "
  echo
else

dir=$1

echo "DATA directory is $dir" >> log.txt


for i in {1..600}; do


   echo $i > filenum.txt
   echo  "cp $dir/extract2_$i.dat extract2.dat"
   cp $dir/extract2_$i.dat extract2.dat

   octave --s spectrum_phaseangle_file.m
   #octave --s mini_spec_v3g_pachsel_png_withoutCC.m
   cat pharray.dat >> $dir/all_pharray.dat
   mv pharray.dat $dir/pharray_$i.dat
   
   cat spec.dat >> $dir/all_spec.dat
   mv spec.dat $dir/spec_$i.dat
   

   #mv spectrum_phase_subplots.png $dir/spectrum_phase_subplots_$i.png

   echo
###############################################################################

   echo ; echo ----------------  ----  ----   processed $i files ; echo; echo

  # sleep 1

done

 

fi

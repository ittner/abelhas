# Lua Abelhas optimization example data. Generated with gnuplot.lua
set term gif animate transparent opt delay 25 size 400,300 x000000
set output 'particles.gif'
unset title
set hidden3d offset 1 trianglepattern 3 undefined 1 altdiagonal bentover
set isosamples 40, 40
set view 60, 70, 1, 1
set xrange [ -3.0 : 3.0 ] noreverse nowriteback
set yrange [ -3.0 : 3.0 ] noreverse nowriteback
set zrange [ -5.0 : 5.0 ] noreverse nowriteback
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_001.dat' title 'Iteration  1' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_002.dat' title 'Iteration  2' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_003.dat' title 'Iteration  3' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_004.dat' title 'Iteration  4' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_005.dat' title 'Iteration  5' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_006.dat' title 'Iteration  6' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_007.dat' title 'Iteration  7' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_008.dat' title 'Iteration  8' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_009.dat' title 'Iteration  9' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_010.dat' title 'Iteration 10' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_011.dat' title 'Iteration 11' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_012.dat' title 'Iteration 12' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_013.dat' title 'Iteration 13' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_014.dat' title 'Iteration 14' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_015.dat' title 'Iteration 15' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_016.dat' title 'Iteration 16' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_017.dat' title 'Iteration 17' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_018.dat' title 'Iteration 18' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_019.dat' title 'Iteration 19' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_020.dat' title 'Iteration 20' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_021.dat' title 'Iteration 21' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_022.dat' title 'Iteration 22' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_023.dat' title 'Iteration 23' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_024.dat' title 'Iteration 24' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_025.dat' title 'Iteration 25' with points pointtype 7 pointsize 1
splot cos(x**2 + y**2) - x**2/5 - y**2/5, 'particles_026.dat' title 'Iteration 26' with points pointtype 7 pointsize 1

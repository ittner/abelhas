set term gif animate transparent opt delay 50 size 400,300 x000000
set output 'particles.gif'
unset title
set hidden3d offset 1 trianglepattern 3 undefined 1 altdiagonal bentover
set isosamples 40, 40
set view 55, 55, 1, 1
set xrange [ -3.0 : 3.0 ] noreverse nowriteback
set yrange [ -3.0 : 3.0 ] noreverse nowriteback
set zrange [ -0.5 : 1.1 ] noreverse nowriteback
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_001.dat' title 'Iteration  1' with points pointtype 7 pointsize 1
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_002.dat' title 'Iteration  2' with points pointtype 7 pointsize 1
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_003.dat' title 'Iteration  3' with points pointtype 7 pointsize 1
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_004.dat' title 'Iteration  4' with points pointtype 7 pointsize 1
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_005.dat' title 'Iteration  5' with points pointtype 7 pointsize 1
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_006.dat' title 'Iteration  6' with points pointtype 7 pointsize 1
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_007.dat' title 'Iteration  7' with points pointtype 7 pointsize 1
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_008.dat' title 'Iteration  8' with points pointtype 7 pointsize 1
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_009.dat' title 'Iteration  9' with points pointtype 7 pointsize 1
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_010.dat' title 'Iteration 10' with points pointtype 7 pointsize 1
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_011.dat' title 'Iteration 11' with points pointtype 7 pointsize 1
splot sin(x**2 + y**2)/(x**2 + y**2), 'particles_012.dat' title 'Iteration 12' with points pointtype 7 pointsize 1

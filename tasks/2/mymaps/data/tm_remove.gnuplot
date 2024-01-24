set terminal png size 800,600
set output 'tm_remove_performance.png'

set title "Remove Operation Performance"
set xlabel "Size (n)"
set ylabel "Time (us)"
set logscale x
set grid

plot "tree.dat" using 1:4 with lines title "Tree Remove", \
     "map.dat" using 1:4 with lines title "Map Delete"

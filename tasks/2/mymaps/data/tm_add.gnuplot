set terminal png size 800,600
set output 'tm_add_performance.png'

set title "Add Operation Performance"
set xlabel "Size (n)"
set ylabel "Time (us)"
set logscale x
set grid

plot "tree.dat" using 1:2 with lines title "Tree Add", \
     "map.dat" using 1:2 with lines title "Map Put"
set terminal png size 800,600
set output 'add_performance.png'

set title "Add Operation Performance"
set xlabel "Size (n)"
set ylabel "Time (us)"
set logscale x
set grid

plot "list.dat" using 1:2 with lines title "List Add", \
     "tree.dat" using 1:2 with lines title "Tree Add", \
     "map.dat" using 1:2 with lines title "Map Put"
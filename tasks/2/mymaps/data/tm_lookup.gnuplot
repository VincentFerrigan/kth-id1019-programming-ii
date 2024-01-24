set terminal png size 800,600
set output 'tm_lookup_performance.png'

set title "Lookup Operation Performance"
set xlabel "Size (n)"
set ylabel "Time (us)"
set logscale x
set grid

plot "tree.dat" using 1:3 with lines title "Tree Lookup", \
     "map.dat" using 1:3 with lines title "Map Get"

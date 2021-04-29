#! /bin/bash

echo "Creating directories."

mkdir inputs
cd inputs

mkdir bfs kmeans lud

echo "Downloading Rodinias..."
wget http://www.cs.virginia.edu/~kw5na/lava/Rodinia/Packages/Current/rodinia_3.1.tar.bz2
tar -xf rodinia_3.1.tar.bz2

echo "Moving data files."
mv rodinia_3.1/data/bfs/*.txt bfs/
mv rodinia_3.1/data/kmeans/*.txt kmeans/
mv rodinia_3.1/data/kmeans/kdd_cup kmeans/kdd_cup.txt
mv rodinia_3.1/data/lud/*.dat lud/*.dat

echo "Deleting Rodinias."
rm -r rodinia_3.1.tar.bz2 rodinia_3.1

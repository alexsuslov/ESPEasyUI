#!/bin/bash

function jade2h {
  # create .h
  xxd -i $1 > $1.h
  filename="${f%.*}"

  # rename to const in PROGMEM
  src="unsigned char ${filename}\_html\[\] \="
  dst="const char ${filename}_html[] PROGMEM ="
  src1="unsigned int"
  dst1="const int"
  sed "s/${src}/${dst}/" $1.h | sed "s/${src1}/${dst1}/" >../${filename}.h
}

rm *.h
time gulp dist

cd html

for f in `ls`
do
 echo "Processing $f"
 jade2h $f
done


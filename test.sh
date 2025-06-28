#!/bin/bash

list='var-1 var-2 var-3'

for var in $list; do
	num="${var#var-}"
	echo $num
done


#!/bin/bash

cd Validations/
for f in *; do
	echo $f
	sed  's/NAME_OF_FILE/'$f'/' < ../Convert.php > ../Convert.php.temp
	php ../Convert.php.temp
	done
cd ..
rm Convert.php.temp

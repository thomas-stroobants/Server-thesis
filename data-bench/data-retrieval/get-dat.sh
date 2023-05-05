#! /usr/bin/bash
number=100
while [ $number -gt 10 ]
do
    number=$(( $number - 1))
    echo "number is $number"
    sleep 1
done
#!/bin/bash

while :
do
  echo ""
  echo " 1. Show Disk Usage"
  echo " 2. Show CPU USage"
  echo " 3. Show Memory Usage"
  read -p "ENter the right Number :" choice
  case $choice in
    1) du ;;
    2) top ;;
    3) free -h ;;
    *) echo "Invalid Number" ;;
  esac
done


#!/bin/bash

show_spinner() {
  local pid=$1
  local delay=0.1
  local spin_chars=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

  tput civis
  while ps -p $pid > /dev/null; do
    for i in "${spin_chars[@]}"; do
      printf "\r%s Processing..." "$i"
      sleep $delay
    done
  done
  tput cnorm
  printf "\r\033[K"
}
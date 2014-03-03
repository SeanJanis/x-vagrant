#!/bin/sh

# Heroku toolbelt
echo "deb http://toolbelt.heroku.com/ubuntu ./" | sudo tee -a /etc/apt/sources.list.d/heroku.list
wget -O- https://toolbelt.heroku.com/apt/release.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y heroku

# Image manipulation
sudo apt-get install imagemagick

# Node help
sudo npm install -g nodemon
sudo npm install -g grunt
#! /bin/bash

git submodule init
git submodule sync
git submodule foreach git submodule update --init --recursive

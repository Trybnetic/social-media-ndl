#!/usr/bin/sh
# -*- encoding: utf-8 -*-
# Makefile
#
# (c) 2016 Marc Weitz <marc.weitz [at] trybnetic.org>
# GPL 3.0+ or (cc) by-sa (http://creativecommons.org/licenses/by-sa/3.0/)
#
# created 2016-09-11
# last mod 2016-11-19 MW
#

default: model 

model:
	Rscript training.R
	rm data/event_file.tmp
	mv activations.rda ../analysis/data/

#!/usr/bin/Rscript
# -*- encoding: utf-8 -*-
# extract_posts.R
#
# (c) 2016 Marc Weitz <marc.weitz [at] trybnetic.org>
# GPL 3.0+ or (cc) by-sa (http://creativecommons.org/licenses/by-sa/3.0/)
#
# created 2016-09-10
# last mod 2016-11-19 MW
#


parties <- c("afd","csu","gruene","npd","cdu","fdp","linke","spd")

for (party in parties) {
    dat <- read.csv(paste("csv/",party,"_all_posts.csv", sep=""), sep=";", header=T)

    dat$message_new <- gsub("\n","",dat$message)
  
    write.table(tail(dat$message_new,length(dat$message_new)-1), paste(party,".txt", sep=""), sep=";", row.names=F, col.names=F)
}


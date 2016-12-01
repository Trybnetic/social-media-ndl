#!/usr/bin/Rscript
# -*- encoding: utf-8 -*-
# analysis.R
#
# (c) 2016 Marc Weitz <marc.weitz [at] trybnetic.org>
# GPL 3.0+ or (cc) by-sa (http://creativecommons.org/licenses/by-sa/3.0/)
#
# created 2016-09-22
# last mod 2016-11-19 MW
#


# load librarys
library(xtable)

# load data
load("data/activations.rda")

# data to table
tab <- xtabs(~predicted+outcome, data=dat)
xtable(tab) # LaTeX Output


# Pooling the data
correct <- diag(tab)
total <- apply(X=tab, 1,sum)
false <- total - correct

# calculate ratio
accuracy <- correct/total

# As dataframe
freq <- data.frame(party=colnames(tab), case=c(rep("hit",8), rep("miss",8)), freq=c(correct,false))

# Test homogenity
chisq.test(xtabs(freq ~ party + case, freq))

# Accuracy plot
pdf(file="plots/accuracy.pdf")
barplot(accuracy, ylim=c(0,1), main="Accuracy of the predictons for each political party", xlab="Political Party", ylab="Accuracy")
abline(h=0.125, lty=2)
abline(h=mean(accuracy), lty=3)
legend(lty=c(2,3),legend=c("chance level", "mean accuracy"),x="topleft")
box()
dev.off()

# Scatterplots
pdf("plots/spdcdu.pdf")
plot(dat[c("spd","cdu")], xlim=c(-2,4), ylim=c(-2,4))
abline(v=0)
abline(h=0)
abline(a=0,b=1, lty=2)
legend(lty=2,legend="decission\nboundary",x="topleft")
dev.off()
pdf("plots/afdcsu.pdf")
plot(dat[c("afd","csu")], xlim=c(-2,4), ylim=c(-2,4))
abline(v=0)
abline(h=0)
abline(a=0,b=1, lty=2)
legend(lty=2,legend="decission\nboundary",x="topleft")
dev.off()
pdf("plots/fdpgruene.pdf")
plot(dat[c("fdp","gruene")], xlim=c(-2,4), ylim=c(-2,4))
abline(v=0)
abline(h=0)
abline(a=0,b=1, lty=2)
legend(lty=2,legend="decission\nboundary",x="topleft")
dev.off()

rm(list=ls())
# Most learned words
load("data/most_learned_words.rda")
xtable(head(dat[1:4],30))
xtable(head(dat[5:8],30))

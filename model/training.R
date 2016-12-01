#!/usr/bin/Rscript
# -*- encoding: utf-8 -*-
# training.R
#
# (c) 2016 Marc Weitz <marc.weitz [at] trybnetic.org>
# GPL 3.0+ or (cc) by-sa (http://creativecommons.org/licenses/by-sa/3.0/)
#
# created 2016-09-22
# last mod 2016-11-19 MW
#

library(ndl2)

FILE_PATH = "data/event_file.tab"
TMP_FILE_PATH = "data/event_file.tmp"

events <- read.table(FILE_PATH, header=T)

#' slices a vector in n sequences
#'
#' @param x A vector
#' @param n A number
#' @return A list of vectors
slice<-function(x,n) {
    N <- length(x);
    lapply(seq(1,N,n),function(i) x[i:min(i+n-1,N)])
}

#' calculates the activation for a set of cues
#'
#' @param cue A string
#' @param all_cues A vector of all cues
#' @param wm A weight matrix
#' @return The activation for a set of cues
activate <- function(cue, all_cues, wm) {

        cue <- as.character(cue)

        cue_vec <- strsplit(cue,"_")

        input <- all_cues %in% cue_vec[[1]]

        activation <- t(input) %*% wm

        return(activation)
}

#' Helper for the cross-validation
#'
#' @param part_list vector of the cues which should be left out
#' @return activations for the left out cues
loocv_helper <- function(part_list) {

        tmp_events <- events[!(events$cues %in% part_list),]
        write.table(tmp_events, file=TMP_FILE_PATH, sep="\t", row.names=F, quote=F)

        learner <- learnWeightsTabular(TMP_FILE_PATH, alpha=0.1, beta=0.1, numThreads=16, verbose=TRUE, useExistingFiles=FALSE)

        wm <- learner$getWeights()

        all_cues <- learner$getCues()

        activations <- NULL

        for (cue in part_list) {
                cue <- as.character(cue)

                cue_vec <- strsplit(cue,"_")

                input <- all_cues %in% cue_vec[[1]]

                activation <- t(input) %*% wm

		activations <- rbind(activations, activation)

        }

        return(activations)

}

#' Leave-one-out-cross-validation
#'
#' @param lst A vector of all cues
#' @param chunksize A number of how many cues should be in one chunk
#' @return The activation matrix with the activations for all outcomes
loocv <- function(lst, chunksize) {
        part_lists <- slice(lst, chunksize)

        activation_matrix <- Reduce(rbind, sapply(part_lists, loocv_helper), NULL)

        return(activation_matrix)
}

activations <- loocv(events$cues, 1000)

dat <- as.data.frame(activations)

dat$max <-  apply(dat, 1, which.max)
dat$predicted <- "NA"
dat[dat$max == 1,]$predicted <- "afd"
dat[dat$max == 2,]$predicted <- "cdu"
dat[dat$max == 3,]$predicted <- "csu"
dat[dat$max == 4,]$predicted <- "fdp"
dat[dat$max == 5,]$predicted <- "gruene"
dat[dat$max == 6,]$predicted <- "linke"
dat[dat$max == 7,]$predicted <- "npd"
dat[dat$max == 8,]$predicted <- "spd"

dat$outcome <- events$outcomes

dat <- dat[c("afd","cdu","csu","fdp","gruene","linke","npd","spd","predicted","outcome")]
save(dat, file="activations.rda")

## Overall Modell
learner <- learnWeightsTabular(FILE_PATH, alpha=0.1, beta=0.1, numThreads=16, verbose=TRUE, useExistingFiles=FALSE)
wm <- learner$getWeights()
save(wm, "data/weightmatrix.rda")

most_learned_words <- data.frame(afd=rownames(weight_matrix[order(weight_matrix$afd, decreasing=TRUE),]),
 				 cdu=rownames(weight_matrix[order(weight_matrix$cdu, decreasing=TRUE),]),
                                 csu=rownames(weight_matrix[order(weight_matrix$csu, decreasing=TRUE),]),
                                 fdp=rownames(weight_matrix[order(weight_matrix$fdp, decreasing=TRUE),]),
                                 gruene=rownames(weight_matrix[order(weight_matrix$gruene, decreasing=TRUE),]),
                                 linke=rownames(weight_matrix[order(weight_matrix$linke, decreasing=TRUE),]),
                                 npd=rownames(weight_matrix[order(weight_matrix$npd, decreasing=TRUE),]),
                                 spd=rownames(weight_matrix[order(weight_matrix$spd, decreasing=TRUE),]))

dat <- most_learned_words
save(dat, "data/most_learned_words.rda")


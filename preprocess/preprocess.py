#!/usr/bin/python3
# -*- encoding: utf-8 -*-
# preprocess.py
#
# (c) 2016 Marc Weitz <marc.weitz [at] trybnetic.org>
# GPL 3.0+ or (cc) by-sa (http://creativecommons.org/licenses/by-sa/3.0/)
#
# created 2016-09-11
# last mod 2016-11-19 MW
#

import re
import os
import random

PARTIES = ["afd","csu","gruene","npd","cdu","fdp","linke","spd"]

TEMP_FILE = "event_file.tmp"

EVENT_FILE_PATH = "event_file.tab"

def parse_party(party):
    with open(party + ".txt", "r") as input_file:
        with open(TEMP_FILE, "a") as output_file:
            content = input_file.read()
            posts = content.split("\n")

            for post in posts:
                post = post.replace('+++ TEILEN +++ TEILEN +++ TEILEN +++',"")

                post = re.sub(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)', ' ', post).strip()
                post = re.sub(r'#\w+', '', post).strip()
                post = re.sub(r'@\w+', '', post).strip()
                post = re.sub(r'\w+€', '', post).strip()

                for char in ["\t","'","^H","’","#","+",">","<",";","%","-",'"',"„","“",".",",","!",":","/","\\","(",")","?","1","2","3","4","5","6","7","8","9","0","&"]:
                    post = post.replace(char," ")

                post = post.lower()
                post = " ".join(post.split()).strip()
                post = re.sub(r'\s+', '_', post).strip()
                if post:
                   output_file.write(post + " " + party + "\n")


def shuffle_file(in_file, out_file):
    with open(in_file, "r") as input_file:
        with open(out_file, "a") as output_file:
            content = input_file.read()
            lines = content.split("\n")
            random.shuffle(lines)
            for line in lines:
                if len(line.split(" ")) == 2:
                    cues, outcomes = line.split()
                    if cues and outcomes:
                        output_file.write("%s\t%s\t%s\n" % (cues, outcomes, 1))
                    else:
                        print(cues + " " + outcomes)


### Beginn Skript
with open(EVENT_FILE_PATH, "a") as output_file:
    output_file.write("cues\toutcomes\tfrequency\n")
for party in PARTIES:
    parse_party(party)

shuffle_file(TEMP_FILE,EVENT_FILE_PATH) 
os.remove(TEMP_FILE)

#!/usr/bin/env python

from pyspark import SparkContext
from nltk.tokenize import word_tokenize
from argparse import ArgumentParser

args = ArgumentParser()
args.add_argument("-u", "--url", help="spark cluster URL")
args.add_argument("-o", "--output", default="tokens.out", help="output file")
opts = args.parse_args()


print(opts.url)
sc = SparkContext(opts.url, "Tokenizer")
text = sc.textFile("/gscratch/stf/kearnsw/freebase-rdf-latest")
tokens = text.flatMap(lambda line: word_tokenize(line))
tokens.saveAsTextFile("/gscratch/stf/kearnsw/{0}".format(opts.output))


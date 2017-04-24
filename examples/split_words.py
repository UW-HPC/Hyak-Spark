#!/usr/bin/env python

from pyspark import SparkContext
from nltk.tokenize import word_tokenize

sc = SparkContext()
text = sc.textFile("/gscratch/stf/kearnsw/corpora/MSMARCO/train_v1.1.json")
tokens = text.flatMap(lambda line: word_tokenize(line))
tokens.saveAsTextFile("tokens.out")


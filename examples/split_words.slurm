#!/bin/bash

########################################
# Scheduler Parameters                 #
#SBATCH --job-name=Tokenize            #
#SBATCH --nodes=2                      #
#SBATCH --time=0:15:00                 #
#SBATCH --mem=32G                      #
########################################

########################################
# Load Anaconda and set up environment #
########################################
module load anaconda2_4.3.1
source activate deeplearning
export PYTHONIOENCODING=utf8

########################################
# Set up spark cluster                 #
########################################
mkdir $HOME/tmp
scontrol show hostname > $HOME/tmp/nodelist

MASTER=$(head -n 1 $HOME/tmp/nodelist)
WORKERS=$(tail -n +2 $HOME/tmp/nodelist)

LOG=$(bash $SPARK_HOME/sbin/start-master.sh)
LOG_FILE=$(echo $LOG | grep -oPe "/sw/.*?$")

cat $LOG_FILE | grep -oPe "spark://.*?$" > $HOME/tmp/master.url

for worker in $WORKERS; do
    ssh $worker 'bash $SPARK_HOME/sbin/start-slave.sh $(cat $HOME/tmp/master.url)'
done

########################################
# Run pySpark code                     #
########################################
python split_words.py


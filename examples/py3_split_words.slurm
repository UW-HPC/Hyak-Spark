#!/bin/bash

########################################
# Scheduler Parameters                 #
#SBATCH --job-name=Tokenize            #
#SBATCH --nodes=2                      #
#SBATCH --time=0:30:00                 #
#SBATCH --mem=122G                     #
########################################

########################################
# Load Anaconda and set up environment #
########################################
module load anaconda3_4.3.1
source activate deeplearning
export PYTHONIOENCODING=utf8

########################################
# Set up spark cluster                 #
########################################

echo "Generating nodelist..."
mkdir $HOME/tmp
scontrol show hostname > $HOME/tmp/nodelist
MASTER=$(head -n 1 $HOME/tmp/nodelist)
WORKERS=$(tail -n +2 $HOME/tmp/nodelist)
MASTER_URL="spark://$MASTER.hyak.local:1970"

echo "Starting coordinator node and worker on $MASTER ..."
bash $SPARK_HOME/sbin/start-master.sh -p 1970
bash $SPARK_HOME/sbin/start-slave.sh $MASTER_URL

echo "Connecting workers to $MASTER_URL ..."
for worker in $WORKERS; do
    echo "Starting worker process on $worker ..."
    ssh $worker "module load anaconda3_4.3.1; source activate deeplearning; bash $SPARK_HOME/sbin/start-slave.sh $MASTER_URL"
done

########################################
# Run pySpark code                     #
########################################
echo "Running python script..." 
python split_words.py --url $MASTER_URL --output $1


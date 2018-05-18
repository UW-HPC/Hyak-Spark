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
source activate py2 
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
MASTER_URL=$(cat $HOME/tmp/master.url)
echo $MASTER_URL

bash $SPARK_HOME/sbin/start-slave.sh $MASTER_URL

for worker in $WORKERS; do
    ssh $worker "module load anaconda2_4.3.1; source activate py2; bash $SPARK_HOME/sbin/start-slave.sh $MASTER_URL"
done

########################################
# Run pySpark code                     #
########################################
echo "Running python script..." 
python split_words.py --url $MASTER_URL --output tokens5


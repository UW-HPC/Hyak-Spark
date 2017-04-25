#!/bin/bash
#SBATCH --job-name=Tokenize
#SBATCH --nodes=2
#SBATCH --time=0:15:00
#SBATCH --mem=32G

# Load Anaconda and set up environment
module load anaconda2_4.3.1
source activate deeplearning
export PYTHONIOENCODING=utf8


# Set up spark cluster
scontrol show hostname > nodelist

MASTER=$(head -n 1 nodelist)
WORKERS=$(tail -n +2 nodelist)

NETID=$(whoami)

bash $SPARK_HOME/sbin/start-master.sh
MASTER_URL=$(cat $SPARK_HOME/logs/spark-$NETID-org.apache.spark.deploy.master.Master-1-$MASTER.out | grep -o "spark://.*")

for worker in $WORKERS; do
    ssh $worker
    bash $SPARK_HOME/sbin/start-slave.sh $MASTER_URL
done

ssh $MASTER
python split_words.py


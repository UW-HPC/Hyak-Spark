
 ```
     __  __            __      _____                  __  
    / / / /_  ______ _/ /__   / ___/____  ____ ______/ /__
   / /_/ / / / / __ `/ //_/   \__ \/ __ \/ __ `/ ___/ //_/
  / __  / /_/ / /_/ / ,<     ___/ / /_/ / /_/ / /  / ,<   
 /_/ /_/\__, /\__,_/_/|_|   /____/ .___/\__,_/_/  /_/|_|  
       /____/                   /_/                       
 ```
# Description
Sample scripts to run Spark jobs on Hyak

# Interactive Job Submission
1. Set $JAVA_HOME variable in your ~/.bashrc file to point to /sw/contrib/java/jdk1.8.0_111
2. Download Spark into your home directory and unpack:
``` shell
wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.1-bin-hadoop2.7.tgz
tar -xzvf spark-2.0.1-bin-hadoop2.7.tgz
```
3. Get nodes:
``` shell
qsub -I -l nodes=2:ppn=16,walltime=2:00:00
```
4. Find node ids:
``` shell
cat $PBS_NODEFILE | sort | uniq
```
5. Assign current node as master from within your spark directory:
``` shell
cd spark-2.0.1-bin-hadoop2.7
./sbin/start-master.sh
```
6. Find master node URL (replacing *username* with netid and n0*** with your master node number):
``` shell
cat logs/spark-*username*-org.apache.spark.deploy.master.Master-1-n0***.out | grep -o "spark://.*"
```
7. For each other assigned node ssh to that node and start a worker process (replace MASTER_NODE_URL with URL found in step 6):
``` shell
ssh n0***
cd spark-2.0.1-bin-hadoop2.7
./sbin/start-slave MASTER_NODE_URL
```
7. Return to master node and start interactive session:
``` shell
ssh n0***
cd spark-2.0.1-bin-hadoop2.7
./bin/spark-shell
```

Note: You can check to make sure you have assigned all nodes as workers by visiting http://localhost:8080:
``` shell
curl localhost:8080
```


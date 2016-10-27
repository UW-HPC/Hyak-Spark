
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
2. Get nodes:
qsub -I -l nodes=2:ppn=16,walltime=2:00:00

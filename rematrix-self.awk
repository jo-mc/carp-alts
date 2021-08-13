#! /usr/bin/awk -f


#/ Copyright ©2021 J McConnell  . All rights reserved.
#// Use of this source code is governed by a BSD-style
#// license that can be found in the LICENSE.txt file.


# rematrix-self builds and submits scripts to run 'krishna' for self vs self only (Pairwise Aligner for Long Sequences) using a set of fasta files.
# see rematrix.awk for some instructions.

BEGIN  {
#------------------ EDIT THIS SECTION ---------
# slurm settings:
threads = 8
time = "0-3:30:00"
mem = "64G"
mailUSER = "aX111111@student.adelaide.edu.au"
# krishna settings: (uses above threads)
filtid = 0.94
filtlen = 400
fastaExt = "fa"  # ie in driectory ./fa the fasta files are reads.fa etc.....  if you have read.fasta change this to fasta.
#------------------- END EDIT SECTION --------

print "Executing:", ENVIRON["_"], " PID:" PROCINFO["pid"]
printf("Self pairwise script generation and submit to phoenix\n")
printf("Job settings. Threads:>>> %d, Mem:>>> %s, Time:>>> %s, user:>>> %s\n",threads, mem,time,mailUSER)
printf("Krishna settings. filtid:--- %3.2f, filtlen:--- %3.2f\n",filtid,filtlen)
printf("Reading fasta files from ./fa with: >>> %s extension\n",fastaExt)
printf("Press 'Y' <enter> to continue.... if needed carefully edit settings in the edit section of this awk script.\n")
getline aContinue < "-"
if (aContinue != "Y") { print("you did not press Y, exiting "); exit 1}

sbtch = "#!/bin/bash\n" \
"#SBATCH -p skylakehm\n" \
"#SBATCH -N 1\n" \
"#SBATCH -n " threads "\n" \
"#SBATCH --time=" time "\n" \
"#SBATCH --mem=" mem "\n" \
"#SBATCH --gres=tmpfs:64G\n" \
"# Notification configuration\n" \
"#SBATCH --mail-type=FAIL\n" \
"#SBATCH --mail-user=" mailUSER "\n\n" \
"krishna -tmp=$TMPDIR -threads=" threads " -log -filtid=" filtid " -filtlen=" filtlen " -target="

command = "ls fa/*." fastaExt
x = 0
while ( (command | getline var) > 0) {
  x += 1; arr[x] = var
}
close(command)
print " Read " x " .fa file names"

for (i = 1; i <= x; i++) {
       fname = sprintf("scripts/%04d-%04d.sh",i,i)
       fout = sprintf("-%04d-%04d.gff",i,i)
       outbtch = sbtch  arr[i] " -self -out=gff/" substr(arr[i],4,length(arr[i])-6) fout "\n"
       print outbtch > fname
       # system("sleep 1");
       # command = "sbatch " fname
print "sbatch " fname
       # print command | "/bin/sh"
      }
}

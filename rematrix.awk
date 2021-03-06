#! /usr/bin/awk -f


#/ Copyright ©2021 J McConnell  . All rights reserved.
#// Use of this source code is governed by a BSD-style
#// license that can be found in the LICENSE.txt file.


# AWK reimplementation of https://github.com/biogo/examples/blob/master/krishna/matrix/matrix.go

# Customised for Adelaide Uni phoenix HPC,
# uses phoenix $TMPDIR which is currently only on high mem nodes: but should be on others at some stage!

# rematrix builds and submits scripts to run 'krishna' (Pairwise Aligner for Long Sequences) using a set of fasta files.

# Requirements

#    directory fa with your fasta files ~< 100M each
#    directory scripts (temp scripts written here)
#    directory gff where krishna outputs are written
#    update the email for failure messages from phoenix.

# Alter SBATCH settings as requried, current settings ran on 2G platypus genome, bundled to 80,000,000
# Also set krishna filters/flags as required.

# Issues: if jobs fail can be hard to track down (if hundreds of files, ie 10 or more regions to align), 
# will be in slurm log file, and email of fail will go to nominated user.

# To test if scripts are created correctly,
# comment out the two line with "command print...." you can then verify scripts.


BEGIN  {

sbtch = "#!/bin/bash\n" \
"#SBATCH -p skylakehm\n" \
"#SBATCH -N 1\n" \
"#SBATCH -n 8\n" \
"#SBATCH --time=0-03:30:00\n" \
"#SBATCH --mem=64GB\n" \
"#SBATCH --gres=tmpfs:64G\n" \
"# Notification configuration\n" \
"#SBATCH --mail-type=FAIL\n" \
"#SBATCH --mail-user=XXXXXX.YYYYYY@adelaide.edu.au\n\n" \
"krishna -tmp=$TMPDIR -threads=8 -log -filtid=0.94 -filtlen=400 -target="

#
#   note: REPLACE  -user=XXXXXX.YYYYYY@adelaide.edu.au with your EMAIL HERE!  replace xxxx.yyyy

command = "ls fa/*.fa"
x = 0
while ( (command | getline var) > 0) {
  # print var
  x += 1
  arr[x] = var
}
close(command)
print " Read " x " .fa files"

for (i = 1; i <= x; i++)
   for (j = i; j <= x; j++) {
       if ( i == j) {   # self
            outbtch = sbtch  arr[i] " -self -out=gff/" substr(arr[i],4,length(arr[i])-6) "-" i "-" j ".gff\n"
            print outbtch > "scripts/" i "-" j ".sh"
            # print i " " j " " arr[i]
            system("sleep 1");
            command = "sbatch scripts/" i "-" j ".sh"
            print command | "/bin/sh"
            
        } else {
            outbtch = sbtch  arr[i] " -query=" arr[j] " -out=gff/" substr(arr[i],4,length(arr[i])-6) "_" substr(arr[j],4,length(arr[j])-6) "-" i "-" j ".gff\n"
            print outbtch > "scripts/" i "-" j ".sh"
            # print i " " j " " arr[i]  " " arr[j]
            system("sleep 1");
            command = "sbatch scripts/" i "-" j ".sh"
            print command | "/bin/sh"
       }
   }


}


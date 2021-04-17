# carp-alts




---
 ### rematrix
 
 * AWK reimplementation of https://github.com/biogo/examples/blob/master/krishna/matrix/matrix.go
 > Customised for Adelaide Uni phoenix HPC, </br>
 > uses phoenix $TMPDIR which is currently only on high mem nodes: but should be on others at some stage! </br></br>
 > **rematrix builds and submits scripts to run 'krishna' (Pairwise Aligner for Long Sequences) using a set of fasta files.**
 
 * Requirements
 > directory fa with your fasta files   ~< 100M each</br>
 > directory scripts   (temp scripts written here)</br>
 > directory gff where krishna outputs are written</br>
 > update the email for failure messages from phoenix.

 *Alter SBATCH settings as requried, current settings ran on 2G platypus genome, bundled to 80,000,000 </br>
 Also set krishna filters/flags as required.*

 Issues: if jobs fail can be hard to track down (if hundreds of files, ie 10 or more regions to align), 
 will be in slurm log file, and email of fail will go to nominated user.

 To test if scripts are created correctly, </br>
 comment out the two line with "command print...."  you can then verify scripts.

---

### reslurm.awk
 Convert a phoenix slurm output script into csv data.


# carp-alts

[Convert phoenix output to CSV](#reslurmawk) </br>
[Repeat masker to censor format conversion](#reslurmawk)


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

---
### rptmskr-censor.awk
convert repeat masker annotation file to file to censor map file

repeat masker file: http://www.repeatmasker.org/webrepeatmaskerhelp.html

* Repeat masker annotation file sample:

| 1306 | 15.6 | 6.2 | 0.0 | HSU08988 | 6563 | 6781  | (22462) | C | MER7A   | DNA/MER2_type  |  (0) |  336 |  103 |
| - | - | - | - | - | - | - | - | - | - | - | - | - | - |
| 279 | 3.0 | 0.0 | 0.0 | HSU08988 | 7719 | 7751  | (21492) | + | (TTTTA)n | Simple_repeat  |    1  |  33  | (0) |


* The first line is interpreted like this:
>  1306    = Smith-Waterman score of the match, usually complexity adjusted. The SW scores are not always directly comparable. Sometimes the complexity adjustment has been turned off, and a variety of scoring-matrices are used.</br>
>  15.6    = % substitutions in matching region compared to the consensus</br>
>  6.2     = % of bases opposite a gap in the query sequence (deleted bp)</br>
>  0.0     = % of bases opposite a gap in the repeat consensus (inserted bp)</br>
>  HSU08988 = name of query sequence</br>
>  6563    = starting position of match in query sequence</br>
>  7714    = ending position of match in query sequence</br>
>  (22462) = no. of bases in query sequence past the ending position of match</br>
>  C       = match is with the Complement of the consensus sequence in the database</br>
>  MER7A   = name of the matching interspersed repeat</br>
>  DNA/MER2_type = the class of the repeat, in this case a DNA transposon fossil of the MER2 group (see below for list and references)</br>
>  (0)     = no. of bases in (complement of) the repeat consensus sequence prior to beginning of the match (so 0 means that the match extended all the way to the end of the repeat consensus sequence)</br>
>  2418    = starting position of match in database sequence (using top-strand numbering)</br>
>  1465    = ending position of match in database sequence</br>

* Censor Format of the Map of Repeats:  https://www.girinst.org/censor/help.html#MAP

| Name | From | 	 To 	|   Name |	      From 	| To | 	 Class |    Dir |	Sim |	   Pos |	 Score |
| - | - | - | - | - | - | - | - | - | - | - |
| N48 | 21018 |	21158 |	ZMCOPIA1_I |	33 |	  170 |	LTR/Copia |	c 	|  0.7154 |	0.72 |	208 |

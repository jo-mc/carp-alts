#! /bin/awk -f

#/ Copyright ©2021 J McConnell  . All rights reserved.
#// Use of this source code is governed by a BSD-style
#// license that can be found in the LICENSE.txt file.

# parse a slurm output file for piping into a csv file, for downstream analysis
# for FILE in slurm*; do awk -f reslurm.awk $FILE; done > statsSlurm.csv

{
if ( NR == 1 ) { line1 = $0 }
if ( $0 ~ /^#HPC/ ) { lp = NR }

if ( lp > MR ) {
n = split($0,arr,": ")
#if ( n > 1 ) {
#	m = split(arr[2],brr)   # default separator = space(s)
#	printf("%s,",brr[1])
#	coma = index(brr[1],",")
#	if ( coma > 0 ) {
#		gsub(/,/, "-", brr[1])  # gsub replace all , with -
#	}
#	gsub(/,/, "-", brr[1])    # hmm should be ok of no , then do nothing?
#	slurmOut = slurmOut  brr[1] ","

if ( n > 1 ) {
		sub(/\()/, "-",arr[2]) # in case empty () need something for alignment of columns to  be ok 
                sub(/)/, "",arr[2]) # remove closing )
                sub(/\(/, "",arr[2]) # remove opening ( 

	m = split(arr[2],brr," ")
	gsub(/,/, "-", brr[1])    # replace  comma, slurm can put in a comma "cancelled,timeout" 
	sub(/[ \t]+/, "",brr[1])   # trim all whitespace
	slurmOut = slurmOut  brr[1] ","
	if (brr[2] != "") {
#		sub(/)/, "",brr[2]) # remove closing )
#		sub(/\(/, "",brr[2]) # remove opening (
#		if ( index(brr[2]," ") > 0 ) {
#			br2 = substr(brr[2],1,index(brr[2]," "))  
#		} else {
#			sub(/)/, "",brr[2]) # remove closing )
#		}
        slurmOut = slurmOut  brr[2] ","
	}
}


#	sub(/^[ \t]+/, "",arr[2])  # trim leading whitespace [space or tab]
#	gsub(/,/, "-", arr[2])     # replace comma with -
#	gsub(/ +/, ",", arr[2])    # replace multiple space with ,
#	gsub(/\(/, "", arr[2])
#       gsub(/\)/, "", arr[2])      # replace () around items. [they need to be escaped]
#	slurmOut = slurmOut  arr[2] ","

#}
}
}
END {
printf("%s",slurmOut)

# GET TARGET 
n = split(line1,arr,"-target=")
if ( n > 1 ) {
   #printf(" ))) %s",arr[2])
   m = split(arr[2],brr)
   cmnd = "ls -s "
   #printf(" +++ %s\n",brr[1])
   ( cmnd brr[1] ) | getline
   printf("%sK,%s",$1,$2)
}

# GET QUERY if not self o/w  two dummy placeholders for csv
n = split(line1,arr,"-query=")
if ( n > 1 ) {
   m = split(arr[2],brr)
   cmnd = "ls -s "
   ( cmnd brr[1] ) | getline
   printf(",%sK,%s",$1,$2)
} else {
   printf(",,")
}

# GET OUTPUT if completed 
if (index(slurmOut,"COMPLETED") > 1 ) { 
   n = split(line1,arr,"-out=")
   if ( n > 1 ) {
      m = split(arr[2],brr)
      i = index(brr[1],".gff")	
      if ( i > 1 ) {
         outfile = substr(brr[1],1,i+3)
         cmnd = "ls -s "
         ( cmnd outfile ) | getline
         printf(",%sK,%s",$1,$2)
#          printf(",%s",outfile)
      }			
   }
}


printf("\n")

#printf("%s\n",line1)
}

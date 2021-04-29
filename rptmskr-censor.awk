#! /usr/bin/awk -f

# Convert repeat masker format to censor format

# RUN:  awk -f rptmskr-censor.awk  [REPEATMAKER OUTPUT FILE]  > [CENSOR formatted FILE]
# example output to less to view : awk -f rptmskr-censor.awk testdna.fasta.ori.out | less -S

BEGIN { 
FS = "[[:space:]]+" 
}

{
if ($10 == "+") {
        if ((substr($13,1,1)  == "(") && (substr($13,length($13),1) == ")")) {
            printf("%s\t%s\t%s\t%s\t%s\t%s\td\t0\t0\t%s\n",$6,$7,$8,$11,$15,$14,$2);
        }
        else {
        printf("%s\t%s\t%s\t%s\t%s\t%s\td\t0\t0\t%s\n",$6,$7,$8,$11,$13,$14,$2);
        }
}

if ($10 == "C") {
        if ((substr($13,1,1)  == "(") && (substr($13,length($13),1) == ")")) {
            printf("%s\t%s\t%s\t%s\t%s\t%s\tc\t0\t0\t%s\n",$6,$7,$8,$11,$15,$14,$2);
        }
        else {
        printf("%s\t%s\t%s\t%s\t%s\t%s\tc\t0\t0\t%s\n",$6,$7,$8,$11,$13,$14,$2);
        }
}

}

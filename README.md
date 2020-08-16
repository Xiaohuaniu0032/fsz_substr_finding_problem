# fsz_substr_finding_problem
find all positions of a query string in a long sequence using exact matching

Use two methods:
>1. the simplest backwards shift iteratively (for every step, the offset length is +1)
>2. use Boyer-Moore (BM) algorithm

## Usage
>use simplest method:

`perl find_subseq.pl -fa test.fa -s ATAT -o kmer1.txt`


>use BM algorithm:

`perl str_BM.pl -fa test.fa -s ATAT -o kmer1.txt.BM`

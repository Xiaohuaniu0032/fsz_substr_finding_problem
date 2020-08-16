# 使用最简单的向后移位方法
perl find_subseq.pl -fa test.fa -s ATAT -o kmer1.txt
perl find_subseq.pl -fa test.fa -s AGCT -o kmer2.txt

# 使用Boyer-Moore算法
perl str_BM.pl -fa test.fa -s ATAT -o kmer1.txt.BM
perl str_BM.pl -fa test.fa -s AGCT -o kmer2.txt.BM


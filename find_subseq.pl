use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;

my ($fa, $queryseq, $outfile);

GetOptions(
    "fa:s" => \$fa,
    "s:s" => \$queryseq,
    "o:s" => \$outfile,
    ) or die "unknown args\n";


open O, ">$outfile" or die;
print O "chr\tstart\tseq\n";


# cat seq into long string
my %chr2seq;
my $chr;
open FA, "$fa" or die;
while (<FA>){
    chomp;
    if (/>chr/){
        $chr = $_;
        $chr =~ s/^\>chr//;
        $chr2seq{$chr} = "";
    }else{
        my $seq = uc($_);
        my $new = $chr2seq{$chr}.$seq;
        $chr2seq{$chr} = $new;
    }
}
close FA;

foreach my $chr (sort {$a <=> $b} keys %chr2seq){
    # print "$chr\n";
    my $seq = $chr2seq{$chr};
    my $seq_len = length($seq);
    print "processing chr $chr, chr len is $seq_len bp\n";
    my $query_len = length($queryseq);
    for (my $i=0;$i<=$seq_len-$query_len;$i++){
        my $ss = substr($seq,$i,$query_len);
        if (uc($queryseq) eq $ss){
            my $pos = $i + 1;
            print O "$chr\t$pos\t$ss\n";
        }
    }
}

# print(Dumper(\%chr2seq));
close O;

# besides the method above, we can also use the Burrows-Wheeler transform (BWT) and exact-matching algorithm to do the substring finding jobs.

# setp1: for each chr, connect all line of sequence of this chr into one long sring (S);
# step2: do BWT for string S, we can get a BWT Matrix for S (in this step, we will use several auxiliary data structure to store the BWT Matrix and its origin seq information);
# step3: for queryseq, first find the line(s) in BWT Matrix that start(s) with the last character in queryseq; then find the line(s) among above BWT Matrix lines that start(s) with the last two character in queryseq; repeat this process until we reach the first character in queryseq;
# step4: given the line(s) in BWT Matrix, we can get the queryseq position in this chr using the auxiliary data structure made in sept 2.



# besides the method above, we can also use a simper way to do the exact substring finding jobs.
# step1: for each chr, get all positions of the first character in queryseq (this step will narrow the searching space);
# step2: given the positions of the first character of queryseq, find the positions of the first two characters in queryseq; repeat this process until we find all the positions of this entire queryseq in this chr;





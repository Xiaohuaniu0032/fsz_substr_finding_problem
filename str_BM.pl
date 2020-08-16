use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;

# use Boyer-Moore algorithm

my ($fa, $queryseq, $outfile);

GetOptions(
    "fa:s" => \$fa,
    "s:s" => \$queryseq,
    "o:s" => \$outfile,
    ) or die "unknown args\n";


open O, ">$outfile" or die;
print O "chr\tstart\tseq\n";

my @q = split //, $queryseq;

# assume fa format is:
# >chr1
# ATCT.......ATCG (one line)
# >chr2
# ATCT.......ATCG (one line)

open FA, "$fa" or die;
while (<FA>){
    chomp;
    my $chr = $_;
    $chr =~ s/^\>chr//;
    my $seq = <FA>;
    chomp $seq;

    my $qlen = length($queryseq);
    my $slen = length($seq);

    next if ($qlen > $slen);

    my $pos = 0;
    while ($pos <= $slen - $qlen){
        my $ss = substr($seq,$pos,$qlen);
        my @ss = split //, $ss;

        if (uc($queryseq) eq uc($ss)){
            my $idx = $pos + 1;
            print O "$chr\t$idx\t$queryseq\n";
            $pos += 1;
        }else{
            if (uc($ss[-1]) ne uc($q[-1])){
                # 最后一位不同,使用bad chr规则
                my $shift_pos = &bad_chr_shift($queryseq,$ss);
                $pos += $shift_pos;
            }else{
                # 最后一位相同,使用good suffix规则
                my $shift_pos = &good_suffix_shift($queryseq,$ss);
                $pos += $shift_pos;
            }
        }
    }
}
close FA;
close O;



sub bad_chr_shift{
    # 使用bad chr规则计算偏移量

    my ($q,$s) = @_; # q for queryseq, s for searching seq

    my $shift_pos;

    my @q = split //, $q;
    my @s = split //, $s;

    # 检查s[-1]是否在q中出现
    my $f = &chr_check($s[-1],$q);
    if ($f == 0){
        # 没出现
        # 直接跳过length($q)个碱基

        $shift_pos = (length($q) - 1) + 1;
    }else{
        # 出现
        # 检查s[-1]在q中出现的位置,取靠右pos
        my $idx = 0;
        my @pos;
        for my $q (@q){
            if (uc($q) eq uc($s[-1])){
                push @pos, $idx;
            }
            $idx += 1;
        }
        $shift_pos = (length($q) - 1) - $pos[-1];
    }

    return($shift_pos);
}


sub good_suffix_shift{
    # 使用good suffix规则计算偏移量
    # 如果最后一位相同,检查s[-1]在q中的上一个位置

    my ($q,$s) = @_; # q for queryseq, s for searching seq
    
    my @q = split //, $q;
    my @s = split //, $s;

    my $shift_pos;

    my $idx = 0;
    my @pos;
    for my $q (@q){
        if (uc($q) eq uc($s[-1])){
            push @pos, $idx;
        }
        $idx += 1;
    }

    if (@pos == 1){
        $shift_pos = (length($q) - 1) + 1;
    }else{
        $shift_pos = (length($q) - 1) - $pos[-2];
    }
    
    return($shift_pos);
}

sub chr_check{
    # 检查一个字符串中是否出现特定一个字符
    my ($c,$s) = @_;
    my $flag = 0;
    my @s = split //, $s;
    for my $s (@s){
        if (uc($c) eq uc($s)){
            $flag += 1;
        }
    }

    return($flag);
}
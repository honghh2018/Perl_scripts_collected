#!/usr/bin/perl -w
use strict;
use warnings;
use GetOpt::Long;
use Cwd qw(abs_path getcwd);
use FindBin '$Bin';



#getoptions
my($infasta,$outfile);
GetOptions(
  "config:s"  =>\$infasta,
  "outdir:s" =>\$outfile,
  "h|?" =>\&USAGE,
) or &USAGE;
&USAGE unless($infasta and $outfile);

open(my $in,"$infasta") or die "$!";
open(my $out,">statistic.result");
print $out "chr","\t","GC_ratio","\t","N_ratio","\t","Length","\t","N","\t","G","\t","T","\t","C","\t","A","\n";

my %genome=();
$/=">";
while(<$in>){
  chomp;
  next if(^$);
  my($gene_id,$seq)=(split/\n/,$_,2);
  $seq=~s/\n//g;
  $genome{$gene_id}=$seq;
}
close $in;
$/="\n";

for my $key(keys %genome){
  my $count_N=($genome{$key} =~tr/Nn//);
  my $count_C=($genome{$key} =~tr/Cc//);
  my $count_G=($genome{$key} =~tr/Gg//);
  my $count_T=($genome{$key} =~tr/Tt//);
  my $count_A=($genome{$key} =~tr/Aa//);
  my $length=length($genome{$key});
  my $GC=($count_C+$count_G)/$length;
  my $N_ratio=$count_N/$length;
  print $out "$key","\t","$GC","\t","$N_ratio","\t","$length","\t","$count_N","\t","$count_G","\t","$count_T","\t","$count_C","\t","$count_A","\n";
}

close $out;











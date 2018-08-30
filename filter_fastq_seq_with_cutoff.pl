#!/usr/bin/perl
use strict;
use warnings;
use FindBin '$Bin';
use Cwd qw(abs_path getcwd);
use File::Basename qw(dirname fileparse basename);
use Getopt::Std;

#GetOptions
my %para;
GetOptions(\%para,"fastq=s","od=s","cutoff=s","h");
if(!defined $para{fastq} and !defined $para{od} and !defined $para{cutoff}){
  &USAGE();  #the bracket can omit
}

open(my $in,"$para{fastq}") or die "$!";
open(my $out,"> $para{od}");
for(<$in>){
  chomp;
  my $gene_id=$_;
  my $seq=<$in>;
  my $mark=<$in>;
  my $qual=<$in>;
  my($begin,$end)=split(/\-/,$para{cutoff});
  my $length=length($seq);
  if($begin<$length && $length<$end){
    print $out $gene_id,"\n";
    print $out $seq,"\n";
    print $out $mark,"\n";
    print $out $qual,"\n";
  }
}


sub USAGE{
  my $usage=<<"USAGE";
  ---------------------------------
  Contact:honghh\@biomarker.com.cn
  USAGE:
    -fasta fasta file,force
    -od output file,file
    -cutoff force
  ---------------------------------
  print $usage;
  exit(1);
}

#!/usr/bin/perl
use strict;
use warings;
use Cwd qw(abs_path getcwd);
use FindBin '$Bin';
use Getopt::Long;
use File::Basename qw(basename dirname fileparse);

my($fastq,$od);
GetOptions(
  "fq:s" => \$fastq,
  "od:s" => \$od,
  "h|?" => \$USAGE,
) or &USAGE;
&USAGE unless(!defined $fastq and !defined $od);

if(-e $od){
  print "output file must be defined!\n";
  exit(1);
}
if(-f $fastq){
  print "work start\n";
}

open(my $in,"$fastq") or die "$!";
open(my $out,">","$od");
my %fastq=();
while(<$in>){
  chomp;
  my $seq=<$in>;
  <$in>;
  <$in>
 $fastq{$seq}++;
}
close $in;

for my $key(keys %fastq){
  print $out $fastq{$key},"\n";
  print $out $key,"\n";
}

close $out;


sub USAGE{
  my $usage=<<USAGE;
  ------------------------------------
  Usage:
  -fq fastq file,forced
  -od file,forced,
  -h help
  ------------------------------------
  print $usage;
  exit(1);
}











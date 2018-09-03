#!/usr/bin/perl
use strict;
use warings;
use Getopt::Long;

my($infile,$outfile);
Getoptions(
  "infile:s" => \$infile,
  "outfile"  => \$outfile,
  "h|?"      => \&USAGE,
) or &USAGE;

&USAGE if(!defined $infile and !defined $outfile);

open(IN,"$infile") or die "$!";
open(OUT,">$outfile");
foreach my $line(<IN>){
  chomp $line;
  my $read_id=$line;
  chomp(my $seq=<IN>);
  chomp(my $mark=<IN>);
  chomp(my $qua=<IN>);
  my $length=length($seq);
  if(60<=$length && $length<=80){
    print OUT $read_id,"\n";
    print OUT $seq,"\n";
    print OUT $mark,"\n";
    print OUT $qua,"\n";
  }
}
close IN;
close OUT;

sub USAGE{
  my $usage=<<"USAGE";
  ------------------------------
  -infile fastq,forced
  -outfile output file,forced
  -h      help
  ------------------------------
USAGE
print $usage;
exit;
}

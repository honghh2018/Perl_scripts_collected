#!/usr/bin/perl
use strict;
use FindBin '$Bin';
use Cwd qw(abs_path getcwd);
use File::basename wq(basename dirname);
use Getopt::Long;

my %getopts;
Getoptions(\%getopts,"infile=s","outfile=s","width=s","h");
&USAGE if(!defined $getopts{infile} and !defined $getopts{outfile} and $getopts{width} and $getopts{h});

if($getopts{width}<10 && $getopts{width}>200){
  print "your width parameter wrong,please try 10-200\n";
  exit;
}

$/=">";
my %fasta=();
open(my $in,"$getopts{infile}") or die "$!";
open(my $out,">"," $getopts{outfile}");
foreach my $line(<$in>){
  chomp($line);
  next if($line =~/^$/);
  my($gene_id,$seq)=split(/\n/,$line,2);
  $seq =~s/\n//g;
  $fasta{$gene_id}=$seq;
}
$/="\n";
close $in;

foreach my $key(keys %fasta){
  print ">",$out $key,"\n";
  my $length=length($fasta{$key});
  for(my $i=0;$i<=$length;$i +=$getopts{width}){
    my $substr=substr($fasta{$key},$i,$getopts{width});
    print $out $substr,"\n";
  }
}

close $out;

sub USAGE{
  my $usage=<<"USAGE";
----------------------------------
  -infile fasta file,forced
  -outfile file,forced
  -width   10-200
  -h       help
----------------------------------
USAGE
}

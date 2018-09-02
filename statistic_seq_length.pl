#!/usr/bin/perl
use strict;
use warings;
use Cwd qw(abs_path getcwd);
use FindBin '$Bin';
use Getopt::Long;
use File::Basename qw(basename dirname fileparse);


my($fasta,$od);
GetOptions(
  "fa:s" => \$fasta,
  "od:s" => \$od,
  "h|?" => \$USAGE,
) or &USAGE;
&USAGE unless(!defined $fastq and !defined $od);

if(!defined $fasta and !defined $od){
  print "program must get the input file\n";
  &graphic;
}

sub graphic{
  my $graphic_pi=<<"USAGE";
                .
                .
         ...............
        .       .
       .        .
     .       ........
   .          .    .
 .              .
.             .    .
USAGE   #must be flush left
print $graphic_pi;
exit(1);
}



my %seq=();
open(my $in,"$fasta") || die $!;
open(my $out,">","$od");

for my $line(<$in>){
  chomp $line;
  next if(/^\>/);
  my $length=length($line);
  $seq{$length}++;
}
close $in;
#print
foreach my $key(sort{$a<=>$b} keys %seq){
 print "$key","\n";
 print "$seq{$key}","\n";
}

close $out;

sub USAGE{
  my $usage=<<"USAGE";
  ----------------------------------
  -fa  input fasta file,forced
  -od  output file,forced
  -h   output help,selected
  ----------------------------------
USAGE
  print "$usage";
  exit(1);
}

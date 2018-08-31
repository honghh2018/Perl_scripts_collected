#!/usr/bin/perl -w
use strict;
use warnings;
use strict;
use Getopt::Long;
use Cwd qw(abs_path getcwd);
use FindBin '$Bin';
use Getopt::Long;
use File::Basename qw(basename dirname);

#GetOptions
my($fastq,$od,$seed)
GetOptions(
  "fq:s" => \$fastq,
  "od:s" => \$od,
  "ran:s" => \$seed,
  "h|?" => \&USAGE,
) or &USAGE;
&USAGE unless($fastq and $od and $seed);
my $begin_time=time();
$seed ||=2000;
my $randarr=();
my $a;
while($a<=$seed){
  my $value=rand($seed);
  push @randarr,$value;
  $a++;
}


my $count=0;
my %fasta=();
open(my $in,"$fastq") or die "$!";
open(my $out,">$Bin/result.fasta");
while(my $line=<$in>){
  chomp($line);
  my $gene_id=$line;
  $gene_id=~/@(.*)/;
  my $seq=<$in>;
  my $mark=<$in>;
  my $qua=<$in>;
  $fasta{$1}=[$seq,$count];
  $count++;
}

foreach my $key(keys %fasta){
    while(<@randarr>){
        if(${$fastq{$key}}[1]==$_){
          print $out ">",$key,"\n";
          print $out ${$fasta{$key}}[0],"\n";
        }
    }
}

close $in;
close $out;
my $end_time=();
print "elaspe time:","$end_time-$begin_time","\n";
print "
            .
      .............
      .      .     .  
     .       .
    .    .    .     .
  .       .        .
'         .       .

";

sub USAGE{
  my $usage=<<"USAGE";
  ---------------------------------
  Contact:honghh\@biomarker.com.cn
  USAGE:
    -fastq fastq file,force
    -od output file,file
    -rand cuoff value
    random_abstract_fastq_seq.pl -fastq <file> -od <file> -rand values[default 2000]
  ---------------------------------
  print $usage;
  exit(1);
}

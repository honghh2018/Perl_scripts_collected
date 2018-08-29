#!/usr/bin/perl -w
use strict;
use warnings;
use strict;
use Getopt::Long;
use Cwd qw(abs_path getcwd);
use FindBin '$Bin';
use Getopt::Long;
use File::Basename qw(basename dirname);

#getoptions
my($fasta,$od);
GetOptions(
  "fasta:s" =>\$config,
  "o:s" =>\$od,
  "h|?" =>\$USAGE,
) or &USAGE;
&USAGE unless($fasta and $od);
my $begin_time=time();
my $version="180829";
my %fasta=();
open(my $in,"$fasta") or die "$!";
mkdir "$Bin/Result" unless (-d "$Bin/Result");
open(my $out,"$Bin/Result/$od");
$/=">";
while(<$in>){
  chomp;
  next if(/^$/);
  my $Gene_id;
  my $seq;
  my $len;
  my($Gene_id,$seq)=split/\n/,$_,2;
  $Gene_id=$Gene_id =~/(.){10}/;
  $seq=$seq=~s/\n//g;
  $len=length($seq);
  $fasta{$Gene_id}{$seq}=$len;
}
$/="\n";
my $value;
foreach my $first(keys %fasta){
  foreach my $key(sort{$fasta{$first}{$b}<=>$fasta{$first}{$a}} keys %{$fasta{$first}}){
    if(exists  $fasta{$first}{$value}){
      if($value==$fasta{$first}{$key}){
          print $out $first,"----->";
          print $out $fasta{$first}{$key},"\n";
          print $out $key,"\n";
    }else{
      print $out $first,"----->";
      print $out $fasta{$first}{$key},"\n";
      print $out $key,"\n";
    }
    $value=$key;
    $value=$fasta{$first}{$value};
    }
  }
}
close $in;
close $out;
my $end_time=time();
print "Finish work,elapse time:$begin_time-$end_time\n";
my @array=();
foreach my $firstkey(keys %fasta){
  foreach my $secondkey(keys %{$fasta{$firstkey}}){
    push @array $fasta{$firstkey}{$secondkey};
  }
}
print "Length on sort with fasta:\n";
my $max_length=&bublesort(@array);
while(<@array>){
  print $_,"\n";
}
print "The max length:";
print "$max_length\n";

sub bublesort{
  my @arr=@_;
  for(my $i=0;$i<$#arr-1;$i++){
    for(my $j=0;$j<$#arr-$i-1;$j++){
      if($arr[j]<$arr[$j+1]){
          my $temp;
          $temp=$arr[j];
          $arr[j]=$arr[j+1];
          $arr[j+1]=$temp;
      }
    }
  }
  return $arr[0];
}


sub USAGE{
  my $usage=<<"USAGE";
  ---------------------------------
  Contact:honghh\@biomarker.com.cn
  USAGE:
    -fasta fasta file,force
    -od output file,file
  ---------------------------------
  print $usage;
  exit(1);
}

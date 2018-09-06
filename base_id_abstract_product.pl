#!/usr/bin/perl
use strict;
use warnings;
use FindBin '$Bin';
use Cwd qw(abs_path getcwd);
use File::Basename qw(dirname fileparse basename);
use Getopt::Std;

my($indir,$csv,$fpkm,$outfile);
Getoptions(
  "indir:s" => \$indir,
  "csv:s"   => \$csv,
  "fpkm:s"  => \$fpkm,
  "outfile:s"  => \$outfile,
  "h|?"      => \&USAGE,
) or &USAGE;

if(!-d $indir){
  die "your input dir no exist,please build it first";
}
my @file_arr=();
opendir(my $dir,"$indir");
foreach my $file(readdir $dir){
  next if($file eq '.' || $file eq '..');
  my $path=abs_path($file);
  push @file_arr,"$path/$file";
}
closedir($indir);
my $index=0;
my $count=0;
my @arr_sec=();
my %csv=();
my %fpkm=();
for(my $i=0;$i<$#file_arr;$i++){
  my $real_name=basename($file_arr[$i]);
  if($real_name=~/*\.list/){
    open(my $in,"$file_arr[$i]") or die "Can not open this file:$!";
    foreach my $line(<$in>){
      chomp($line);
      next  if($line =~/^\#/);
      $count++;
      $arr_sec[$index][$count]=$line;
    }
    $index++;
    close $in;
    if($real_name=~/*\.csv/){
      open(my $in,"$file_arr[$i]") or die "Can not open this file:$!";
      foreach my $csv(<$in>){
        chomp($csv);
        next  if($csv =~/^\#/);
        my ($id,$left)=split(/\s+/,$csv,2);
        $csv{$id}=$left;
      }
      close $in;
    }
    if($real_name =~/*\.fpkm\.*/){
      open(my $in,"$file_arr[$i]") or die "Can not open this file:$!";
      foreach my $fpkm(<$in>){
        chomp($fpkm);
        next if($fpkm=~/^\#/);
        my($id,$left)=split(/\s+/,$fpkm,2);
        $fpkm{$id}=$left;
      }
      close $in;
    }
  }
}
my $local=getcwd;
mkdir "$local/Result" unless -d "$local/Result";
open(my $out,">$local/Result/$outfile");
foreach my $a(0..$#arr_sec){
  foreach my $b(0..$#arr_sec[$a]){
     if(exists $csv{$arr_sec[$a][$b]} && exists $fpkm{$arr_sec[$a][$b]}){
       my $produce=split(/\s+/,$csv{arr_sec[$a][$b]})[0];
       my $fpkm_ex=split(/\s+/,$fpkm{arr_sec[$a][$b]})[0];
       print $out $arr_sec[$a][$b],"\t",$produce,"\t", $fpkm_ex,"\n";
     }
    }
  }
}
close $out;

sub USAGE{
  my $usage=<<"USAGE";
  ---------------------------------
  Contact:honghh\@biomarker.com.cn
  USAGE:
    -indir dir,force
    -csv file,force
    -fpkm file,force
    -outfile output file,
  ---------------------------------
USAGE
  print $usage;
  exit(1);
}

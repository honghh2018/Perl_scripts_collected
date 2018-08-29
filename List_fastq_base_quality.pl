#!/usr/bin/perl -w
use strict;
use warnings;
use File::Basename qw(dirname basename);
use FindBin '$Bin';
use Cwd qw(abs_path getcwd);
use Getopt::Long;


my($fastq,$quaASCII,$od);
GetOptions(
  "fastq:s" => \$fastq,
  "ascii:s" => \$quaASCII,
  "od:s"    => \$od,
  "h|?"     => \&USAGE,
) or &USAGE;
&USAGE unless ($fastq and $uaAscii and $od);


my %ascii=();
&read_quaASCII();
sub read_quaASCII{
  open($in,"$quaASCII") or die "$!";
  while(<$in>){
    chomp;
    my($character,$ascii)=split(/\s+/);
      $ascii{$character}=$ascii;
  }
  close $in;
}


my $abs_file=abs_path($od);
mkdir "$abs_file/Result" unless -d "$abs_file/Result";
open(my $out,"$abs_file/Result");
my $count=0;
while(<$in>){
  chomp;
  if($count % 4==0){
    my $read_id=$_;
    print $out $read_id,"Tranfer quality score into numerical value","\n";
  }elsif($count % 4 ==1){
    my $read_seq=$_;
    print $out $read_seq,"\n";
  }elsif($count % 4 ==2){
    my $read_mark=$_;
    print $out $read_mark,"\n";
  }elsif($count % 4 ==3){
    my $read_qua=$_;
    my @temp=split(//,$_);
    while(<@temp>){
      if(exists $ascii{$_}){
        my $err_probability=&exponent($ascii{$_});
        print $out $format,":";
      }
      print $out,"\n";
    }
  }
  $count++;
}


sub exponent{
  my $n=shift;
  my $res=10**(-0.1*$n);
  my $format=sprintf("%-5.4s",$res); # - left alignment,interval space for 5
  return $format;
}

sub USAGE{
    my $usag=<<"USAGE";
    ----------------------------------------------------
    Manual page:
      Contact:honghh\@biomarker.com.cn
    Usage:
      Options:
      -fastq fastq file,forced;
      -ascii file,forced;
      -od output file;
      -h  show the help;
    Example:
      List_fastq_base_quality.pl -fastq <file> -ascii <file> -od <file>
    ----------------------------------------------------
    USAGE
    print $usage;
    exit(1);
}

__END__
ascii file format below:
! 0
" 1
# 2
$ 3
% 4
& 5
...

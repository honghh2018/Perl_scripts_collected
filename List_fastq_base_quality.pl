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
  "od:s"    => \$od,
  "h|?"     => \&USAGE,
) or &USAGE;





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








my $count=0;
while(<$in>){
  chomp;
  if($count % 4==0){
    my $read_id=$_;
    print $out $read_id,"Tranfer qua into numerical value","\n";
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
        my $
      }

    }
  }
  $count++;
}


sub log10{
  my $n=shift;
  return 10
}

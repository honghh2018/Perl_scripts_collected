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
&USAGE if(!defined $fasta and !defined $od);
my $firsttime=localtime(time());
my $begin_time=&getFormatTime($firsttime);
print "Time to start:","$begin_time","\n";
my $localpath=getcwd;
mkdir "$localpath/Result" unless (-d "$localpath/Result");
open(my $in,"$fasta") or die "$!";
chdir "$localpath/Result" unless (-d "$localpath/Result");
my $localpath_1=getcwd;
my $file_name=basename($fasta);
my $program_dir=dirname($0);
open(my $out,">$localpath_1/$file_name.list");
$/=">";
for(<$in>){
  next if(/^$/);
  my($gene_id,$seq)=(split/\n/,$_,2);
  $seq=~s/\n//g;
  $length=length($seq);
  print $out "$gene_id","seq_counts:","$length","\n";
  print $out $seq,"\n";
}
$/="\n";
close $in;
close $out;

for(my $i=0;$i<10;$i++){
  print "#";
  sleep(1);
}
print "\n";
my $end_time=time();
print "elapse time:","$end_time-$firsttime","\n";

sub getFormatTime{
        my($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst) = @_;
        $wday = $yday = $isdst = 0;
        my $format_time=sprintf("%4d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $day, $hour, $min, $sec);
        return $format_time;
}


sub USAGE{
  my $usage=<<USAGE;
  ------------------------------------
  Usage:
  -fa fasta file,forced
  -od file,forced,
  -h help
  ------------------------------------
  print $usage;
  exit(1);
}

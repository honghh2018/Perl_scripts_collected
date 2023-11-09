#!/usr/bin/perl -w
use Time::HiRes qw(gettimeofday);

open IN,"<737K-arc-v1.txt" or die $!;

my @arr;

while(my $line=<IN>){
  chomp $line;
  push @arr, $line;
}

close IN;

my $start_time=gettimeofday();

print "start time->",$start_time,"\n";

foreach my $line(@arr){
   chomp $line;
}

my $end_time=gettimeofday();
print "end time->",$end_time,"\n";
print "elapse->",$end_time - $start_time,"\n";

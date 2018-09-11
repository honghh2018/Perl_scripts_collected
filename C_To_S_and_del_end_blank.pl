#!/usr/bin/perl -w
use strict;
use warnings;

open(IN,"$ARGV[0]") or die "$!";
open(OUT,">$ARGV[1]");

while(<IN>){
        chomp;
        s/\_FPKM//g;
        #s/^\t*\n$//g;
        s/\,/\t/g;
        last if($_ =~/^\t/);
        print OUT $_,"\n";
}

close IN;
close OUT;

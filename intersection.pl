#!/usr/bin/perl -w
use strict;
use warnings;

open(my $in1,"$ARGV[0]") or die "$!";
open(my $in2,"$ARGV[1]") or die $!;
open(my $in3,"$ARGV[2]") or die "$1";
open(my $out,">gene_id_group1.txt");
my @array=();
while(<$in1>){
        chomp;
        next if(/^\#/);
        my $gene_id=(split /\s+/,$_)[0];
        while(my $line=<$in2>){
                chomp($line);
                next if($line=~/^\#/);
        my $gene_id_1=(split /\s+/,$line)[0];
        #print $gene_id_1;
                if($gene_id eq $gene_id_1){
                        push @array,$gene_id;
                }

        }
        #print @array;
}
for my $line1(<$in3>){
        chomp $line1;
        next if($line1=~/^\#/);
        my $gene_id=(split /\s+/,$line1)[0];
        for my $line2(@array){
                if($gene_id eq $line2){
                        print $out $gene_id,"\n";
                }
        }
}

close $in3;close $out;
close $in1;close $in2;

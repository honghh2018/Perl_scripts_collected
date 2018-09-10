#!/usr/bin/perl -w
use strict;
use warnings;

open(IN1,"$ARGV[0]") or die "$!";
open(IN2,"$ARGV[1]") or die "$!";
open(OUT,">$ARGV[2]");

my %collapse=();
$/=">";
while(<IN1>){
        chomp;
        next if(/^$/);
        my($id,$seq)=split(/\n/,$_,2);
        $collapse{$id}=$seq;    
}
close IN1;
$/="\n";
my %map=();
foreach my $line(<IN2>){
        chomp($line);
        my($gene_id,$left)=split(/\s+/,$line,2);
        if($collapse{$gene_id}){
                $map{$gene_id}=[$collapse{$gene_id},$left];
        }       
}

close IN2;
foreach my $key(keys %map){
        print OUT '>',$key,"\t",${$map{$key}}[1],"\n";
        print OUT ${$map{$key}}[0],"\n";
}

close OUT;

#!/usr/bin/perl -w
use strict;
use warnings;

open(IN1,"$ARGV[0]") or die "$!";
open(IN2,"$ARGV[1]") or die $!;
open(OUT,">$ARGV[2]");
my %seq=();
$/=">";
while(<IN2>){
        chomp;
        next if (/^$/);
        my($id,$seq)=split(/\n/,$_,2);
        $seq{$id}=$seq;         
}
close IN2;
$/="\n";
foreach my $line(<IN1>){
        chomp($line);
        if($line =~/^\#/){
                my ($id,$left)=split(/\s+/,$line,2);
                print OUT $id,"\t","miRNA_seq","\t",$left,"\n";
        }
        my($gene_id,$left1)=split(/\s+/,$line,2);
        if(exists $seq{$gene_id}){
                chomp($seq{$gene_id});
                print OUT $gene_id,"\t",$seq{$gene_id},"\t",$left1,"\n";
        }       

}
close IN1;
close OUT;

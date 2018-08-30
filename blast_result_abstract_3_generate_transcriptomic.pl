#!/usr/bin/perl -w
use strict;
use warnings;

open(my $in1,"$ARGV[0]") or die "$!";  #transcriptomic fasta
open(my $in2,"$ARGV[1]") or die "$!";  #blast -m 8 table filter awk command
open(my $out,">filter_result_fasta_1.txt");  #output file

my %fasta=();
$/=">";
for(<$in1>){
        chomp;
        next if(/^$/);
        my($gene_id,$seq)=split(/\n/,$_,2);
        $seq =~s/\n//g;
        $fasta{$gene_id}=$seq;
}
close $in1;
$/="\n";
while(<$in2>){  #use filter file to inquire transcription file(fasta),no reverse
        chomp;
        my $temp1=(split /\s+/,$_,2)[0];
        for my $key(keys %fasta){
                if($temp1 eq $key){
                        print $out ">",$_,"\n";
                        print $out $fasta{$key},"\n";
                }
        }
}
close $in2;
close $out;

__END__
USAGE:
blast_result_abstract_3_generate_transcriptomic.pl transcript.fasta filter_blast.txt

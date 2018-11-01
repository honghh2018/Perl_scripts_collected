#!/usr/bin/perl
use strict;
use warnings;

open(IN1,"$ARGV[0]") or die $!;
open(IN2,"$ARGV[1]") or die $!;
open(IN3,"$ARGV[2]") or die $!;

open(OUT,">blastn_result_m8.list");

my %query=();
my %subject=();
$/=">";
while(<IN1>){
	chomp;
	next if(/^$/);
	my ($gene_id,$seq)=(split /\n+/,$_)[0,1];
	my $length=length($seq);
	#print $gene_id,"\n";
	$query{$gene_id}=$length;	
}

while(<IN2>){
	chomp;
	next if(/^$/);
	my ($gene_id,$seq)=(split /\n+/,$_)[0,1];
	my $length=length($seq);
	#print $gene_id;
	 $subject{$gene_id}=$length;
}
$/="\n";

close IN1;
close IN2;
while(<IN3>){
	chomp;
	if(/subject/){
		print OUT "$_","sub_id","\t","sublength","\t","query","\t","query_length","\n";
		next;
	}
	my ($sub,$quer)=(split /\s+/,$_)[0,1];
	#print $sub,"\n";
	#print $quer,"\n";
	if(exists $query{$quer} && exists $subject{$sub}){
		print OUT $_,"\t",$sub,":",$subject{$sub},"\t",$quer,":",$query{$quer},"\n";
	}
}

close IN3;
close OUT;


#!/usr/bin/perl -w
use strict;
use warnings;
use Cwd qw(getcwd abs_path);



opendir(DIR,"$ARGV[0]") or die "Cannot open this dir";
open(OUT,">$ARGV[1]");
my $abs_path=abs_path($ARGV[0]);
my @sumfile=();
#print $abs_path,"\n";
for my $file(readdir DIR){
    next if($file eq "." || $file eq "..");
    push @sumfile,"$abs_path/$file";
}

my $count=@sumfile;
my $samplenum=0;
my @sortfile=sort{$a cmp $b} @sumfile;
	print OUT "Qphred","\t","33","\n";	
	for(my $i=0;$i<$count;$i +=2){
		$samplenum++;
		print OUT "Sample","\t","T".$samplenum,"\n";
		print OUT "fq1","\t",$sortfile[$i],"\n";
		print OUT "fq2","\t",$sortfile[$i+1],"\n";
	}

closedir DIR;
close OUT;


#USAGE
#perl pipe_data_config.pl cleandata result

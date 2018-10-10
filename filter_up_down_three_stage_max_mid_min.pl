#!/usr/bin/perl 
use strict;
use warnings;
use Getopt::Long;
use Cwd qw /getcwd abs_path/;
use File::Basename;
my ($infile);
GetOptions(
	"i:s" => \$infile,
);

my $filename=basename($infile);

open(IN,"$infile") or die "$!";
open(OUT,">$filename.result");

my %up=();
my %down=();
while(<IN>){
	chomp;
	next if(/^\#/);
	my($id,$FC,$regulated)=(split /\t/,$_)[0,14,15];
	#print $id,"\t",$FC,"\t",$regulated,"\n";
	if($regulated eq "up"){
		$up{$id}=$FC;
	}else{
		$down{$id}=$FC;
	}
}
my @up=();
my @down=();
for my $key(sort{$up{$a}<=>$up{$b}} keys %up){
	push @up,$key;
}
for my $key(sort{$down{$a}<=>$down{$b}} keys %down){
        push @down,$key;
}

print OUT "UP regulated gene\n";
#start up
for(my $i=0;$i<7;$i++){
	if(exists $up{$up[$i]}){
		print OUT "min","\t",$up[$i],"\t","up","\t",$up{$up[$i]},"\n";
	}
}
for(my $i=$#up/2-3;$i<=$#up/2+3;$i++){
        if(exists $up{$up[$i]}){
                print OUT "mid","\t",$up[$i],"\t","up","\t",$up{$up[$i]},"\n";
        }
}

for(my $i=$#up-7;$i<$#up;$i++){
        if(exists $up{$up[$i]}){
                print OUT "max","\t",$up[$i],"\t","up","\t",$up{$up[$i]},"\n";
        }
}

print OUT "#####################################################################################\n";
print OUT "DOWN regulated gene\n";
#start down
for(my $i=0;$i<7;$i++){
        if(exists $down{$down[$i]}){
                print OUT "max","\t",$down[$i],"\t","down","\t",$down{$down[$i]},"\n";
        }
}


for(my $i=$#down/2-3;$i<=$#down/2+3;$i++){
        if(exists $down{$down[$i]}){
                print OUT "mid","\t",$down[$i],"\t","down","\t",$down{$down[$i]},"\n";
        }
}

for(my $i=$#down-7;$i<$#down;$i++){
        if(exists $down{$down[$i]}){
                print OUT "min","\t",$down[$i],"\t","down","\t",$down{$down[$i]},"\n";
        }
}

close IN;
close OUT;

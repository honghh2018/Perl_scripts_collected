#!/usr/bin/perl -w
use strict;
use warnings;
use FindBin qw($Bin $Script);
use File::Basename qw(fileparse dirname basename);
use Getopt::Long;
use Cwd qw(abs_path getcwd);



my ($indir,$same,$merge,$step);

GetOptions(
	"h|?" => \&USAGE,
	"i:s" => \$indir,
	"-same:s" => \$same,
	"m:s" => \$merge,
	"sbs:s" =>\$step,
) or &USAGE;

print STDOUT "your input not dir" unless(-d "$indir");

my $abs_path=abs_path($indir);
$step ||=0;  #default 0
=cut
#Take all file of T* dir
=c
my @file=glob "$abs_path/$same*/*";

mkdir "$Bin/work_sh/" unless -d "$Bin/work_sh";

my $program_locate="$Bin";
print STDOUT "my program locate:\t",$program_locate,"\n";
print STDOUT "my scripts name:\t",$Script,"\n";

#step1 sort the bam file
my $count=0;
if($step==1){
	for my $file(sort @file){
		chomp($file);
		$count++;
		print STDOUT "file:$count\t",$file,"\n";
		my $dir=dirname($file);
		my $basename=basename($file);
		my $sample_id=(split /\./,$basename)[0];
		open(OUT,">$Bin/work_sh/$sample_id.sh");
		my $cmd="samtools sort $file $dir/$sample_id.sort";
		print OUT $cmd;
		close OUT;
		system($cmd);
	}
	$step++;
}
print STDOUT "Step1 work finished/n";
print STDOUT "Step2 start.../n";
sleep(1);
#step2 build the index
=cut
#my @file1=glob "$abs_path/$same*/*sort*";
=c
while(my $line=<@file1>){
	print $line,"\n";	
}
=cut
=cut
my $count=0;
=cut
`mkdir "$Bin/work_sh"` unless -d "$Bin/work_sh";
=cut
open(SH2,">$Bin/work_sh/step2.index.sh");
if($step==2){
	for my $file(sort @file1){
		$count++;
		print STDOUT "Start with:\t",$file,"\n";
		chomp($file);
		my $basename=basename($file);
		my $sample_id=(split /\./,$basename)[0];
		#`mkdir "$Bin/index/$sample_id/"` unless -d "$Bin/index/$sample_id/"; #make directories
		#open(OUT,">$Bin/work_sh/$sample_id\_$count.sh");
		my $cmd="samtools index $file\n";
		#print OUT $cmd;
		#close OUT;
		print SH2 $cmd;
		#`$cmd`;
	}
	$step++;
}
close SH2;
print "Start index with qsub\n";
system "sh /opt/tool/qsub_sge_plus/v1.0/qsub_sge.plus.sh $Bin/work_sh/step2.index.sh --reqsub --independent"; #throw jobs into qsub
=cut
#step3 merge bam file
#preprocessing
#my group
=cut
=cut
my %name=();
my %group=();
if($step ==3){print "start merge \n";} 
if($merge =~ /\;/){
	my @temp=split /\;/,$merge;
	foreach my $sample(@temp){
		if($sample =~/\,/){
			my $id=join("\_",(split /\,/,$sample));
			$name{$id}=$id;
			$group{$name{$id}}=1;
		}else{
			my $id=$sample;
			$name{$id}=$id;
			$group{$name{$id}}=1;
		}
	}
	
}else{
	if($merge =~/\,/){
		my $id=join("\_",(split /\,/,$merge));
		$name{$id}=$id;
		$group{$name{$id}}=1;
	}else{
		my $id=$merge;
		$name{$id}=$id;
		$group{$name{$id}}=1
		
	}
}
`mkdir $Bin/Merge_result/` unless -d "$Bin/Merge_result/";
open(OUT1,">$Bin/work_sh/step3.merge.sh");
if($step==3){
	my @file2=glob "$abs_path/$same*/*sort.bam";
	my %file=&Reconstruct(\@file2);
	foreach my $key(sort keys %group){
		print OUT1 "samtools merge $Bin/Merge_result/$key\_merge.bam ";
		my @sample=split /\_/,$key;
		print @sample,"\n";
		for my $sam(@sample){
			if(exists $file{$sam}){
				print OUT1 $file{$sam}," ";
			}
		}
		 print OUT1 "\n";
	}
	$step++;
}

close OUT1;
print "Throw qsub \n";
#system "sh /share/tool/qsub_sge_plus/v1.0/qsub_sge.plus.sh $Bin/work_sh/step3.merge.sh --reqsub --independent"; #throw jobs into qsub


sub Reconstruct{
	my $file=shift;
	my %hash=();
	my @sort =sort @{$file};
	for my $file(@{$file}){
		my $sample=basename($file);
		my $temp_id=(split /\./,$sample)[0];
		$hash{$temp_id}=$file;
	}
	return %hash;
}


#As $step reach 3,just it start typing the below string.
if($step==4){
	print "All works finished!\n";
}

sub USAGE{
	my $usage=<<USAGE;
	Contact:939869915\@qq.com
	Usage:
	perl $0 -i <dir> --same T -m <string> -sbs [1-4]
	-i input dir forced given
	--same T forced given	Character or string of same dir prefix,for instance,T01,T02,just use "T"
	-m merge sample like T01,T02;T03;T04 for instance
	-sbs 0-4
	step1 sort bam
	step2 index bam
	step3 merge bam
	step4 exit
USAGE
	print "$usage\n";
	exit;
}

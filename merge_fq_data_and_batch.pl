#!/usr/bin/perl
use Getopt::Long;
use File::Basename qw(basename dirname fileparse);
use Cwd qw(abs_path getcwd);


my ($indir1,$indir2,$od,$step);
GetOptions(
	"h|?" => \&USAGE,
	"c:s" => \$indir1,
	"m:s" => \$indir2,
	"step:s" => \$step,
	"o:s" => \$od,
) or &USAGE;

&USAGE unless ($indir1 or $indir2 or $od);
$step ||=0;
#input cleandata dir
#############################
`mkdir "$od"` unless -d "$od";
my $loc=abs_path($od);
`mkdir "$loc/worK_sh1"` unless -d "$loc/work_sh1";
my $path="$loc/worK_sh1";
#############################
my %file=();
my $abs_path=abs_path($indir1);
if($step ==0){
my @file=glob "$abs_path/*.fq";
	for my $file(sort @file){
		chomp $file;
		my $basename=basename($file);
		$file{$basename}=$file;
	}
$step++;
}
if($step==1){
#input merge dir

open(OUT,">$path/step1.merge.sh");
my $abs_path1=abs_path($indir2);
my @file1=glob "$abs_path1/*.fq";	
open(LOG,">$path/Size_fq.log");
for my $file1(sort @file1){
	chomp($file1);
	my $basename1=basename($file1);
	if(exists $file{$basename1}){
		my $mergefq=`du -sh $file1`;
		my $cleandata=`du -sh $file{$basename1}`;
		print LOG $mergefq,$cleandata;
		my $cmd="cat $file1 $file{$basename1} \> $loc/$basename1";
		my $result_merge=`du -sh "$loc/$basename1/$basename1"`;
		print LOG $result_merge,"\n";
		print OUT $cmd,"\n";
	}

}
close OUT;
close LOG;
#Throw qsub start...
my $sh="$path/step1.merge.sh";

	
	print "Start merge with qsub\n";
	system "sh /tool/qsub_sge_plus/v1.0/qsub_sge.plus.sh $sh --reqsub --independent";
	$step++;
}

if($step == 2){
	open(OUT,">$path/step2.copy.sh");
	my @file3=glob "$loc/*fq";
	for my $file(sort @file3){
		my $cmd="cp $file/*fq $abs_path/";
		print OUT $cmd,"\n";
	}
	close OUT;
	my $sh1="$path/step2.copy.sh";
	#Throw qsub start...
	print "Start copy merge file into cleandata\n";
	system "sh /tool/qsub_sge_plus/v1.0/qsub_sge.plus.sh $sh1 --reqsub --independent";
	$step++;
}
=cut
#######################################
#start batch compress with cleandata
print $step,"\n";
if($step == 3){
	print "Start gzip fq data\n";
	print "$abs_path\n";
	my $cmd	="perl /compress_and_check_fq/v1.0/compress_and_check_fq.pl -i $abs_path -od gz_data";
	system "$cmd";
#	`rm -r $path/*fq`;
	print STDOUT "All works finished!\n";
	$step++;
}


=cut
sub USAGE{
	my $usage=<<"USAGE";
	Contact:939869915\@qq.com
	perl $0 -m <dir> -c <dir> -o <dir> -step [0-3] default 0
USAGE

	print $usage;
	exit;
}

#!usr/bin/perl -w
use strict;
use warnings;
use Getopt::std;
my($dir,$od);
Getoptions(
	"indir:s" =>\$dir,
	"od:s" => \$od,
	"h|?" => \&USAGE,
) or &USAGE;

if(undef($dir) ||undef($od)){
	print("your input parameter wrong,please check carefully\n");
	&USAGE;
}


opendir(DIR,"$dir") or die "Cannot open dir:$!";
mkdir($od,0777) or die "$!" unless(-d $od);
for my $file(readdir DIR){
	next if($file eq "." or $file eq "..");
	if( -e $file){
		my $cmpress="gzip $file >$od";
		system($cmpress);
	}
}
closedir DIR;
opendir(DIR,$od) or die "$!";
for my$file(readdir DIR){
  next if($file eq "." or $file eq "..");
  my $md5sum="md5sum $file > gz.md5";
  system($md5sum);
}

closedir DIR;

sub USAGE{
	my $usage=<<USAGE;
	------------------------
	Contact:honghh\@biomarker.com.cn
	USAGE:
	cmpress_and_md5sum.pl -indir <indir> -od <outdir>
	------------------------
USAGE
	print $usage;
	exit(1);
}


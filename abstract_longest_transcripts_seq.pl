#！/usr/bin/perl -w
use strict;
use warnings;
use strict;
use Getopt::Long;
use Cwd qw(abs_path getcwd);
use FindBin '$Bin';
use Getopt::Long;
use File::Basename qw(basename dirname);


my($fasta,$od);
GetOptions(
  "fasta:s"  =>\$config,
  "o:s" =>\$od,
  "h|?" =>\$USAGE,
) or &USAGE;
&USAGE unless($fasta and $od);
my $begin_time=time();
my $version="180829";
open(my $in,"$fastq") or die "$!";

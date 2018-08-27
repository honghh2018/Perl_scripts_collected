#!/usr/bin/perl
use strict;
use FindBin '$Bin';
use Cwd qw(abs_path getcwd);
use File::basename wq(basename dirname);
use Getopt::Long;
my $version="18.8.27";

#getoptions
my %para;
GetOptions(\%para,"fasta=s","position=s","od=s","h");
if(!defined $para{fasta} and !defined $para{position} and !defined $para{od}){
  &USAGE();  #the bracket can omit
}

my $time=time();
print "$time:work start.\n";
my $program=basename($0);
print "program:$program.\n";
print "Version:$program-$version\n";

my @position=();
my %genome=();
&read_position(\@position);
&read_genome(\%genome);
my $local=getcwd;
mkdir "$local/Result" unless -d "$local/Result";
open($out,">$local/Result/$para{od}");
for my $row(0..$#position){
    for my $gene_id(keys %genome){
    if($position[$row][0] eq $gene_id){
      print $out ">",$gene_id,$position[$row][1],"-",$position[$row][2],"\n";
      print $out substr($genome{$gene_id},
                        $position[$row][1]+1,
                        $position[$row][2]-$position[$row][1]);

    }
  }
}
close $out;

#read position file
sub read_position{
  my $file=shift;
  open(my $in,"$para{position}") or die "$!";
  my $index=0;
  while(<$in>){
    chomp;
    if(/^chr.*end$/){
      next;
    }else{
        my @arr=split(/\s+/);
        for (0..$#arr){
          $position[index][$_]=$arr[$_];
        }
      last if(/^\/\//);
    }
    $index++;
  }
  close $in;
}


sub read_genome{
  my $file=shift;
  open($in,"$para{fasta}") or die "$!";
  while(<$in>){
    chomp;
    my $gene_id="";
    if(/^(.*)/){
      $gene_id=$1;
    }else{
      $genome{$gene_id} .=$_;
    }
  }
  close $in;
}


sub USAGE{
  my $usage=<<"USAGE";
  ---------------------------------
  Contact:honghh\@biomarker.com.cn
  USAGE:
    -fasta fasta file,force
    -position pos file,force
    -od output file,file
  ---------------------------------
  print $usage;
  exit(1);
}

__END__
position file configure:
chr start end
chr1 10 20
chr1 30 100
chr2 90 200
//



copyright:hhh

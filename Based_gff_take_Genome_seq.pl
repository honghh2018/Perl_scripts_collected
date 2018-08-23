#!usr/bin/perl
use strict;
use warnings;
use FindBin '$Bin';
use Getopt::Long;
use Cwd wq(abs_path getcwd);
use File::Basename;


#start worK
my($gff,$Genome,$od,$switch)
GetOptions(
  "gff:s"  => \$gff,
  "geno:s" => \$Genome,
  "od:s"   => \$od,
  "sw:s"     => \$switch,
  "h|?"    => \&USAGE,
) or &USAGE;
&USAGE unless($gff and $Genome and $od);

#read gff and tackle itself
#mkdir directory
$switch ||=0; #default zero：off
if($switch eq "1"){
  print "start work";
}else{
  print "function have not performance";
}
my $local=getcwd; #get wkdir
`mkdir -p "$local/Result"` unless(-d "$local/Result/");
my %hash_gff=();
my %hash_genome=();
my $abs_genome=&read_gff($gff,\%hash_gff,$Genome);
my $name_fasta=basename($abs_genome);
my $dirname=dirname($abs_genome);
open(my $in,"$abs_genome") or die "$!";
open(my $out,">$dirname/Result/$name_fasta.success.fasta");
for my $line(<$in>){
  chomp($line);
  my $genome_id="";
  my $genome_seq="";
  if($line =~/>(.*)/){
    $genome=$1;
  }else{
    $genome_seq .=$line;
  }
  $hash_genome{$genome_id}=$genome_seq;
  foreach my $gff_id(sort keys %hash_gff){
    if(exits $hash_genome{$gff_id}){
      print OUT "gff3_gene_id:",$gff_id,"\n";
      for(my $i=0;$i<@{$hash_gff{$gff}};$i +=3){
        if(${$hash_gff{$gff}}[$i+2] eq "+"){
          my $len=${$hash_gff{$gff_id}}[$i+1]-${$hash_gff{$gff_id}}[$i];
          my $goal_seq=substr($hash_genome{$gff_id},${$hash_gff{$gff_id}}[$i+1],$len+1);
          my $count++;
          print OUT "Genome CDS$count:",$goal_seq,"\t","\n";
        }else{
          my $len=${$hash_gff{$gff_id}}[$i+1]-${$hash_gff{$gff_id}}[$i];
          my $goal_seq=substr($hash_genome{$gff_id},${$hash_gff{$gff_id}}[$i+1],$len+1);
          my $revgoal_seq=reverse($goal_seq);
          my $count++;
          print OUT "Genome CDS$count:",$revgoal_seq,"\t","\n";
        }
    }
  }
}
}
close {$in};
close {$out};

my $dirname=""; #get path
sub read_gff{
  my ($file,$h_gff,$genefile)=@_;
  my $abs_file=abs_path($file);
  my $abs_genome_way=abs_path($genefile);
  open(my $in,"$abs_path") or die "$!";
  while(my $line=<$in>){
    chomp($line);
    next if($line=~/mRNA|exon|five_prime_UTR/);
    my $gff_id=split(/\=/,(split(/\s+/,$line)[0]))[1];
    my ($start,$end)=split(/\s+/,$line)[3,4];
    my $strand=split(/\s+/,$line)[7];
    my @temparray=qw($start $end $strand);
    if(exists $h_gff->{$gff_id}){
      push @{$h_gff->{$gff_id}},@temparray;
    }
  }
  close {$in};
  return $abs_genome_way;
}


sub $USAGE{
  my $usage =<<"USAGE";
  ---------------------------------------------
  Manual page:
    Contact:honghh\@biomarker.com.cn
  Usage:
    Options:
    -gff gff3 file,forced;
    -geno genome fasta,forced;
    -od file fasta,forced;
    -sw 1 print something,0 other
    -h  show the help;
  Example:
    Based_gff_take_genome.pl -gff <gff3> -geno <fasta> -sw <1 or 0>
    ---------------------------------------------
  USAGE
  print $usage;
  exit(1);
}

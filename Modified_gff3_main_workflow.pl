#!/usr/bin/perl
use strict;
use warnings;
use Tie::File;
use Getopt::Std;
use List::Util qw/sum/;


my $version="Version 18.10.5";
#start time
my $begin_time=time();

my %para;
getopts('a:i:o:b:c:d:e:f:h:i:j:k:l:m:n:s:p:',\%para);

if(!defined $para{i} || !defined $para{o}){
	my $usage=qq'
	Usage:
	Contact:honghh\@honghh.com.cn
	perl $0 -i <infile> -o <outfile> -s <seperator> :default="###" -p <prefix>:default Result -f <final_file> -t <Threshold>
';
	print $usage;
	exit;
}


$para{s} ||="###";
$para{p} ||="Result";
$para{t} ||="1000000";
my @file;
open(IN,"$para{i}") or die "$!";
open(OUT,">$para{o}");
open(OUT1,">Filter_id_with_+-strand_on.txt");
open(TEMP,">\.Temp.list"); #hiden temp file

##filter file header of gff3 build middle file
my @header=();
while(<IN>){
	chomp;
	if($_=~/^##.*\d+$/){
		push @header,$_;
		next;
	}else{
		print TEMP $_,"\n"; 
	}
}
close TEMP;
#print header description
for(@header){
	print OUT $_,"\n";
}
open(IN1,"\.Temp.list") or die "$!";
tie @file,'Tie::File',\*IN1, recsep => $para{s},autochomp => 0;


my $count=0;
for my $line(@file){
	chomp($line);
	if($line=~/\+.*\-/smg || $line=~/\-.*\+/smg){
		my $gene_id=(split /\;/,(split /\s+/,(split /\n+/,$line,2)[1])[8])[0];
		$count++;
		print OUT1 $gene_id,"\n";
	}else{
		print OUT $line;
	}

}

print "                Statistic Analysis Information                \n";
print OUT1 "Number of gene on both positive strand and negative strand:",$count,"\n";
print "Number of gene on both positive strand and negative strand:",$count,"\n";
our @array=();
push @array,$count;

close IN;
close OUT;
close OUT1;
close IN1;
`rm -r \.Temp.list` if(-e "\.Temp.list");
my $replace="sed -i s/###//g";
`sed -i /###/d $para{o}`;
##start add gene
my $script="modified_gff_file_add_gene.pl";
my $command="perl $script $para{o} $para{p}.add_gene.gff3 &> \.log.txt && rm -r \.log.txt";
system($command);
#start filter large intron
$script="filter_gff3_large_intron.pl";
my $command1="perl $script -i $para{p}.add_gene.gff3 -o $para{f} -T $para{t} -s $count";
system($command1);
######end time######
my $end_time=time();
my $elapse=abs($begin_time-$end_time);
print "##############################################################\n";
print "Finish work,elapse time:$elapse s\n";
print "##########################The End#############################\n";
print "Current Program:","$version\n";
############The end#############

Usage:perl sModified_gff3_main_workflow.pl -i ../perl_test/Rubus_occidentalis_v1.1.lifted_1.gff3 -o result.gff3 -f Final.gff3 >log.list


#####################you need below script#################
filter_gff3_large_intron.pl
#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Std; #Even though getopts out of shell but it need the module Getopt::Std
use List::Util qw/sum/;

my %options;
getopts("i:o:T:s:",\%options); #The getopts function given by shell no perl,which was a parameter captured on command line.
#Conditional judgement
if(!defined $options{i} ||!defined $options{o} ||!defined $options{T}){
	my $usage=qq'
	USAGE:
	Contact:honghh\@biomarker.com.cn
	perl $0 -i <inputfile> -o <outputfile> -T <Threshold> :T <integer>
	comments:Threshold default =1000000
';	
	print $usage;
	exit;
}
our @array=();
#Program start:
$options{T} ||=1000000;
open(IN,"$options{i}");
open(OUT,">$options{o}");
open(OUTF_G,">Intron_Outnumber_$options{T}_Gene_ID.list");

##filter file header of gff3
while(<IN>){
        chomp;
        if($_=~/^\w+/){
                last;
        }else{
                print OUT $_,"\n";
        }
}

my $lastid=0; #
my $flag; #flag mark
my $count=0;
while(<IN>){
	chomp;
	next if(/\#/); #match # skip　loop
	$flag=0;
	if(/gene/){
		my @field=split /\t/,$_;
		my @lastid_sep=split /\;/,$field[-1];
		#print OUT1 $lastid_sep[0],"\n";
		if(abs($field[4]-$field[3]) > $options{T}){
			$flag=1;
			$lastid=$lastid_sep[0];
			$count++;
			print OUTF_G $lastid_sep[0],"\n";
		}
	}
	if($flag==1 || $_=~/$lastid/){
		next;	
	}
		print OUT $_,"\n";	
}
print "Intron_Outnumber_$options{T}_Gene_ID number:",$count,"\n";
push @array,($count,$options{s});
my $sum=sum@array;
print "All gene number:",$sum,"\n";
close IN;
close OUT;
close OUTF_G;
#close OUT1;

#########################################################
modified_gff_file_add_gene.pl

#!/usr/bin/perl -w
use strict;
use warnings;
open(IN,"$ARGV[0]") or die "$!";
open(OUT,">$ARGV[1]");
#comment:inputfile not allow the "#",besides the header descriptions,delete the header must be fine on this scripts
##filter file header of gff3
#while(<IN>){
#        chomp;
#        if($_=~/^\w+/){
#                last;
#       }else{
#                print OUT $_,"\n";
#        }
#}


while(<IN>){
	&readgff($_);
}

sub readgff{
	my $line=shift;
	if($line =~/mRNA/){
		my @array=split /\s+/,$line;
		print OUT $array[0],"\t",$array[1],"\t","gene","\t",$array[3],"\t",$array[4],"\t",$array[5],"\t",$array[6],"\t",$array[7],"\t",$array[8],"\n";
		$array[8]=~s/(ID\=Bras_T[0-9]+)(.*)/$1\.1$2/g;
		$array[8]=~m/ID\=(Bras_T[0-9]+)(.*)/;
		print OUT $array[0],"\t",$array[1],"\t",$array[2],"\t",$array[3],"\t",$array[4],"\t",$array[5],"\t",$array[6],"\t",$array[7],"\t","$array[8]",";","Parent=$1","\n";
	}else{
		my @array1=split /\s+/,$line;
		if(@array1 !=9){
			print OUT $line;
		}else{
			if($line !~/gene/){
				 $array1[8]=~s/(ID\=Bras_T[0-9]+)(.*)/$1\.1$2/g;
                        	print OUT $array1[0],"\t",$array1[1],"\t",$array1[2],"\t",$array1[3],"\t",$array1[4],"\t",$array1[5],"\t",$array1[6],"\t",$array1[7],"\t","$array1[8]","\n";
			}
					
		}
		$line=<IN>;
		if(eof(IN)){
			exit;
		}
		&readgff($line);
	}
}
close IN;
close OUT;

__END__
ID=Bras_T03086





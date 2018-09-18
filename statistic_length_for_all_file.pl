#!/usr/bing/perl -w
use strict;
use warnings;
use FindBin '$Bin';
use Cwd qw(getcwd abs_path);
use Getopt::Long;
use File::Basename;

my $pragram_name=basename($0);
print $pragram_name,"\n";



my @para=();
GetOptions(
        "io:s" => \@para,
        "h|?" => \&USAGE,
) or &USAGE;


##recursion read file
sub readfile{
        my $dir=shift;
        my @realfile=();
        if(!-d "$dir" && !-e "$dir"){
                push(@realfile,$dir);
                return @realfile;
        }
        if(-d "$dir" || -e "$dir"){
                my @dirfile=grep{!(/^\./)} glob("$dir/*");
                for my $sub_file(@dirfile){
                        if(-d "$sub_file"){
                                push(@realfile,&readfile($sub_file));
                        }else{
                                push(@realfile,$sub_file);
                        }
                }
        }
        return @realfile;
}

my @arrayfile=&readfile($ARGV[0]);
open(OUT,">$ARGV[1]");
print OUT "ID","\t","Length <18","\t","Length >30","\t","clean reads","\n";
for my $file(@arrayfile){
        if($file =~m/.*Arab_L283-02-(S.{2})\.filter.stat$/){
                open(IN,"$file") or die "$!";
                print OUT $1,"\t";
                while(<IN>){
                        chomp;
                        if(/Length\s+<18|Length\s+>30/){
                                my ($goal)=(split /\t/,$_)[2];
                                print OUT $goal,"\t";
                        }
                        if(/^Clean\s+Reads/){
                                my ($goal1)=(split /\t/,$_)[1];
                                print OUT $goal1;
                        }
                }
                print OUT "\n";
        }
                close IN;


}
close OUT;


sub USAGE{
        my $usage=<<EOF;
        -----------------------
        USAGE:
        

        -----------------------
EOF
        print $usage;
        exit(1);
}







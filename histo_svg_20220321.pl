#!/usr/bin/perl -w 
use strict;
use lib "/ldfssz1/MS_OP/USER/bianchao/Teleost_ancestor_construction/01.bin/common_bin/4_dtv";
use SVG;

#if(@ARGV<2){die "perl $0 <color_list><species_name>\n";}
my $in=shift;
my $text=shift;
my $list=$in.".list";
open IN,"<$in" or die $!;
open OUT,">$text.svg" or die $!;
my $svg = SVG->new('width',3000,'height',3000); 
$svg->text('x',0,'y',0,'-cdata',$text,'stoke','black','font-size',20);
my $last="";my $y1;my $last_l;
while(<IN>)
{
    chomp;
    my @a=split /\s+/;
    $a[1]=~s/_//g;
    if($last eq "" || $last ne $a[0])
    {
        my $l_x1=2500-$last_l/150000 if (defined $last_l);
        my $l_y2=$y1+20 if (defined $last_l);
        $svg->polygon('points',[$l_x1,$y1,'2500',$y1,'2500',$l_y2,$l_x1,$l_y2],'fill','none','stroke','black','width',0.5) if (defined $last_l);
        $y1+=23;
        my $y2=$y1+20;
        my $x1=2500-$a[2]/150000;
        my $x2=2500-$a[3]/150000;
#$svg->line('x1',$l_x1,'y1',$y1,'x2','2500','y2',$y1,'stroke','black','stroke-width',5,'width',5,'fill','black');
#$svg->line('x1',$l_x1,'y1',$y2,'x2','2500','y2',$y2,'stroke','black','stroke-width',5,'width',5,'fill','black');
        $svg->polygon('points',[$x2,$y1,$x1,$y1,$x1,$y2,$x2,$y2],'fill',$a[1],'stroke',$a[1]);
    }
    elsif($last eq $a[0])
    {
        my $y2=$y1+20;
        my $x1=2500-$a[2]/150000;
        my $x2=2500-$a[3]/150000;
        $svg->polygon('points',[$x2,$y1,$x1,$y1,$x1,$y2,$x2,$y2],'fill',$a[1],'stroke',$a[1]);
    }
    $last=$a[0];
    $last_l=$a[4]
}
my $l_x1=2500-$last_l/150000;
my $l_y2=$y1+20;
$svg->polygon('points',[$l_x1,$y1,'2500',$y1,'2500',$l_y2,$l_x1,$l_y2],'fill','none','stroke','black','width',0.5);
close IN;

open LI, "<$list" or die $!;
my @kk;
while(<LI>){
	chomp;
	push @kk,$_;		
		}
my $ynew=40;
for (my $i=0;$i<@kk;$i++){
	$svg->text( x=>'2500', 'y'=>$ynew, -cdata=>$kk[$i],'font-size',23);
	$ynew+=23;				
						}
print OUT $svg->xmlify();
close LI;
close OUT;

#!/usr/bin/env perl
# draw orbit with semimajor axis 1,  radius eccentricity e
# then rotate by mean anomaly

use Math::Trig;
use strict;
use warnings;

my   $pi           = 4.0*atan(1.0)      ;
my   $radian       = $pi / 180.0        ;
my   @ea = (1e-3, 3e-3, 1e-2,  3e-2, 1e-1, 3e-1 );
## my   @ea = ( 1e-2 );
my   $da = 0.5 ;
## my   $da = 15.0 ;

## printf "  theta  sin   cos  r      xr    yr    ce    se" ;
## printf "    EE     M      x         y\n";

## foreach my $e ( @ea ) { printf "%11.3e   ", $e } ; printf  "\n" ;

# compute from apogee to apogee
for( my $an  = -180.0 ; $an < 180.00001 ; $an += $da ) {
   my $theta = $radian * $an ;
   my $s = sin( $theta );
   my $c = cos( $theta );
   foreach my $e ( @ea ) {
      my $rr = (1.0-$e*$e) / (1.0 + $e*$c );
      my $xr = -$rr * $s ;
      my $yr =  $rr * $c ;

      # it is difficult to compute E with the standard acos($ce) 
      # formula, because quadrant information is lost.
      #
      # However, if we compute both the cosine of E ($ce)  and the
      # sin ($se), we can use the atan2 function to get $E, since
      # $ce and $se together specify the quadrant.

      my $ce = ( $e + $c ) / ( 1.0 + $e*$c );
      my $se = sqrt( 1.0 - $e*$e ) * $s / ( 1.0 + $e*$c ) ;

      my $E  = atan2( $se, $ce );

      my $M = $E - $e * sin( $E );

      my $cm = cos( $M );
      my $sm = sin( $M );

      # rotate $xr, $yr by angle $M

      my $x = ( $cm * $xr + $sm * $yr ) / $e ;
      my $y = ( $cm * $yr - $sm * $xr - 1.0 ) / $e ;

      ## my $x = ( $cm * $xr + $sm * $yr ) ;
      ## my $y = ( $cm * $yr - $sm * $xr ) ;

##  printf "%7.3f%6.2f%6.2f%6.3f%6.2f%6.2f%6.2f%6.2f%7.3f%7.3f%10.2e%10.2e",
##          $theta, $s,  $c, $rr, $xr, $yr, $ce, $se,  $E,  $M,   $x,   $y ;
      printf "%7.3f%7.3f",  $x, $y ;
   }
   printf "\n";
}

#!/usr/bin/perl

#########################################################################################
# BUILD LOCALIZABLE STRING
#########################################################################################

use strict;         # I'm anal. What can I say?
use Cwd;            # We'll be operating on the working directory.
use File::Path;

my $lang = "en";

$lang = $ARGV[1] if exists $ARGV[1];

my $input1File = cwd()."/BMLT/Supporting\ Files/en.lproj/MyLocalizable.strings";
my $input2File = cwd()."/".$ARGV[0]."/".$lang.".lproj/MyLocalizable.strings";
my $outputFile = cwd()."/".$ARGV[0]."/".$lang.".lproj/Localizable.strings";

open ( MAIN_FILE, $input1File ) || die ( "Could not open main file!" );

my @file_data = <MAIN_FILE>;

close ( MAIN_FILE );

open ( PRODUCT_FILE, $input2File ) || die ( "Could not open product file!" );

push ( @file_data, <PRODUCT_FILE> );

close ( PRODUCT_FILE );

open ( FINAL_FILE, ">$outputFile" ) || die ( "Could not open destination file!" );

foreach ( @file_data )
    {
    print FINAL_FILE $_;
    }
    
close ( FINAL_FILE );

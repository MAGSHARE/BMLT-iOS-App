#!/usr/bin/perl

#########################################################################################
# BUILD LOCALIZABLE STRING
#
# This file implements a simple script that concatenates the global file with whichever
# variant and language local file is to be used. It will create the standard localizable.strings
#########################################################################################

use strict;         # I'm anal. What can I say?
use Cwd;            # We'll be operating on the working directory.
use File::Path;

my $lang = "en";
my $variant = "NY";

$variant = $ARGV[0] if exists $ARGV[0];
$lang = $ARGV[1] if exists $ARGV[1];

my $input1File = cwd()."/BMLT/".$lang.".lproj/MyLocalizable.strings";
my $input2File = cwd()."/Variants/".$variant."/".$lang.".lproj/MyLocalizable.strings";
my $outputFile = cwd()."/BMLT/".$lang.".lproj/Localizable.strings";

open ( MAIN_FILE, $input1File ) || die ( "Could not open main file! ($input1File)" );

my @file_data = <MAIN_FILE>;

close ( MAIN_FILE );

open ( PRODUCT_FILE, $input2File ) || die ( "Could not open variant file! ($input2File)" );

push ( @file_data, <PRODUCT_FILE> );

close ( PRODUCT_FILE );

open ( FINAL_FILE, ">$outputFile" ) || die ( "Could not open destination file! ($outputFile)" );

foreach ( @file_data )
    {
    print FINAL_FILE $_;
    }
    
close ( FINAL_FILE );

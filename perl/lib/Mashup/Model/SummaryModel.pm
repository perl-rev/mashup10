package Mashup::Model::SummaryModel;
use strict;
use warnings;

use Data::Dumper;

use Time::Local;
use DateTime::Format::Strptime;

sub new {

    return bless {}, shift;
}

sub createSummary {

    my ( $self, $data ) = @_;

    my %hash;

    foreach my $record ( @$data ){

        my $datetime = $record->{datetime};
        $datetime = _convDateformat( $datetime );
        $datetime = substr( $datetime, 0, -2 ) . '00';
        if( exists( $hash{$datetime} ) ){
            $hash{$datetime} = $hash{$datetime} + 1;
        } else {
            $hash{$datetime} = 1;
        }
    }

    my @array;

    foreach my $datetime ( sort( keys( %hash ) ) ){
        push @array, { datetime=>$datetime, count=>$hash{$datetime} };
    }

    return \@array;
}

sub _convDateformat {
    my $before = shift;
    my @tmp = split( / /, $before );

    my $month_hash = {
        Jan=>'1',
        Feb=>'2',
        Mar=>'3',
        Apr=>'4',
        May=>'5',
        Jun=>'6',
        Jul=>'7',
        Aug=>'8',
        Sep=>'9',
        Oct=>'10',
        Nov=>'11',
        Dec=>'12',
    };

    my $after = "$tmp[5]/$month_hash->{$tmp[1]}/$tmp[2] $tmp[3]";
    return $after;
}
1

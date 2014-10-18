package Mashup::Model::SummaryModel;
use strict;
use warnings;

use Data::Dumper;


sub new {

    return bless {}, shift;
}

sub createSummary {

    my ( $self, $data ) = @_;

    if( ref( $data) ne 'ARRAY' ){ die; }

    my %hash;

    foreach my $record ( @$data ){

        my $datetime = $record->{datetime};
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

1

use strict;
use warnings;

package Mashup::Model::SummaryModel::Test;

use base qw(Test::Class);
use Test::More;
use utf8;
use Encode;

use Data::Dumper;

use Mashup::Model::SummaryModel;

Mashup::Model::SummaryModel::Test->runtests();

sub testSummary:Test(no_plan) {
    my $model = Mashup::Model::SummaryModel->new();

    my $data = [ 
        { content=>'hogehoge', datetime=>'2014-10-18 13:14:12' } ,
        { content=>'hogehoge2', datetime=>'2014-10-18 13:14:12' } ,
        { content=>'hogehoge3', datetime=>'2014-10-18 13:14:13' } ,
        { content=>'hogehoge4', datetime=>'2014-10-18 13:14:14' } ,
        { content=>'hogehoge5', datetime=>'2014-10-18 13:15:00' } ,
    ];


    my $result = $model->createSummary( $data );
    is ref( $result ), 'ARRAY';

    is @$result, 2;
    is $result->[0]->{datetime}, '2014-10-18 13:14:00';
    is $result->[0]->{count}   , '4';
    is $result->[1]->{datetime}, '2014-10-18 13:15:00';
    is $result->[1]->{count}   , '1';

}
1

#!/WWW/sfw/linux6/perl5/5.16/bin/perl

use lib "/WWW/sfw/linux6/perl5/5.16/local/lib/perl5";
use Mojolicious::Lite;
use Net::Twitter::Lite::WithAPIv1_1;
use Data::Dumper;


my $consumer_key    ='U4RdwMRlVmpFAWoKbmYHAbLQF';
my $consumer_secret ='I6b8Ynq8yXmqpdWp1gWo6RRwoRLjyplXuG0uPSX994QlPDUQbo';
my $token           ='127690110-19ikLk3JB7k89MEiuRyX94wUjEyHuCFw8q80mWn2';
my $token_secret    ='UGc2sxt8qOLHwU3qS2sqZ4Gp4Qs2JPCVPkMUJT7s5bxcO';

post '/' => sub {
  my $self = shift;
  my $nt = Net::Twitter::Lite::WithAPIv1_1->new(
      consumer_key        => $consumer_key,
      consumer_secret     => $consumer_secret,
      access_token        => $token,
      access_token_secret => $token_secret,
      ssl => 1,

  );
  my $rs = $nt->search({q=>"Perl", lang=>"ja", count=>1});
  my $test = $rs->{statuses};

  $self->render(text => Dumper($rs));
};

app->start;

#!/WWW/sfw/linux6/perl5/5.16/bin/perl


use lib "/WWW/sfw/linux6/perl5/5.16/local/lib/perl5";
use lib $ENV{'DOCUMENT_ROOT'} . "/../perl/lib/";

use Mojolicious::Lite;
use Net::Twitter::Lite::WithAPIv1_1;
use Data::Dumper;

use Mashup::Model::SummaryModel;

use Encode;

my $consumer_key    ='U4RdwMRlVmpFAWoKbmYHAbLQF';
my $consumer_secret ='I6b8Ynq8yXmqpdWp1gWo6RRwoRLjyplXuG0uPSX994QlPDUQbo';
my $token           ='127690110-19ikLk3JB7k89MEiuRyX94wUjEyHuCFw8q80mWn2';
my $token_secret    ='UGc2sxt8qOLHwU3qS2sqZ4Gp4Qs2JPCVPkMUJT7s5bxcO';


get '/' => sub {
  my $self = shift;
  $self->stash( { submit_flg => 0, records => {} } );
  $self->render('keyword');
};

post '/' => sub {
  my $self = shift;

  # Twitter API 呼び出し------------------------------
  my $nt = Net::Twitter::Lite::WithAPIv1_1->new(
      consumer_key        => $consumer_key,
      consumer_secret     => $consumer_secret,
      access_token        => $token,
      access_token_secret => $token_secret,
      ssl => 1,

  );

  my $search_word = $self->param('keyword');

  my $rs = $nt->search({q=>$search_word, lang=>"ja", count=>100});

  # 検索結果つめなおし ------------------------------
  my @records;
  for my $status ( @{$rs->{statuses}} ) {
    #my $str = encode("utf-8", "$status->{user}->{screen_name}: $status->{text}");
    my $str =  "$status->{user}->{screen_name}: $status->{text}";
    push @records, { content => $str, datetime => $status->{created_at} };
  }

  # 集計モデル呼び出し  ------------------------------
  my $summary_model = Mashup::Model::SummaryModel->new();
  my $summary = $summary_model->createSummary( \@records );

  # 画面
  $self->stash( {submit_flg => 1, records => $summary} );
  $self->render('keyword');
};


any '/*' => sub {
  my $self = shift;
  $self->stash( { submit_flg => 0, records => {} } );
  $self->render('keyword');
};


app->start;
__DATA__

@@ keyword.html.ep
% layout 'default';

@@ layouts/default.html.ep
<!DOCTYPE HTML PUBLIC "-/W3C/DTD HTML 4.01 Transitional/EN" "http:/www.w3.org/TR/html4/loose.dtd">
<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf8">
<title>Twitterキーワード検索</title>
</head>

<body>


<h1 class="siteTitle">キーワード検索</h1>
何かキーワードを入力してください。<br>
入力したキーワードに対して集計しグラフ描画します。<br>
<form name="input" action="/CGI/index.cgi" method="post">

<input type="text" name="keyword" >
<input type="submit" value="集計">

</form>

%if( $submit_flg ){
<!-- このあたりにグラフをお願いします -->

<br>
<table border="1">
<tr> <th>日時</th><th>件数</th> </tr>
% for my $hash_ref (@{$records}){
    <tr>
        <td> <%= $hash_ref->{'datetime'} %></td>
        <td> <%= $hash_ref->{'count'} %></td>
    </tr>
%}

%}
</table>
</body>
</html>


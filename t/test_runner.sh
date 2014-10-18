#!/bin/bash

#########################################################
# 環境変数の設定、モジュールのパスの差の吸収などなど大変なので、
# このファイルを介してテスト実行するようにしてみました。
########################################################

disp_usage(){
	echo 'Usage:'
	echo '     ./test_runner.sh [options] [files or directories]'
	echo ''
	echo '     if no arguments then target dir is current'
	echo ''
	exit 1
}

if [ $# -ne 0 ]; then 
	if [ '-h' = $1 ]; then disp_usage ;fi
	if [ 'help' = $1 ]; then disp_usage; fi
fi

# 環境変数の設定 これで今後もOKか。。
export PATH=/WWW/sfw/linux6/perl5/5.16/bin:$PATH
export PERL5LIB="/WWW/sfw/linux6/perl5/5.16/local/lib/perl5:$PERL5LIB"

# テスト用の設定を読み込み
#source "$(dirname $0)/unit_env.txt"

# 関数ディレクトリのパスを含むように設定
LIBDIR="$(dirname $0)/../perl/lib";
# テスト用の共通モジュールも含むように設定
LIBDIR2="$(dirname $0)/unitlib";

# テスト対象ディレクトリの指定
if [ $# -eq 0 ];then
	EXECDIR=$(pwd)
else
	EXECDIR=$@ # もうちょっとうまくうけとらないとなぁ
fi

# テスト実行
prove -r -I$LIBDIR -I$LIBDIR2 $EXECDIR

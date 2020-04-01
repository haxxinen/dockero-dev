#!/usr/bin/env bash
# Install official Oracle JDK (debian).

# dependencies
apt-get update -yqq && apt-get install curl wget file -yqq

user=`whoami`
[[ $user != 'root' ]] && echo 'Not root.' && exit

# local vars
arch=`arch`; arch=`echo "${arch: -2}"`
pwd=`pwd`
tmp='/tmp/'$RANDOM
jdk_path='/opt/JDK/'
jdk_current='/opt/JDK/current'

# vendor vars
site='oracle.com'
url="$site/java/technologies/javase-downloads.html"

downloads='oracle.com/technetwork/java/javase/downloads'

# get the latest JDK
download_page=`curl -sSL "$downloads/index.html" \
| grep -oE '/java/technologies/javase-jdk[0-9]{1,}-downloads.html'  \
| sort -udr | grep -E 'jdk[0-9]{2,}' | head -n1
`
pattern="download.oracle.com/otn-pub/java/jdk.*\.tar\.gz"

latest="$site$download_page"
link=$(curl -sSL $latest | grep -oE $pattern | grep linux | awk '{print $1}' | tr -d "'")

[ -z $link ] && echo '[+] Link not available' && exit
echo "[+] Downloading ..."
mkdir $tmp; cd $tmp 2>/dev/null
cookie='oraclelicense=141'
wget --header "Cookie: $cookie" $link

echo "[+] Moving files to $jdk_path ..."
file=`ls $tmp`
[ -d $jdk_path ] && rm -rf $jdk_path
mkdir $jdk_path && tar xf $file -C $jdk_path && rm $file
jdk_path=`cd $jdk_path/* && pwd`

# fixing the Java path
[ -e $jdk_current ] && rm $jdk_current
ln -s $jdk_path $jdk_current
chown -R root:root $jdk_current

# linking relevant binaries
link() {
    [ -n "`file /usr/bin/$1 | grep 'symbolic link'`" ] && unlink /usr/bin/$1
    [ -e /usr/bin/$1 ] && mv /usr/bin/$1 /usr/bin/$1.old
    [ -e "$jdk_current/bin/$1" ] && ln -s "$jdk_current/bin/$1" /usr/bin/$1
}
link java
link javac
link jshell

profile="$HOME/.profile"
cat > $profile << EOF
export JAVA_HOME="$jdk_current/"
export PATH=\$PATH:\$JAVA_HOME
EOF
source $profile
echo '[+] Installed Java: '`java -version 2>&1 | grep -oE '\".*\"'`

# quick smoke test
class='Test'
test="import java.io.*;public class $class {public static void main(String[] args){System.out.println(\"[+] OK from Class.\");}}"
echo $test > $class'.java' && javac $class'.java' && java $class

# clean up
rm -r $tmp
cd $pwd

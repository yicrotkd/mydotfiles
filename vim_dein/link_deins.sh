
mkdir -p ~/.vim/rc/

DIR=`dirname $0`

cd $DIR
MY_DIR=`pwd`

ln -s $MY_DIR/dein.toml ~/.vim/rc/
ln -s $MY_DIR/dein_lazy.toml ~/.vim/rc/

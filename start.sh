export OLDDIR="$PWD"
cd ..
git clone https://github.com/mercuryworkshop/anuraos
rm anuraos/codespace-basic-setup.sh
cp $OLDDIR/codespace-basic-setup.sh anuraos
cd anuraos
echo "cd $PWD" >> ~/.bashrc

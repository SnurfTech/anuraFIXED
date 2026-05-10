export OLDDIR="$(pwd | sed 's|.*/||')"
cd ..
mv $OLDDIR/codespace-basic-setup.sh .
rm -r $OLDDIR
git clone https://github.com/mercuryworkshop/anuraos
mv anuraos $OLDDIR
mv codespace-basic-setup.sh $OLDDIR
cd $OLDDIR

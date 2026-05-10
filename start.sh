export OLDDIR="$(pwd | sed 's|.*/||')"
cd ..
mv $OLDDIR/codespace-basic-setup.sh .
git clone https://github.com/mercuryworkshop/anuraos
mv anuraos/.* $OLDDIR
mv anuraos/* $OLDDIR
rmdir anuraos
rm $OLDDIR/codespace-basic-setup.sh
mv codespace-basic-setup.sh $OLDDIR
cd $OLDDIR

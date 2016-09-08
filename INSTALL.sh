#!/bin/bash
###
# Redundans installer for UNIX.
# bash <(curl -Ls http://bit.ly/redundans_installer)
# version 0.12d
###

log="install.log"
branch="make" # master

echo "#######################################################################"
echo "#                                                                     #"
echo "#                         Redundans installer                         #"
echo "#                                                                     #"
echo "#    version 0.12d                           l.p.pryszcz@gmail.com    #"
echo "#######################################################################"
echo ""
echo "Redundans and its dependencies will be installed in:" `pwd`/redundans
echo ""
echo "Installation will take 2-3 minutes. "
echo "To track the installation status execute in the new terminal:"
echo "  tail -f `pwd`/redundans/$log"
echo ""

# YES/NO prompt
echo -n "Do you want to proceed with installation (y/n)? "
read answer
if echo "$answer" | grep -viq "^y" ; then
    echo "Aborted!"
    exit 0
fi


echo `date` " Checking dependencies..."

exists()
{
  command -v "$1" >/dev/null 2>&1
}

error=""
# check if all programs exists
for cmd in echo awk wget tar gcc g++ make cd ln date ldconfig unzip perl python; do
    if ! exists $cmd; then
        echo "Install $cmd first!"
        error=1
    fi
done

# check if all libs present
for lib in libz; do
    if [ -z "$(ldconfig -p | grep $lib.so)" ] ; then
        echo "Missing library $lib!"
        error=1
    fi
done

# skip if error
if [ ! -z $error ]; then
    echo -e "\nAborted due to missing dependencies (see above)"
    exit 1;
fi

# check python version


echo `date` " Downloading Redundans..."
#wget -q -O redundans.tgz https://github.com/lpryszcz/redundans/archive/$branch.tar.gz
#tar xpfz redundans.tgz && mv redundans-$branch redundans && rm redundans.tgz
git clone -b $branch --recursive https://github.com/lpryszcz/redundans.git
cd redundans 
# below is needed if you clone all and want to use
#git checkout $branch && git submodule update --init --recursive

sh .compile.sh $log

exit 0

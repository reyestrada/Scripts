#This script install earlyoom
#Check for root
if [ $(whoami) != "root" ]
then
  echo "Please run as root."
  #Exit
  exit 0
fi
#If the directory already exists
if [ -d "earlyoom" ]
then
  echo "There is already a folder names earlyoom, please remove or rename it."
  #Exit
  exit 0
fi
if [ $(which curl) ]
then
  #Get and unzip repository
  curl https://codeload.github.com/rfjakob/earlyoom/zip/master -o earlyoom.zip
  unzip earlyoom.zip
#Else if wget is installed
elif [ $(which wget) ]
then
  #Get and unzip repository
  wget https://codeload.github.com/rfjakob/earlyoom/zip/master -O earlyoom.zip
  unzip earlyoom.zip
fi
cd earlyoom-master
echo "Please enter the minimum free ram(leave blank if unsure):"
read ram
echo "Please enter the minimum free swap(leave blank if unsure):"
read swap
#If blank, then use defualt
ram="${ram:-10}"
swap="${swap:-10}"
replace="int mem_min_percent = $ram, swap_min_percent = $swap;"
#Replace line with set variable
sed -i "s/int mem_min_percent = 10, swap_min_percent = 10;/$replace/g" main.c
#Install
make
make install
#Start at boot
sudo systemctl enable earlyoom
#Start now
sudo systemctl start earlyoom
cd ..
#Delete folder and zip file
rm -rf earlyoom-master
rm earlyoom.zip
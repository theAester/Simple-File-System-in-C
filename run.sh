#!/bin/bash

make clean;
clear;
make;

echo -e "\n\n";
echo "Creating Virtual Disk of size 8192";
rm *driver;
./fs.x make our_driver 8192;
./fs.x make ref_driver 8192;


echo -e "\n\n";
echo "Testing info";
./test-fs.x info our_driver > our_info.txt;
./fs.x info ref_driver > ref_info.txt;
diff our_info.txt ref_info.txt;
rm our_info.txt ref_info.txt;


echo -e "\n\n";
echo "Testing empty ls";
./test-fs.x ls our_driver > our_ls.txt;
./fs.x ls ref_driver > ref_ls.txt;
diff our_ls.txt ref_ls.txt;
rm our_ls.txt ref_ls.txt;


echo -e "\n\n";
echo "Testing small file addition";
./test-fs.x add our_driver file1.txt > our_add.txt;
./fs.x add ref_driver file1.txt > ref_add.txt;
diff our_add.txt ref_add.txt;
rm ref_add.txt our_add.txt;


echo -e "\n\n";
echo "Testing small file read";
./test-fs.x cat our_driver file1.txt > our_read.txt;
./fs.x cat ref_driver file1.txt > ref_read.txt;
diff our_read.txt ref_read.txt;
rm our_read.txt ref_read.txt;


echo -e "\n\n";
echo "Testing large file addition";
./test-fs.x add our_driver shakespeare.txt > our_add.txt;
./fs.x add ref_driver shakespeare.txt > ref_add.txt;
diff our_add.txt ref_add.txt;
rm ref_add.txt our_add.txt;


echo -e "\n\n";
echo "Testing large file read";
./test-fs.x cat our_driver shakespeare.txt > our_read.txt;
./fs.x cat ref_driver shakespeare.txt > ref_read.txt;
diff our_read.txt ref_read.txt;
rm our_read.txt ref_read.txt;


echo -e "\n\n";
echo "Testing invalid file read";
./test-fs.x cat our_driver blank.txt > our_read.txt;
./fs.x cat ref_driver blank.txt > ref_read.txt;
diff our_read.txt ref_read.txt;
rm our_read.txt ref_read.txt;


echo -e "\n\n";
echo "Testing 2 file ls";
./test-fs.x ls our_driver > our_ls.txt;
./fs.x ls ref_driver > ref_ls.txt;
diff our_ls.txt ref_ls.txt;
rm our_ls.txt ref_ls.txt;


echo -e "\n\n";
echo "Testing 1 file removal";
./test-fs.x rm our_driver file1.txt > our_rm.txt;
./fs.x rm ref_driver file1.txt > ref_rm.txt;
diff our_rm.txt ref_rm.txt;
rm our_rm.txt ref_rm.txt;


echo -e "\n\n";
echo "Testing 1 file ls";
./test-fs.x ls our_driver > our_ls.txt;
./fs.x ls ref_driver > ref_ls.txt;
diff our_ls.txt ref_ls.txt;
rm our_ls.txt ref_ls.txt;


echo -e "\n\n";
echo "Testing info";
./test-fs.x info our_driver > our_info.txt;
./fs.x info ref_driver > ref_info.txt;
diff our_info.txt ref_info.txt;
rm our_info.txt ref_info.txt;


echo -e "\n\n";
echo "Testing stat of existing file";
./test-fs.x stat our_driver shakespeare.txt > our_stat.txt;
./fs.x stat ref_driver shakespeare.txt > ref_stat.txt;
diff our_stat.txt ref_stat.txt;
rm our_stat.txt ref_stat.txt;


echo -e "\n\n";
echo "Testing stat of nonexisting file";
./test-fs.x stat our_driver file1.txt > our_stat.txt;
./fs.x stat ref_driver file1.txt > ref_stat.txt;
diff our_stat.txt ref_stat.txt;
rm our_stat.txt ref_stat.txt;


echo -e "\n\n";
echo "Testing final file removal";
./test-fs.x rm our_driver shakespeare.txt > our_rm.txt;
./fs.x rm ref_driver shakespeare.txt > ref_rm.txt;
diff our_rm.txt ref_rm.txt;
rm our_rm.txt ref_rm.txt;


echo -e "\n\n";
echo "Testing invalid file removal";
./test-fs.x rm our_driver shakespeare.txt > our_rm.txt;
./fs.x rm ref_driver shakespeare.txt > ref_rm.txt;
diff our_rm.txt ref_rm.txt;
rm our_rm.txt ref_rm.txt;


echo -e "\n\n";
echo "Testing empty ls";
./test-fs.x ls our_driver > our_ls.txt;
./fs.x ls ref_driver > ref_ls.txt;
diff our_ls.txt ref_ls.txt;
rm our_ls.txt ref_ls.txt;


echo -e "\n\n";
echo "Testing Completed to Driver size 8192";


#------------------------------------------------------------------------


echo -e "\n\n";
echo "Creating Virtual Disk of size 4";
rm our_driver, ref_driver;
./fs.x make our_driver 4;
./fs.x make ref_driver 4;


echo -e "\n\n";
echo "Testing info";
./test-fs.x info our_driver > our_info.txt;
./fs.x info ref_driver > ref_info.txt;
diff our_info.txt ref_info.txt;
rm our_info.txt ref_info.txt;


echo -e "\n\n";
echo "Testing empty ls";
./test-fs.x ls our_driver > our_ls.txt;
./fs.x ls ref_driver > ref_ls.txt;
diff our_ls.txt ref_ls.txt;
rm our_ls.txt ref_ls.txt;


echo -e "\n\n";
echo "Testing small file addition";
./test-fs.x add our_driver file1.txt > our_add.txt;
./fs.x add ref_driver file1.txt > ref_add.txt;
diff our_add.txt ref_add.txt;
rm ref_add.txt our_add.txt;


echo -e "\n\n";
echo "Testing small file read";
./test-fs.x cat our_driver file1.txt > our_read.txt;
./fs.x cat ref_driver file1.txt > ref_read.txt;
diff our_read.txt ref_read.txt;
rm our_read.txt ref_read.txt;


echo -e "\n\n";
echo "Testing large file addition";
./test-fs.x add our_driver shakespeare.txt > our_add.txt;
./fs.x add ref_driver shakespeare.txt > ref_add.txt;
diff our_add.txt ref_add.txt;
rm ref_add.txt our_add.txt;


echo -e "\n\n";
echo "Testing large file read";
./test-fs.x cat our_driver shakespeare.txt > our_read.txt;
./fs.x cat ref_driver shakespeare.txt > ref_read.txt;
diff our_read.txt ref_read.txt;
rm our_read.txt ref_read.txt;


echo -e "\n\n";
echo "Testing invalid file read";
./test-fs.x cat our_driver blank.txt > our_read.txt;
./fs.x cat ref_driver blank.txt > ref_read.txt;
diff our_read.txt ref_read.txt;
rm our_read.txt ref_read.txt;


echo -e "\n\n";
echo "Testing 2 file ls";
./test-fs.x ls our_driver > our_ls.txt;
./fs.x ls ref_driver > ref_ls.txt;
diff our_ls.txt ref_ls.txt;
rm our_ls.txt ref_ls.txt;


echo -e "\n\n";
echo "Testing 1 file removal";
./test-fs.x rm our_driver file1.txt > our_rm.txt;
./fs.x rm ref_driver file1.txt > ref_rm.txt;
diff our_rm.txt ref_rm.txt;
rm our_rm.txt ref_rm.txt;


echo -e "\n\n";
echo "Testing 1 file ls";
./test-fs.x ls our_driver > our_ls.txt;
./fs.x ls ref_driver > ref_ls.txt;
diff our_ls.txt ref_ls.txt;
rm our_ls.txt ref_ls.txt;


echo -e "\n\n";
echo "Testing info";
./test-fs.x info our_driver > our_info.txt;
./fs.x info ref_driver > ref_info.txt;
diff our_info.txt ref_info.txt;
rm our_info.txt ref_info.txt;


echo -e "\n\n";
echo "Testing stat of existing file";
./test-fs.x stat our_driver shakespeare.txt > our_stat.txt;
./fs.x stat ref_driver shakespeare.txt > ref_stat.txt;
diff our_stat.txt ref_stat.txt;
rm our_stat.txt ref_stat.txt;


echo -e "\n\n";
echo "Testing stat of nonexisting file";
./test-fs.x stat our_driver file1.txt > our_stat.txt;
./fs.x stat ref_driver file1.txt > ref_stat.txt;
diff our_stat.txt ref_stat.txt;
rm our_stat.txt ref_stat.txt;


echo -e "\n\n";
echo "Testing final file removal";
./test-fs.x rm our_driver shakespeare.txt > our_rm.txt;
./fs.x rm ref_driver shakespeare.txt > ref_rm.txt;
diff our_rm.txt ref_rm.txt;
rm our_rm.txt ref_rm.txt;


echo -e "\n\n";
echo "Testing invalid file removal";
./test-fs.x rm our_driver shakespeare.txt > our_rm.txt;
./fs.x rm ref_driver shakespeare.txt > ref_rm.txt;
diff our_rm.txt ref_rm.txt;
rm our_rm.txt ref_rm.txt;


echo -e "\n\n";
echo "Testing empty ls";
./test-fs.x ls our_driver > our_ls.txt;
./fs.x ls ref_driver > ref_ls.txt;
diff our_ls.txt ref_ls.txt;
rm our_ls.txt ref_ls.txt;


echo -e "\n\n";
echo "Testing Completed to Driver size 4";


#	make
#	info
#	ls
#	add
#	rm
#	cat
#	stat


# now test with really small disk 
# set of file to be null?
# open and close and seek and write commands manually?
# read not go past EOC 
# edge case when you write as much as you can for file that over whelms the disk 



#use stat to get file size whenever you request it.

#use lseek to adjust the new offset.

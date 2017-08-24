#wejdan alomari 

function get-survey{
param([string]$mypc)

$myfile = read-host -prompt "Hello there, welcome!  we will get a system survey for you, where should we store the data?"

#the computer name is
$mypc=$env:COMPUTERNAME | out-file $myfile -Append


#the date and time
$mydate=Get-Date| out-file $myfile -Append

#The OS version is
$myos=(Get-CimInstance Win32_OperatingSystem).version | out-file $myfile -Append


#The processes saparated by session
$myprocess=get-process |sort-object sessionid | out-file $myfile -Append


#all open sockets
 $mycockets=netstat | out-file $myfile -Append

}




#This command will loop through a directory of your choice and hash the files in it 
function get-dirhash{
param([Parameter(Mandatory=$false)][string] $mydir,
[Parameter(Mandatory=$false)][string]$myhashfile
)

#this will promp the user to enter a directory to loop through and a file to save the hashes of the files inside the supplied directory 
$mydir = read-host -prompt "Enter a directory to recursivly go inside and hash it's files ?"
$myhashfile=read-host -prompt "Enter where you want your hash table to be saved ?"

#getting the hashes for each file then save it in a file in a location of your choice
 get-childitem $mydir -recurse |Get-FileHash -Algorithm MD5 |out-file $myhashfile -Append

}



function changes {
#This function will show you the files that were modified in the last 10 days
param ($path,$days=10)

#enter your directory
$path = read-host -prompt "Enter a directory to recursivly check its files for the date of recent changes ?"

#Comparing the date with our last 10 days
$when= (get-date).AddDays(-$days)

#recursivly going through the path and checking the last write time
$myfiles=get-childitem -path $path -recurse | Where-Object {$_.lastwritetime -ge $when }

#counting the number of modified files
echo " the path  has $($myfiles.count) modified since $when "

#printing the modofoed files in the last 10 days 
echo "Tho modified files are" $myfiles

#if you want a specific date to see the changes after pick your date 
$DateToCompare =read-host -prompt "Looking for a specific date? no problem, enter the date and we will compare it with the last time it was modified ?"

$fromdatechanges=read-host -prompt "where do you want to store the changes files list ?"
 #printing the output in a file
$files=Get-ChildItem $path -Recurse | where-Object {$_.LastWriteTime -gt $DateToCompare} |Out-File $fromdatechanges

}


<#
function IsTherePhrase{

#in this tiny function to look for a phrase in a file just to use a loop 

$file1=read-host -prompt "Enter the file name to look inside it, you will get a match or nothing if the phrase was not found " 

$phrase=read-host -prompt "Enter phrase you are looking for "

#looking for the phrase in each instance 

Get-Content $file1 | ForEach-Object {
    if($_ -match $phrase){
      echo "yes the phrase is there"
    }
 
 }

}

#>


function disksizes{
#loop through available disks and display sizes just for the loop 

$disk= Get-WmiObject Win32_LogicalDisk
ForEach ($drive in $disk) { "drive:" + $drive.Name +" size:" + [int]($drive.Size/1073741824)}
}


#calling the functions 
get-survey
get-dirhash
changes
IsTherePhrase
disksizes

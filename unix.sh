#Reads the job description
echo "Enter a job: "
read job
echo -e "\n"
#Scrapes the data from the given website and put it in main.html
wget -q -r -l5 -x 5 -O main.html https://naukri.com
#filters only the hyperlinks and stores in links_temp.txt
grep -Po '(?<=href=")[^"]*' main.html >links_temp.txt
#Filters the websites in the hyperlinks
grep "^http" links_temp.txt >links_temp_filtered.txt
#removes the duplicate websites 
sort -u links_temp_filtered.txt > links.txt
#Filters only jobs and removes courses and other
grep "job" links.txt > links1.txt
#Filters the links based on your entered description
grep -i $job links1.txt > temp.txt
a=`cat temp.txt`
#Scrapes the data from each link in temp1.txt
for i in $a
do
	wget -q -r -l5 -O temp1.txt $i
done
#Same as line4
grep -Po '(?<=href=")[^"]*' temp1.txt >temp2.txt
grep "job-listings-" temp2.txt >temp9.txt
#Edit the output to readable format
cut -f1 -d "?" temp9.txt | cut -f4 -d "/" | cut -f 3- -d "-" | rev | cut -f 6- -d "-" | rev | tr "-" " " > temp4.txt
cat -n temp4.txt
echo -e "\n\n"

echo "Enter the place"
read place 

grep -i $place temp9.txt > temp3.txt

#Edit the output to readable format
cut -f1 -d "?" temp3.txt | cut -f4 -d "/" | cut -f 3- -d "-" | rev | cut -f 6- -d "-" | rev | tr "-" " " > temp4.txt
echo -e "\n"
cat -n temp4.txt 
echo -e "\n"
echo "Enter the job number whose description you want: "
read n
echo -e "\n"
count=1
a=`cat temp3.txt`
#Traverses till the given job number in temp3.txt
for i in $a
do
	if [ $count -eq $n ]
		then
		break
	fi
	((count=count+1))
done
#Prints the link matching the job number
echo $i
#Entering into the link
wget -q -O temp6.txt $i
#Get the div.JD to get the job
cat temp6.txt | hxnormalize -x | hxselect -i "div.JD" | lynx -stdin -dump > temp7.txt
cat temp7.txt
echo -e "\n"
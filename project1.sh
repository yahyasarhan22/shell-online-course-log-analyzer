#function to print the menu
print_menu(){
echo "=============================="
echo " Online Course Log Analyzer"
echo "=============================="
echo "1. Number of sessions per course"
echo "2. Average attendance per course"
echo "3. List of absent students per course"
echo "4. List of late arrivals per session"
echo "5. List of students leaving early"
echo "6. Average attendance time per student per course"
echo "7. Average number of attendances per instructor"
echo "8. Most frequently used tool"
echo "9. Exit"
echo "=============================="
echo ""
echo ""
echo ""
}

# Task 1: Calculate the number of seasons
n_courses(){

course=$1 #take the name of the course

#first take course and season, remove the duplicated, take the specific course finaly count them. 
cut -d, -f6,9 logs.csv|sort -u |grep "$course"|wc -l

}

# Task 2: Average Attendance per course
avg_att() {
    course=$1

    # total number of student attendances 
    count_students=$(grep "$course" logs.csv | wc -l)

    # total number of seasons
    count_sessions=$(n_courses "$course")

    # compute average
    avg=$(awk "BEGIN {printf \"%.2f\", $count_students/$count_sessions}")

    echo "Average attendance for course $course is: $avg"
}


# Task 7: Average number of attendances per instructor
avg_att_per_instructor() {

printf "%-12s %-12s %-10s %-8s\n" "Instructor" "Attendances" "Sessions" "Average"
printf "%-12s %-12s %-10s %-8s\n" "----------" "-----------" "--------" "-------"

    # 1. count total student attendances per instructor
    # store the value in a temp file called:attendance.txt
    #(uniq -c):count for each instructor
    cut -d',' -f5 logs.csv | sort | uniq -c > /tmp/attendances.txt
    # Example output
    # N_std	 Instructor	
    # 6		 I200
    # 4		 I201

    # 2. count courses per instructor
    # store the value in a temp file called:sessions.txt
    #(sort -u): remove the duplucited
    cut -d',' -f5,6,9 logs.csv | sort -u | cut -d',' -f1 | sort | uniq -c > /tmp/sessions.txt
    # Example output:
    #N_course   Instructor
    # 2		I200
    # 2		I201

    # 3. match the two files by InstructorID and compute average
   
#store the first line into count and id like variables
     while read count id; do
      
       #take the number of courses
        sess=$(grep " $id" /tmp/sessions.txt | awk '{print $1}')
       #awk print $1 : extract the first colum ex:2
	#handle null value
        if [ -z "$sess" ]; then
            sess=0
        fi

        # compute average (floating point using awk)
        avg=$(awk "BEGIN { if ($sess>0) printf \"%.2f\", $count/$sess; else print 0 }")
         # tp print the line in perfect way
        printf "%-12s %-12d %-10d %-8s\n" "$id" "$count" "$sess" "$avg"
    done < /tmp/attendances.txt #to read from attendace
}






# Task 8: Most frequently used tool
most_freq() {
    count_zoom=$(cut -d',' -f1 logs.csv | grep -i "zoom" | wc -l)
    count_teams=$(cut -d',' -f1 logs.csv | grep -i "teams" | wc -l)

    if [ "$count_zoom" -gt "$count_teams" ]; then
        echo "Most frequently used tool is: Zoom with frequency: $count_zoom"
    elif [ "$count_zoom" -eq "$count_teams" ]; then
        echo "Zoom and Teams are equally used with count: $count_zoom"
    else
        echo "Most frequently used tool is: Teams with frequency: $count_teams"
    fi
}


# Main loop
while true
 do
    print_menu                # Call the function
    read -p "Enter your choice: " choice #read from user

    case $choice in #start case
        1)  read -p " please enter the name of the course:" course
n_courses $course ;;
        2) read -p " please enter the name of the course:" course1
avg_att $course1;;
        3) echo " List of absent students";;
        4) echo " List of late arrivals";;
        5) echo " List of students leaving early";;
        6) echo " Average attendance time";;
        7) avg_att_per_instructor;;
        8) most_freq;;
        9) echo "Thanks for using my program, good bye."; break;;
        *) echo " Invalid choice,please try again.";; #default case
    esac #end case
done

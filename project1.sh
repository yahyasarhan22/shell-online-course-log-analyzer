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

#function for task 1: Calculate the number of seasons
n_courses(){

course=$1 #take the name of the course

#first take course and season, remove the duplicated, take the specific course finaly count them. 
cut -d, -f6,9 logs.csv|sort -u |grep "$course"|wc -l

}

# function for task 2: Average Attendance per course
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
        7) echo " Average attendance per instructor";;
        8) echo " Most frequently used tool";;
        9) echo "Thanks for using my program, good bye."; break;;
        *) echo " Invalid choice,please try again.";; #default case
    esac #end case
done

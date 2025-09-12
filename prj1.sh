#Yahya Sarhan
#Anwar Atawna

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

# Task 1: Calculate the number of seasons (Yahya)
n_courses(){

course=$1 #take the name of the course

#first take course and season, remove the duplicated, take the specific course finaly count them. 
cut -d, -f6,9 logs.csv|sort -u |grep "$course"|wc -l

}

# Task 2: Average Attendance per course (Yahya)
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
# task 3: List of absent students (Anwar)
num_abs_std(){
    course=$1
    printf "\n##############################################\n"
    printf "\nList of absent students for the course: %s\n" $course
    # ID of students who attended the course
    IDs=$( cut -d, -f1 $course.csv | sort -u | paste -sd" ")

    for ID in $IDs; do #I check if the student is present or not

       #Student's name and whether he attended or not
       nameOfStd=$(grep "$ID" $course.csv |cut -d, -f2,3)
       availableStd=$(grep "$ID" logs.csv )

       #Find the student if he did not attend any session
       if [ -z "$availableStd" ]; then
         printf "\nID: %d and Name: %s " "$ID" "$nameOfStd"
       fi

    done
    printf "\n\n##############################################\n"
    echo $abs_student
}
#function convert time to hours and minutes to minutes
timeToMinutes() {

    #Extract hours and minutes
    start_time=$1
    start_time=$(echo $start_time | cut -c1-5)
    houers=$(echo $start_time | cut -d: -f1)
    minutes=$(echo $start_time | cut -d: -f2)

    #If the hour or minute starts at 0, remove the zero from the beginning.
    if [ "$(echo $houers | cut -c1)" = "0" ]
    then
        houers=$(echo $houers | cut -c2-)
    fi
    if [ "$(echo $minutes | cut -c1)" = "0" ]
    then
        minutes=$(echo $minutes | cut -c2-)
    fi
    #To calculate time in minutes, multiply the time in hours by 60 and add the number of minutes.
    startTimeOfMin=$((minutes + houers * 60))

    echo "$startTimeOfMin"
}
#task 4 & task 5 : List of late arrivals per session or leaving early (Anwar)
lateOrEarly_sess() {
    course=$1
    session=$2
    #Use the flag, if it is 0 then it is task4, if it is 1 then it is task5
    flage=$3
    # Total number of students who attended the session
    tot_student=$(grep "$course" logs.csv | grep -w "$session"| wc -l)
    #Session duration
    lengthOfSess=$(grep "$course" logs.csv | grep -w "$session" |cut -d, -f8 | cut -d' ' -f2 | paste -sd" ")    lengthOfSess=$(echo $lengthOfSess | cut -d' ' -f1)

    rule=11 #Invalidate the base value = 11 then it means the departure time
    if [ "$flage" -eq 0 ] #If task 4 then it means the late time and dont use Session duration
    then
        rule=10
        lengthOfSess=0
    fi
    #Start of the session
    start_time=$(grep "$course" logs.csv | grep -w "$session" |cut -d, -f7 | cut -d' ' -f2 | paste -sd" ")  

    #Session start time or session end time in minutes
    timeOfMin=$(( $(timeToMinutes $start_time) + lengthOfSess ))

    #Student entry or exit time in the session
    timeOfStudents=$(grep "$course" logs.csv | grep -w "$session" |cut -d, -f"$rule"| paste -sd" ")

    for ((i=1; i<=tot_student; i++)) #Check each student whether he/she came in late or left early.
    do
      #The student's time in hours and minutes
      #his name and number, the time of entry and the time of exit in the session
      timeHMin=$(echo $timeOfStudents |cut -c1-5)
      nameOfStd=$(grep "$course" logs.csv | grep -w "$session"| grep "$timeHMin" | cut -d, -f3,4)
      idOfStd=$(grep "$course" logs.csv | grep -w "$session"| grep "$timeHMin" | cut -d, -f2)
      StudentBeginTime=$(timeToMinutes $timeOfStudents)
      StudentLeaveTime=$(timeToMinutes $timeOfStudents)

      #Number of minutes late to enter Number of minutes early left
      lateness=$(( StudentBeginTime - timeOfMin ))
      early=$(( timeOfMin - StudentLeaveTime ))

      #Check the student if he is late for the start time
      if [ "$flage" -eq 0 -a "$StudentBeginTime" -gt "$timeOfMin" ]
      then
          echo "Late: $nameOfStd (ID: $idOfStd) - Joined: $timeHMin, Lateness: $lateness minutes"

      # Check if the student left early from the final time
      elif [ "$flage" -eq 1 -a  "$StudentLeaveTime" -lt "$timeOfMin" ]
      then
          echo "Early: $nameOfStd (ID: $idOfStd) - Left: $timeHMin,$early  minutes early"
      fi
      #Delete student time from student time list
      timeOfStudents=$(echo $timeOfStudents | sed 's/......//')
    done

}
#task 6: Average attendance time per student per course (Anwar)
avgAttperS() {

    course=$1
    tot_student=$(cat $course.csv | wc -l)
    #Students ID and session start time and session start time in minutes
    IDs=$(cut -d, -f1 $course.csv | paste -sd " ")
    start_time=$(grep "$course" logs.csv | cut -d, -f7 | cut -d' ' -f2 | paste -sd" ") 
    timeOfMin=$(timeToMinutes $start_time)
    i=1
    printf "\nCalculating average attendance time for course: %s\n" $course 
    printf "************************************************\n\n"
    while [ "$i" -le "$tot_student" ]
    do
      sessions=0
      #The student number to be checked, the student number to be deleted, the number of sessions
      idOfstd=$(echo $IDs |cut -c1-4)
      IDs=$(echo $IDs | sed 's/.....//')
      stdMeet=$(grep "$course" logs.csv |grep "$idOfstd" | wc -l)

      #the student’s entry time and exit time and the sum of the student's minutes attended
      sumOfMin=0
      StudentBeginTime=$(grep "$course" logs.csv |grep "$idOfstd"|cut -d, -f10)
      StudentLeaveTime=$(grep "$course" logs.csv |grep "$idOfstd"|cut -d, -f11)

      while [ "$sessions" -lt "$stdMeet" ] #Collect student minutes based on the number of sessions attende> 
     do
        sumOfMin=$(( sumOfMin +  $(timeToMinutes $StudentLeaveTime) - $(timeToMinutes $StudentBeginTime) )) 
        StudentBeginTime=$(echo $StudentBeginTime | sed 's/.....//')
        StudentLeaveTime=$(echo $StudentLeaveTime | sed 's/.....//')
        sessions=$((sessions + 1))
      done

      #Conditional sentence: If the student attended any session, we calculate the average number of minute>     
      #and if he did not attend, the average number of minutes is zero.
      if [ "$sessions" -ne 0 ]
      then
          AvgStd=$(awk "BEGIN {printf \"%.2f\", $sumOfMin/$sessions}")
      else
          AvgStd=$sumOfMin
      fi

      nameOfS=$(grep "$idOfstd" $course.csv | cut -d, -f2,3 )
      printf "(Id: %d ,Name: %s) = %.2f\n" "$idOfstd" "$nameOfS" "$AvgStd"
      echo "Total attendance: $sumOfMin minutes"
      echo "Sessions attended: $sessions"
      echo
      i=$((i + 1))
      done
      printf "************************************************\n"
}


# Task 7: Average number of attendances per instructor (Yahya)
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






# Task 8: Most frequently used tool (Yahya)
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

        3) read -p "please enter the name of the course:" course2
           num_abs_std $course2 ;;
        4) read -p "please enter the name of the course:" course3
           read -p "please enter the name of the session:" session
           printf "\n"
           lateOrEarly_sess $course3 $session 0;;

        5) read -p "please enter the name of the course:" course3
           read -p "please enter the name of the session:" session
           printf "\n"
           lateOrEarly_sess $course3 $session 1;;

        6) read -p "please enter the name of the course:" course3
           avgAttperS $course3;;
        7) avg_att_per_instructor;;
        8) most_freq;;
        9) echo "Thanks for using my program, good bye."; break;;
        *) echo " Invalid choice,please try again.";; #default case
    esac #end case
done

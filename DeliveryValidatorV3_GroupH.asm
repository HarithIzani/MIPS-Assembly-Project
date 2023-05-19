# CSCI 3301 CAAL Section 2
# Group H

# Abdo Abdella Name 			1714883
# Harith Bin Mohd Izani			1821037
# Muhammad Hariz Bin Hasnan		1827929
# Muhammad Daniel Bin Darmawi	1913823

		######################
		# Delivary Validator #
		######################
		
# Delivery Validator is an application that validates the delivery of a package by making sure it arrives to its correct destination and is picked up by its intended recipient
# This version will display from the perspective of both the driver and the recipient as well as the program
#
# The app will check if the driver has arrived at the location then recipient will be notified
#	The sensors used : Clock & GPS
#	The app will check	1. Time ; Precision +- 10 minutes ; Desired Time = 1300 (INPUT MUST BE INTEGER NUMBERS ONLY because its a sensor)
#						2. Latitude & Longitude ; Format Degree , Degree ; Desired coordinate = N 3°, E 101° (INPUT MUST BE INTEGER NUMBERS ONLY because its a sensor)
#							!! Maximum degrees 180 ONLY !!
#							!! The coordinates will be simplified for this small project just to illustrate its purpose !!
#
# When sensors detect driver is on location and time is correct, a login prompt will appear, PIN is 180420
#	The sensors used : Touchscreen
#	The app will check PIN number
# The driver will be prompted to enter the recipient's details then it is validated
#	The sensors used : Touchscreen
#	The app will check	1. First Name ; Desired First Name = alibaba
#  						2. IC Number ; Desired last 6 digits of IC Number = 010201
#
# The recipient and driver will be prompted to confirm that parcel has arrived.
#	The sensors used : Touchscreen
#	The app will prompt driver to recieve/send or not recieve/not receive yes/no (LETTERS Y and N ONLY)

.data
# Register Tracking
# $t9 -> Mode
# $t8 -> Perspective
# $t7 -> Loop checker

# Misc strings
welcomeMsg:	.asciiz "  Welcome to Delivery Validator  "
roof:		.asciiz "\n================================="
border:		.asciiz "\n||                             ||"
error: 		.asciiz "There was an error"

#General Data
fName: .asciiz "alibaba"
ic: .word 0x27d9
latitude: .word 3
longitude: .word 101
password: .word 180420

# Program addressing to who
ptd: 	.asciiz "\n\nProgram to Driver (Enter 10 to exit program)\n"
ptd2:	.asciiz	"\n\nProgram to Driver (Cant exit from here)\n"
ptr: 	.asciiz	"\n\nProgram to Receiver (Enter 10 to exit program)\n"
stp: 	.asciiz	"\n\nSensor to Program (Enter 10 to exit program)\n"

# Driver's Perspective ========================================================
driverP: .asciiz 		"\n||     Driver's Perspective    ||"
# State 0
driverS0: .asciiz 		"\n||      Currently en route     ||"
# State 1
driverS1_0:	.asciiz 	"\n|| Recipient has been notified ||"
driverS1_1: .asciiz 	"\n|| Driver ID: DD12345          ||"
driverS1_2: .asciiz 	"\n|| PIN:                        ||"
# State 2
driverS2_0: .asciiz 	"\n|| Enter recipient's Details   ||"  
driverS2_1: .asciiz 	"\n|| First Name:                 ||"
driverS2_2: .asciiz 	"\n|| Last 6 digits of IC :       ||"
# State 3
driverS3: 	.asciiz 	"\n||   Package sent? (Y/N)       ||"
# State 4
driverS4:	.asciiz		"\n|| Deliver next package	      ||"
# State 5
driverS5: 	.asciiz 	"\n|| Reason sent successfully    ||" 

# Time Check
timePrompt:   .asciiz "\nTime: "
timeErrorC_G: .asciiz "\nThere is only 24 hours in a day\n"
timeErrorC_L: .asciiz "\nTime can't be negative\n"
timeError_G:  .asciiz "\nIts already too late, deliver tomorrow"
timeError_L:  .asciiz "\nIt isn't time to deliver package"

# GPS Check
gpsLatitude:   .asciiz "\nGPS Latitude North: "
gpsLongitude:  .asciiz "\nGPS Longitude East: "
gpsError: 	   .asciiz "\nStill not at location"
gpsDegreeError:.asciiz "\nThat degree doesn't exist"

# Login
loginPrompt: .asciiz "\nDriverID : DD12345\nPIN : "
loginError:  .asciiz "\nIncorrect PIN" 

# Validate
validatePrompt: 		.asciiz "\nFirst Name: "
validateErrorPrompt: 	.asciiz "\nThat isn't a letter"
validateNErrorPrompt:   .asciiz "\nName is incorrect"
validateICPrompt: 		.asciiz "\nLast 6 digits of IC : "
validateICError:		.asciiz "\nIC is incorrect return the package"
validateSpace: 			.space 11

# Sent
sentInput:		.space 2
sentSpaceD: 	.space 50
sentSpaceR:		.space 50
sentErrorPrompt:.asciiz "\nIncorrect Input"
sentPrompt:	  	.asciiz "\nPackage Sent? (Y/N): "
sentNPrompt:	.asciiz "\nReason for not sending : "

# Receiver's Perspective ======================================================
receiverP:  .asciiz	"\n||    Receiver's Perspective   ||"
# State 0
receiverS0: .asciiz "\n||     Package is en route     ||"
# State 1
receiverS1: .asciiz "\n||   Your Package has arrived  ||"
# State 2
receiverS2: .asciiz	"\n|| Please Provide Your Details ||"
# State 3
receiverS3: .asciiz	"\n||    Please accept package    ||"
# State 4
receiverS4: .asciiz "\n||  Thank you for choosing us! ||"
# State 5
receiverS5: .asciiz "\n||  Reason is being reviewed   ||"

.text
#Harith Bin Mohd Izani 1821037 Line 128 - 292
main:
la $a0,welcomeMsg
jal print

li $t9,0
li $t8,0

#To check which states the program should be in by using $t8, $t9
loop:
j perspective #Checks $t8 for which I/O should be outputted
mode: #Checks $t9 for which state the program should be in
beq $t9,0,time
beq $t9,1,gps
beq $t9,2,login
beq $t9,3,validate
beq $t9,4,sent

exit:
li $v0,10
syscall

#Perspective checking to see what is the perspective should be shown
perspective:
beq $t8,0,p0
beq $t8,1,p1
beq $t8,2,p2
beq $t8,3,p3
beq $t8,4,p4
beq $t8,5,p5
la $a0,error
jal print
j mode
p0: #Showing the parcel is currently en route
la $a0,roof
jal print
la $a0,driverP
jal print
la $a0,border
jal print
la $a0,driverS0
jal print
la $a0,roof
jal print
la $a0,receiverP
jal print
la $a0,border
jal print
la $a0,receiverS0
jal print
la $a0,roof
jal print
j mode
p1: #Showing that parcel has arrived
la $a0,roof
jal print
la $a0,driverP
jal print
la $a0,border
jal print
la $a0,driverS1_0
jal print
la $a0,border
jal print
la $a0,driverS1_1
jal print
la $a0,driverS1_2
jal print
la $a0,roof
jal print
la $a0,receiverP
jal print
la $a0,border
jal print
la $a0,receiverS1
jal print
la $a0,roof
jal print
j mode
p2: #Showing validation prompt
la $a0,roof
jal print
la $a0,driverP
jal print
la $a0,border
jal print
la $a0,driverS2_0
jal print
la $a0,border
jal print
la $a0,driverS2_1
jal print
la $a0,driverS2_2
jal print
la $a0,roof
jal print
la $a0,receiverP
jal print
la $a0,border
jal print
la $a0,receiverS2
jal print
la $a0,roof
jal print
j mode
p3: #Showing prompt of whether parcel is sent or not
la $a0,roof
jal print
la $a0,driverP
jal print
la $a0,border
jal print
la $a0,driverS3
jal print
la $a0,roof
jal print
la $a0,receiverP
jal print
la $a0,border
jal print
la $a0,receiverS3
jal print
la $a0,roof
jal print
j mode
p4: #Showing parcel has been delivered(if parcel has been sent successfully)
la $a0,roof
jal print
la $a0,driverP
jal print
la $a0,border
jal print
la $a0,driverS4
jal print
la $a0,roof
jal print
la $a0,receiverP
jal print
la $a0,border
jal print
la $a0,receiverS4
jal print
la $a0,roof
jal print
j mode
p5:#Shown if package has not been sent
la $a0,roof
jal print
la $a0,driverP
jal print
la $a0,border
jal print
la $a0,driverS5
jal print
la $a0,roof
jal print
la $a0,receiverP
jal print
la $a0,border
jal print
la $a0,receiverS5
jal print
la $a0,roof
jal print
j mode

#Muhammad Daniel Bin Darmawi 1913823 Line 294 - 330
time: #The start of time program state
la $a0,stp
jal print
la $a0,timePrompt
jal print
li $v0,5
syscall
beq $v0,10,exit #Exits program if input = 10
blt $v0,0000,TIME_ERROR_C_L #Checks if input within 24 hour time frame
bgt $v0,2359,TIME_ERROR_C_G 
blt $v0,1250,TIME_ERROR_L #Checks if input within the targeted time
bgt $v0,1310,TIME_ERROR_G
sle $t7,$v0,1310
sge $t7,$v0,1250
add $t9,$t9,$t7 #Adds state number if successful
beq $t9,1,loop
la $a0,error
jal print
j time #Loops if conditions are not met
#Error printing
TIME_ERROR_C_G: 
la $a0,timeErrorC_G
jal print
j time
TIME_ERROR_C_L:
la $a0,timeErrorC_L
jal print
j time
TIME_ERROR_L:
la $a0,timeError_L
jal print
j time
TIME_ERROR_G:
la $a0,timeError_G
jal print
j time

#Muhammad Hariz Bin Hasnan 1827929 Line 332 - 368
gps: #Start of gps program state
la $a0,stp
jal print
la $a0,gpsLatitude
jal print
li $v0,5
syscall
beq $v0,10,exit #Exits if input = 10
move $t0,$v0
sge $t3,$t0,0
sle $t3,$t0,180
beq $t3,0,gpsErrorPrompt #Error print if wrong range
la $a0,gpsLongitude #If within range moves to gps longitude
jal print
li $v0,5
syscall
move $t1,$v0
sge $t3,$t1,0
sle $t3,$t1,180
beq $t3,0,gpsErrorPrompt
lw $t3,latitude
seq $t0,$t0,$t3
lw $t3,longitude
seq $t1,$t1,$t3
add $t2,$t0,$t1
seq $t7,$t2,2
add $t9,$t9,$t7 #Adds state number if successful
add $t8,$t8,$t7 #Adds perspective number if successful
beq $t7,1,loop
la $a0,gpsError
jal print
j gps
gpsErrorPrompt: #Error printing
la $a0,gpsDegreeError
jal print
j gps

#Abdo Abdella Name 1714883
login: #The start of the login program state
la $a0,ptd
jal print
la $a0,loginPrompt
jal print
li $v0,5
syscall
beq $v0,10,exit #exit program if input = 10
lw $t0,password
seq $t7,$v0,$t0
add $t9,$t9,$t7 #Adds state number if successful
add $t8,$t8,$t7 #Adds perspective number if successful
beq $t7,1,loop
la $a0,loginError
jal print
j login

#Harith Bin Mohd Izani 1821037 Line 388 - 451
validate: #The start of the validation program state
la $a0,ptd2
jal print
la $a0,validatePrompt
jal print
la $a0,validateSpace
li $a1,11
li $v0,8
syscall
li $t0,0
validateLoop: #Checking each bit of the input if it matches the target name
lb $t1,validateSpace($t0)
beq $t1,0,validateContinue #Checking first bit to see if empty and move on to next section
beq $t1,0xa,validateContinue #checking first bit to see if empty and move on to next section
validateError: #Loop to check if the input is within the alphabet range
li $t6,'@'
sgt $t6,$t1,$t6  
slti $t6,$t1,'[' 
li $t5,'`'
sgt $t5,$t1,$t5 
slti $t5,$t1,'{'
add $t4,$t5,$t6 
beqz $t4,validateErrorMsg
beq $t6,1,lowercase
lowercaseReturn: #turning all letters to lowercase if its withing range
addi $t0,$t0,1
j validateLoop
lowercase:
add $t1,$t1,32
sb $t1,validateSpace($t0)
j lowercaseReturn
validateErrorMsg:#Error printing
la $a0,validateErrorPrompt
jal print
j validate
validateContinue: #This section checks if the input matched the name
li $t0,0
validateContinueLoop: #Checks if each letter matches
lb $t1,validateSpace($t0)
lb $t2,fName($t0)
beq $t2,0,validateContinueIC #If done checking all letters to be equal move to checking IC
beq $t1,$t2,validateContinueIncriment
la $a0,validateNErrorPrompt
jal print
j validate
validateContinueIncriment:
addi $t0,$t0,1
j validateContinueLoop
validateContinueIC: #loop to check if IC matches
la $a0,validateICPrompt
jal print 
li $v0,5
syscall
lw $t0,ic 
seq $t7,$t0,$v0
add $t9,$t9,$t7 #Adds state number if successful
add $t8,$t8,$t7 #Adds perspective number if successful
beq $t7,1,loop
la $a0,validateICError
jal print
li $t9,5
li $t8,6
j loop

#Group discussion aka together
sent: #Start of the sent program state
la $a0,ptd
jal print
la $a0,sentPrompt
jal print
la $a0,sentInput #
li $a1,2
li $v0,8
syscall
li $t0,0
lb $a0,sentInput
#To check if input matches y or n
beq $a0,'y',sentY
beq $a0,'Y',sentY
beq $a0,'n',sentN
beq $a0,'N',sentN
j sentError
sentN: #If parcel not sent it will prompt driver on why it wasnt sent
la $a0,sentNPrompt
jal print
la $a0,sentSpaceD
li $a1,50
li $v0,8
syscall
li $t9,5
li $t8,5
j loop
sentY: #If parcel is sent then driver is instructed to send next parcel
li $t9,5
li $t8,4
j loop
sentError: #Error printing
la $a0,sentErrorPrompt
jal print
j sent

#Print function
print:
li $v0,4
syscall
jr $ra

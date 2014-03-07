@echo off
copy test\knapsack\*.txt bin
cd bin
neko Knapsack.n
Knapsack-CS\bin\Knapsack-CS.exe
java -jar Knapsack-Java\Knapsack-Java.jar
pause

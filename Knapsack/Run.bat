@echo off
rem haxe -cp src -cp test -cs $(OutputDir)\$(ProjectName)-CS -main Main -$(BuildConfig)
rem haxe -cp src -cp test -java $(OutputDir)\$(ProjectName)-Java -main Main -$(BuildConfig)

copy test\knapsack\*.txt bin

cd bin

neko Knapsack.n
rem Knapsack-CS\bin\Knapsack-CS.exe
rem java -jar Knapsack-Java\Knapsack-Java.jar

pause

@echo off

del bin\error_*
del bin\example_*
copy test\knapsack\example_* bin

cd bin

SET KNAPSACK_FULL=1
SET KNAPSACK_SAVE=1

neko SingleBinaryKnapsack.n
SingleBinaryKnapsack-CS\bin\SingleBinaryKnapsack-CS.exe
java -jar SingleBinaryKnapsack-Java\SingleBinaryKnapsack-Java.jar
"c:\Program Files (x86)\Mono-2.10.9\bin\mono.exe" SingleBinaryKnapsack-CS\bin\SingleBinaryKnapsack-CS.exe

pause

@echo off

del bin\error_*
del bin\example_*
copy test\knapsack\example_* bin

cd bin

neko BinaryKnapsack.n
BinaryKnapsack-CS\bin\BinaryKnapsack-CS.exe
java -jar BinaryKnapsack-Java\BinaryKnapsack-Java.jar
"c:\Program Files (x86)\Mono-2.10.9\bin\mono.exe" BinaryKnapsack-CS\bin\BinaryKnapsack-CS.exe

pause

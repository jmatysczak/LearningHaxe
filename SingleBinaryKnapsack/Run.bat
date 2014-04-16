@echo off

del bin\error_*
del bin\example_*
copy test\knapsack\example_* bin

cd bin

neko SingleBinaryKnapsack.n
SingleBinaryKnapsack-CS\bin\SingleBinaryKnapsack-CS.exe
java -jar SingleBinaryKnapsack-Java\SingleBinaryKnapsack-Java.jar
"c:\Program Files (x86)\Mono-2.10.9\bin\mono.exe" SingleBinaryKnapsack-CS\bin\SingleBinaryKnapsack-CS.exe

pause

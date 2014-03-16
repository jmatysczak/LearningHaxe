@echo off
rem haxe -cp src -cp test -cs $(OutputDir)\$(ProjectName)-CS -main Main -$(BuildConfig)
rem haxe -cp src -cp test -java $(OutputDir)\$(ProjectName)-Java -main Main -$(BuildConfig)

del bin\error_*
del bin\example_*
copy test\knapsack\example_* bin

cd bin

neko BinaryKnapsack.n
rem BinaryKnapsack-CS\bin\BinaryKnapsack-CS.exe
rem java -jar BinaryKnapsack-Java\BinaryKnapsack-Java.jar
rem "c:\Program Files (x86)\Mono-2.10.9\bin\mono.exe" BinaryKnapsack-CS\bin\BinaryKnapsack-CS.exe

pause

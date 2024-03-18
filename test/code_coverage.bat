@echo off

CodeCoverage.exe ^
  -e .\Win64\Debug\horse_jsoninterceptor_test.exe ^
  -m .\Win64\Debug\horse_jsoninterceptor_test.map ^
  -dproj horse_jsoninterceptor_test.dproj ^
  -od .\Win64\Debug ^
  -emma ^
  -meta ^
  -xml ^
  -html
  
timeout /t -1
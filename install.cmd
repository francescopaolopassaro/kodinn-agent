@echo off
rem Kodinn Agent installer for Windows (cmd): runs install.ps1.
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/francescopaolopassaro/kodinn-agent/main/install.ps1 | iex"

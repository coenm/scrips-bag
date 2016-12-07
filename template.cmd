@echo off
::
::  See http://steve-jansen.github.io/guides/windows-batch-scripting/ for lots of tips and tricks.
::

SETLOCAL ENABLEDELAYEDEXPANSION
SET me=%~n0
SET parent=%~dp0
pushd %parent%

:: do stuff

popd
ENDLOCAL
@echo off

SET /A USE_ASIO=0

if not exist portaudio (
	echo Downloading portaudio
	mkdir portaudio
	curl --output portaudio.tgz -LJO http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz
	tar -C portaudio -xf portaudio.tgz --strip 1
	del portaudio.tgz
)

if /I "%USE_ASIO%" EQU "1" (
	if not exist asio_sdk (
		echo Downloading ASIO SDK
		mkdir asio_sdk
		curl --output asio_sdk.zip -LJO https://www.steinberg.net/asiosdk
		tar -C asio_sdk -xf asio_sdk.zip --strip 1
		del asio_sdk.zip
	)
)

rem Available backends on windows
rem PA_USE_ASIO
rem PA_USE_DS 
rem PA_USE_WMME
rem PA_USE_WASAPI
rem PA_USE_WDMKS

if /I "%USE_ASIO%" EQU "1" (
	SET BACKEND=PA_USE_ASIO
) else (
	SET BACKEND=PA_USE_WASAPI
)

echo Building portaudio

pushd portaudio
	cmake -G "NMake Makefiles"^
	 -D%BACKEND%=1^
	 -DCMAKE_BUILD_TYPE=Release
	nmake
popd

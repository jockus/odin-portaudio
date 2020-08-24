echo Downloading portaudio
if not exist portaudio (
	curl --output portaudio.tgz -LJO http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz
	if not exist portaudio mkdir portaudio
	tar -C portaudio -xf portaudio.tgz --strip 1
	del portaudio.tgz
)

rem Available backends on windows
rem PA_USE_ASIO
rem PA_USE_DS 
rem PA_USE_WMME
rem PA_USE_WASAPI
rem PA_USE_WDMKS

echo Building portaudio

pushd portaudio
	cmake -G "NMake Makefiles"^
	 -DPA_USE_WASAPI=1^
	 -DCMAKE_BUILD_TYPE=Release
	nmake
popd

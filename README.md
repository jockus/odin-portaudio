[PortAudio](http://www.portaudio.com) bindings for [odin-lang](http://odin-lang.org)

Run build.bat to download and compile PortAudio. Requires CMake to build.

Example:

```go
package main

import "core:fmt"
import "core:c"
import "core:os"
import "core:mem"
import "core:runtime"
import "core:math"


SAMPLE_RATE :: 44100;
NUM_SECONDS :: 5;

Data :: struct {
	phase : f32,
}
data : Data;

callback :: proc "c" (input : rawptr, output : rawptr, frameCount : c.ulong, timeInfo : ^StreamCallbackTimeInfo, statusFlags : StreamCallbackFlags, userData : rawptr)-> int { 
	userData := cast(^Data) userData;
	using userData;
	context = runtime.default_context();
	output := mem.slice_ptr(cast(^f32) output, int(frameCount));
	for sample, index in &output {
		phase += 0.01;
		if phase > 1 do phase -= 2;
		sample = phase * 0.1;
	}
	return 0;
}

main :: proc() {
	check_result :: proc(error : i32, loc := #caller_location) {
		if ErrorCode(error) != .NoError {
			fmt.printf("%v - %v", loc, GetErrorText(error));
			os.exit(1);
		}
	}

	check_result(Initialize());
	defer check_result(Terminate());

	fmt.println(GetVersionText());

	stream : ^Stream;
	check_result(OpenDefaultStream(&stream, 0, 1, Float32, SAMPLE_RATE, FramesPerBufferUnspecified, callback, &data));
	defer check_result(CloseStream(stream));

	check_result(StartStream(stream));

	Sleep(NUM_SECONDS * 1000);

	check_result(StopStream(stream));

}
```

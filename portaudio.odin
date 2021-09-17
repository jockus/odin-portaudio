package portaudio

import "core:c"

when ODIN_OS == "windows" do foreign import portaudio {"portaudio/portaudio_x64.lib", "system:advapi32.lib"}

NoDevice :: -1
UseHostApiSpecificDeviceSpecification :: -2
Float32 :: 1
Int32 :: 2
Int24 :: 4
Int16 :: 8
Int8 :: 16
UInt8 :: 32
CustomFormat :: 65536
NonInterleaved :: 2147483648
FormatIsSupported :: 0
FramesPerBufferUnspecified :: 0
NoFlag :: 0
ClipOff :: 1
DitherOff :: 2
NeverDropInput :: 4
PrimeOutputBuffersUsingStreamCallback :: 8
PlatformSpecificFlags :: 4294901760
InputUnderflow :: 1
InputOverflow :: 2
OutputUnderflow :: 4
OutputOverflow :: 8
PrimingOutput :: 16

Error :: i32
DeviceIndex :: i32
HostApiIndex :: i32
Time :: f64
SampleFormat :: c.ulong
Stream :: distinct rawptr
StreamFlags :: c.ulong
StreamCallbackFlags :: c.ulong

StreamCallback :: #type proc "c" (
    input : rawptr,
    output : rawptr,
    frameCount : c.ulong,
    timeInfo : ^StreamCallbackTimeInfo,
    statusFlags : StreamCallbackFlags,
    userData : rawptr,
) -> int
StreamFinishedCallback :: #type proc "c" (userData : rawptr)

ErrorCode :: enum i32 {
    NoError = 0,
    NotInitialized = -10000,
    UnanticitedHostError,
    InvalidChannelCount,
    InvalidSampleRate,
    InvalidDevice,
    InvalidFlag,
    SampleFormatNotSupported,
    BadIODeviceCombination,
    InsufficientMemory,
    BufferTooBig,
    BufferTooSmall,
    NullCallback,
    BadStreamPtr,
    TimedOut,
    InternalError,
    DeviceUnavailable,
    IncomtibleHostApiSpecificStreamInfo,
    StreamIsStopped,
    StreamIsNotStopped,
    InputOverflowed,
    OutputUnderflowed,
    HostApiNotFound,
    InvalidHostApi,
    CanNotReadFromACallbackStream,
    CanNotWriteToACallbackStream,
    CanNotReadFromAnOutputOnlyStream,
    CanNotWriteToAnInputOnlyStream,
    IncomtibleStreamHostApi,
    BadBufferPtr,
}

HostApiTypeId :: enum i32 {
    InDevelopment = 0,
    DirectSound = 1,
    MME = 2,
    ASIO = 3,
    SoundManager = 4,
    CoreAudio = 5,
    OSS = 7,
    ALSA = 8,
    AL = 9,
    BeOS = 10,
    WDMKS = 11,
    JACK = 12,
    WASAPI = 13,
    AudioScienceHPI = 14,
}

StreamCallbackResult :: enum i32 {
    Continue = 0,
    Complete = 1,
    Abort = 2,
}

VersionInfo :: struct {
    versionMajor : i32,
    versionMinor : i32,
    versionSubMinor : i32,
    versionControlRevision : cstring,
    versionText : cstring,
}

HostApiInfo :: struct {
    structVersion : i32,
    type : HostApiTypeId,
    name : cstring,
    deviceCount : i32,
    defaultInputDevice : DeviceIndex,
    defaultOutputDevice : DeviceIndex,
}

HostErrorInfo :: struct {
    hostApiType : HostApiTypeId,
    errorCode : c.long,
    errorText : cstring,
}

DeviceInfo :: struct {
    structVersion : i32,
    name : cstring,
    hostApi : HostApiIndex,
    maxInputChannels : i32,
    maxOutputChannels : i32,
    defaultLowInputLatency : Time,
    defaultLowOutputLatency : Time,
    defaultHighInputLatency : Time,
    defaultHighOutputLatency : Time,
    defaultSampleRate : f64,
}

StreamParameters :: struct {
    device : DeviceIndex,
    channelCount : i32,
    sampleFormat : SampleFormat,
    suggestedLatency : Time,
    hostApiSpecificStreamInfo : rawptr,
}

StreamCallbackTimeInfo :: struct {
    inputBufferAdcTime : Time,
    currentTime : Time,
    outputBufferDacTime : Time,
}

StreamInfo :: struct {
    structVersion : i32,
    inputLatency : Time,
    outputLatency : Time,
    sampleRate : f64,
}

@(default_calling_convention="c", link_prefix="Pa_")
foreign portaudio {

    GetVersion :: proc() -> i32 ---
    GetVersionText :: proc() -> cstring ---
    GetVersionInfo :: proc() -> ^VersionInfo ---

    GetErrorText :: proc(errorCode : Error) -> cstring ---

    Initialize :: proc() -> Error ---

    Terminate :: proc() -> Error ---

    GetHostApiCount :: proc() -> HostApiIndex ---

    GetDefaultHostApi :: proc() -> HostApiIndex ---

    GetHostApiInfo :: proc(hostApi : HostApiIndex) -> ^HostApiInfo ---

    HostApiTypeIdToHostApiIndex :: proc(type : HostApiTypeId) -> HostApiIndex ---

    HostApiDeviceIndexToDeviceIndex :: proc(
        hostApi : HostApiIndex,
        hostApiDeviceIndex : i32,
    ) -> DeviceIndex ---

    GetLastHostErrorInfo :: proc() -> ^HostErrorInfo ---

    GetDeviceCount :: proc() -> DeviceIndex ---

    GetDefaultInputDevice :: proc() -> DeviceIndex ---

    GetDefaultOutputDevice :: proc() -> DeviceIndex ---

    GetDeviceInfo :: proc(device : DeviceIndex) -> ^DeviceInfo ---

    IsFormatSupported :: proc(
        inputParameters : ^StreamParameters,
        outputParameters : ^StreamParameters,
        sampleRate : f64,
    ) -> Error ---

    OpenStream :: proc(
        stream : ^^Stream,
        inputParameters : ^StreamParameters,
        outputParameters : ^StreamParameters,
        sampleRate : f64,
        framesPerBuffer : c.ulong,
        streamFlags : StreamFlags,
        streamCallback : StreamCallback,
        userData : rawptr,
    ) -> Error ---

    OpenDefaultStream :: proc(
        stream : ^^Stream,
        numInputChannels : i32,
        numOutputChannels : i32,
        sampleFormat : SampleFormat,
        sampleRate : f64,
        framesPerBuffer : c.ulong,
        streamCallback : StreamCallback,
        userData : rawptr,
    ) -> Error ---

    CloseStream :: proc(stream : ^Stream) -> Error ---

    SetStreamFinishedCallback :: proc(
        stream : ^Stream,
        streamFinishedCallback : ^StreamFinishedCallback,
    ) -> Error ---

    StartStream :: proc(stream : ^Stream) -> Error ---

    StopStream :: proc(stream : ^Stream) -> Error ---

    AbortStream :: proc(stream : ^Stream) -> Error ---

    IsStreamStopped :: proc(stream : ^Stream) -> Error ---

    IsStreamActive :: proc(stream : ^Stream) -> Error ---

    GetStreamInfo :: proc(stream : ^Stream) -> ^StreamInfo ---

    GetStreamTime :: proc(stream : ^Stream) -> Time ---

    GetStreamCpuLoad :: proc(stream : ^Stream) -> f64 ---

    ReadStream :: proc(
        stream : ^Stream,
        buffer : rawptr,
        frames : c.ulong,
    ) -> Error ---

    WriteStream :: proc(
        stream : ^Stream,
        buffer : rawptr,
        frames : c.ulong,
    ) -> Error ---

    GetStreamReadAvailable :: proc(stream : ^Stream) -> c.long ---

    GetStreamWriteAvailable :: proc(stream : ^Stream) -> c.long ---

    GetSampleSize :: proc(format : SampleFormat) -> Error ---

    Sleep :: proc(msec : c.long) ---

}

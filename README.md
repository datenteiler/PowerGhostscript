# PowerGhostscript
Convert a PDF file into a Tiff file with PowerShell and Ghostscript

The 64-bit GhostscriptSharp.dll and gsdll64.dll are encoded with *certutil*. If you want to decode them manually use:

```dos
certutil -decode GhostscriptSharp.txt GhostscriptSharp.dll
certutil -decode gsdll64.txt gsdll64.dll
```

GhostscriptSharp.dll is compiled as 64-bit DLL from https://github.com/mephraim/ghostscriptsharp

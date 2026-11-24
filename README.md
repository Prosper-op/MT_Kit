# MT_Kit - MT Data Application

MT_Kit is a MATLAB application whose complete MATLAB interface and viewer
code is contained in the single file `MT_Kit.m`. It includes:

- A three-page interface: **Input Data**, **Processing**, and **Results**.
- A recording-library interface for importing Phoenix recordings, processed
  EDI files, and calibration files as references.
- An EDI response viewer with four log-period plots: rho-XY, rho-YX, phase-XY,
  and phase-YX.
- A Phoenix MTU-5A raw waveform preview for `.TBL` + `.TSn` recordings.

Requires Windows and MATLAB R2022b or newer.

## Run

### Start it inside MATLAB

1. Extract `MT_Kit.m` to a writable location.
2. In MATLAB, use **Home > Open** to open `MT_Kit.m`.
3. Press the green **Run** button in the Editor. This launches the MT_Kit
   desktop window. Opening a `.m` file by itself only displays its source code;
   it does not run the application.
4. Alternatively, set MATLAB's Current Folder to the project folder and enter
   `MT_Kit` in the Command Window.

No other `.m` files are required to run the MATLAB application.

### Optional Windows executable

The one-file MATLAB package is for running MT_Kit inside MATLAB. Building a
standalone Windows executable is a separate optional step that requires the
companion build and shortcut scripts in the full project folder, plus MATLAB
Compiler. The target Windows PC then needs the MATLAB Runtime matching the
Compiler release. This executable build has not been run or verified here.
1. On **Input Data**, drag and drop Phoenix `.TBL` / `.TSn` recordings,
   processed `.edi` files, `.ZIP` archives, or `.CLB` / `.CLC` calibration
   references. ZIP files ask whether they contain raw Phoenix recordings or
   processed EDI data.
2. Open **Processing** to select a recording and launch its raw waveform
   preview. Calibrated raw-to-EDI processing is not currently available.
3. Open **Results** to load/select processed EDI data and view the response
   plots. The results viewer can show all imported EDI inputs together.
4. Calibration `.CLB` / `.CLC` files can be listed as references, but are not
   parsed or applied.
5. By default, the viewer plots each station's average response in a separate
   color, matching the multi-station style in the supplied reference image.
   Select **Show all processing sections** to include the time-window sections.
6. Select **Export plot** to save the four-panel display as a PNG.
7. Select **Export data** to save the displayed sections as a CSV containing
   station, section, frequency, period, apparent resistivity, and phase.
8. Select **Open raw waveform preview** to inspect a Phoenix recording. If no
   recording is selected, MT_Kit opens a file chooser so you can select a ZIP
   or `.TBL`/`.TSn` file from your computer. Then select its metadata and
   sampling stream to inspect the first five seconds of the five channels.

The viewer reads apparent resistivity and phase already present in EDI files.
EDI empty-value sentinels are omitted from plots and written as `NaN` in CSV
exports.

The raw preview decodes the MTU-5A 32-byte time-series tags and signed 24-bit
samples, and uses the `.TBL` channel map for Ex, Ey, Hx, Hy, and Hz. It displays
raw ADC counts only. Calibration references are not applied, and calibrated
raw-to-EDI processing is not available.

## Intended use and validation boundary

The Windows executable must be built with the script above; this source
workspace does not include a compiled EXE. A compiled application requires the
matching MATLAB Runtime on the target machine; MATLAB itself is not required
there. The delivered functions are processed-EDI viewing/export and raw ADC
waveform preview. Impedance estimation from the supplied raw counts,
calibration, raw-to-EDI processing, automated outlier editing, and production
interpretation are not implemented or validated. Do not use raw previews as
calibrated measurements or treat the application as a production MT processor
until the required instrument calibration assets and a qualified, validated
processing workflow are available.

## Sample validation notes

- `W014.TBL` identifies site `WO13`, receiver MTU-5A serial 2293, and the
  five-channel map.
- The raw streams contain signed 24-bit samples at 24,000 Hz (TS2), 2,400 Hz
  (TS3), and 150 Hz (TS4). All record tags and payload lengths in the supplied
  streams were checked.
- The raw TS4 stream has 595,500 samples per channel, or 66 minutes 10 seconds.
  Its start time, site, receiver/sensor identifiers, and electrode lengths
  match the `WO13` EDI metadata in `PROCESSING.zip`.
- That EDI records `ApplyCalibrations=true`, Blackman-Nuttall tapers, and
  robust/jackknife processing settings. The raw archive does not contain the
  sensor/receiver calibration response files needed to reproduce those
  calibrated results.

## Research references

- [Phoenix time-series format and reader notes](https://resistics.io/formats/timeseries/Phoenix-timeseries.html)
- [MTU-5A TBL/TSn format and calibration notes](https://github.com/tviti/phx_files)
- [EPI-KIT raw MT/CSEM processing overview](https://nw-geophysics.com/epi)
- [Phoenix EMpower processing and calibration overview](https://www.phoenixgeophysics.com/empower-software)

The Resistics Phoenix format notes explicitly caution that Phoenix physical
scaling and calibration are not verified there; this application therefore
labels its raw traces as ADC counts and does not present them as calibrated
geophysical results.

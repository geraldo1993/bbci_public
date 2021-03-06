%In BBCI_CALIBRATE there are two central structures. 
%
%- The 'bbci' structure specifies WHAT should be done and HOW:
%loading of the data, processing, feature extraction, classification.
%It is the input to bbci_calibrate, and the output of bbci_calibrate
%will be an updated version of 'bbci' which then has all the information
%for online operation, see bbci_apply_structures.
%
%- The 'data' structure is used to store the recorded signals, and 
%results of the analysis that is done in the calibration.
%It is a working variable of bbci_calibrate. It is not necessary to
%care about this variable, but it can be used in iterative runs of
%bbci_calibrate in order to save loading and computing time.
%
%
%* Structure BBCI (defaults are set in bbci_calibrate_setDefaults):
%
%bbci.calibrate - Defines how the online system is calibrated
%  * struct with fields:
%  .fcn           [FCN-HANDLE, must be specified - no default] specifies the
%                 sub-function that performs the calibration. These functions
%                 typically have the prefix 'bbci_calibrate_' and are in the
%                 subfolder 'calibration'.
%  .settings      [STRUCT] parameters for the specific calibration function
%                 bbci.calibrate.fcn.
%  .folder        [STRING, default defined by global BTB.Tp.Dir]
%                 specifies the folder for calibration data files
%  .file          [STRING] specifies the name of the calibation file
%  .read_fcn      [FCN-HANDLE, default @file_readBV] function to read
%                 the signals and markers.
%  .read_param    [CELL] parameters passed to the .read_fcn
%  .marker_fcn    [FCN-HANDLE, default []] function to process markers
%  .marker_param  [CELL] parameters passed to the .marker_fcn
%  .montage_fcn   [FCN-HANDLE, default @getElectrodePositions]
%  .montage_param [CELL] parameters passed to the .montage_fcn
%  .save          [STRUCT] specifies what and how data is saved, see below.
%
% bbci.calibrate.save - Defines what and how data of calibration is saved
%  * struct with fields
%  .output
%  .folder        CHAR folder for storing classifier (and other calibration
%                 data, if requested); deafult is bbci.calibrate.folder.
%  .file          CHAR filename of classifier; default is 'bbci_classifier'
%  .overwrite     BOOL: if true, the file is always saved under the specified
%                 filename, even if the file already exists; otherwise,
%                 the value of an incremental counter is added in order to
%                 avoid overwriting. In the latter case, care has to be taken
%                 that the correct classifier is loaded for the application
%                 with bbci_apply. Default is true.
%  .raw_data      BOOL: if true, the raw data (cnt, mrk, mnt) is stored
%                 (see bbci.save.data); default is false.
%  .data          CHAR The structure 'data' (see below) that is returned by
%                 bbci_calibrate is either stored 'separately' is a file
%                 called as the corresponding classifier with appendix '_data'
%                 or in the same file as the classifier;
%                 default is 'separately'.
%  .figures       BOOL: if true, the figures generated by the calibration are
%                 stored in a directory named as the corresponding classifier
%                 file with the appendix '_figures'; default is false.
%                 The specific calibration function bbci_calibrate_*.m
%                 may specify in data.figure_handles which figures should
%                 be stored. If that field is missing, all figures are stored
%                 (which may include figures not related to calibration,
%                 unless 'close all' is executed before running calibration).
%  .figures_spec  CELL specifications for saving the figures (arguments
%                 passed to the function printFigure; default is
%                 {'paperSize', 'auto'}.
%
% bbci.calibrate.log - Defines whether and how information should be logged
%  * struct with fields
%  .output        0 (or 'none') for no logging, or 'screen', or 'file',
%                 or 'screen&file'; default is 'screen'.
%  .folder        CHAR folder for storing logfiles (if requested);
%                 default is bbci.calibrate.folder.
%  .file          CHAR filename of logfile; default is 'bbci_calibrate_log'.
%  .force_overwriting BOOL: if true, the log file is always saved under the
%                 specified filename, even if the file already exists; 
%                 otherwise, the value of an incremental counter is added in 
%                 order to avoid overwriting.
%
%  --- --- --- --- --- --- --- ---
%
%* Structure DATA  (returned by bbci_calibrate):
%
%data - struct array with fields:
%
%data.cnt, data.mrk, data.mnt: raw calibration data; to force reloading
%       the data in a further run of bbci_calibrate delete the field 'cnt'
%       from data (or do not pass argument data).
%data.filename   CHAR filename with path of the calibration data.
%
%data.log - Information from logging
%  .fid          file ID of log file (or 1 is bbci.log.output=='screen'),
%                if bbci.log.output=='screen&file', this is a vector
%                [1 file_id].
%  .filename     name of the log file (if bbci.log.output is 'file' or
%                'screen&file')
%
%Furthermore, there can be other fields in data that are specific to
%the employed calibration (i.e., the bbci_calibrate_*.m function).

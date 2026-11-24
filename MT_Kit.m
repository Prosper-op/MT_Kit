% MT_Kit is a self-contained MATLAB desktop application.
% Run this file from the MATLAB Editor or enter MT_Kit in the Command Window.

function MT_Kit
% Import MT recordings and open the available preview and EDI tools.

recordingPaths = {};
ediPaths = {};
calibrationPaths = {};

fig = uifigure('Name', 'MT_Kit', ...
    'Position', [100 100 1360 820], ...
    'Color', [0.96 0.97 0.98]);

root = uigridlayout(fig, [3 1]);
root.RowHeight = {64, '1x', 34};
root.Padding = [12 12 12 12];
root.RowSpacing = 10;

header = uigridlayout(root, [1 2]);
header.Layout.Row = 1;
header.ColumnWidth = {'1x', 220};
header.Padding = [14 8 14 8];
header.BackgroundColor = [0.12 0.18 0.24];

titleLabel = uilabel(header, ...
    'Text', 'MT_Kit', ...
    'FontSize', 20, ...
    'FontWeight', 'bold', ...
    'FontColor', [1 1 1]);
titleLabel.Layout.Column = 1;
subtitleLabel = uilabel(header, ...
    'Text', 'Input data  |  Processing  |  Results', ...
    'HorizontalAlignment', 'right', ...
    'FontColor', [0.86 0.9 0.93]);
subtitleLabel.Layout.Column = 2;

pages = uitabgroup(root);
pages.Layout.Row = 2;
inputPage = uitab(pages, 'Title', '1. Input Data');
processingPage = uitab(pages, 'Title', '2. Processing');
resultsPage = uitab(pages, 'Title', '3. Results');

inputLayout = uigridlayout(inputPage, [2 3]);
inputLayout.RowHeight = {190, '1x'};
inputLayout.ColumnWidth = {'1x', '1x', '1x'};
inputLayout.RowSpacing = 10;
inputLayout.ColumnSpacing = 10;
inputLayout.Padding = [12 12 12 12];

importPanel = uipanel(inputLayout, ...
    'Title', 'Drop your data here or use the file picker');
importPanel.Layout.Row = 1;
importPanel.Layout.Column = [1 3];
importLayout = uigridlayout(importPanel, [3 1]);
importLayout.RowHeight = {22, '1x', 34};
importLayout.Padding = [12 8 12 8];
importLayout.RowSpacing = 6;

importDescription = uilabel(importLayout, ...
    'Text', 'Supported: Phoenix .TBL/.TSn, processed .EDI, ZIP archives, and .CLB/.CLC references.', ...
    'HorizontalAlignment', 'center', ...
    'FontColor', [0.35 0.42 0.47]);
importDescription.Layout.Row = 1;

dropZone = uipanel(importLayout, ...
    'BorderType', 'line', ...
    'BackgroundColor', [0.95 0.98 0.99]);
dropZone.Layout.Row = 2;
dropLayout = uigridlayout(dropZone, [1 1]);
dropLayout.Padding = [8 8 8 8];
dropLabel = uilabel(dropLayout, ...
    'Text', 'Drag and drop your MT data here', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 16, ...
    'FontWeight', 'bold', ...
    'FontColor', [0.16 0.4 0.55]);
dropLabel.Layout.Row = 1;
dropLabel.Layout.Column = 1;
if isprop(fig, 'WindowDropFcn')
    fig.WindowDropFcn = @handleFileDrop;
else
    dropLabel.Text = 'File drag-and-drop is unavailable in this MATLAB version; use the Add buttons below.';
    dropLabel.FontSize = 13;
    dropLabel.FontColor = [0.55 0.2 0.12];
end

importButtons = uigridlayout(importLayout, [1 3]);
importButtons.Layout.Row = 3;
importButtons.ColumnWidth = {'1x', '1x', '1x'};
importButtons.ColumnSpacing = 8;
importButtons.Padding = [0 0 0 0];
uibutton(importButtons, 'push', ...
    'Text', 'Add recording', ...
    'ButtonPushedFcn', @(~, ~) addFiles('recording'));
uibutton(importButtons, 'push', ...
    'Text', 'Add processed EDI', ...
    'ButtonPushedFcn', @(~, ~) addFiles('edi'));
uibutton(importButtons, 'push', ...
    'Text', 'Add calibration reference', ...
    'ButtonPushedFcn', @(~, ~) addFiles('calibration'));

calibrationPanel = uipanel(inputLayout, 'Title', 'Calibration references');
calibrationPanel.Layout.Row = 2;
calibrationPanel.Layout.Column = 1;
calibrationLayout = uigridlayout(calibrationPanel, [2 1]);
calibrationLayout.RowHeight = {'1x', 32};
calibrationLayout.Padding = [8 8 8 8];
calibrationList = uilistbox(calibrationLayout, ...
    'Items', {'No calibration references added'}, ...
    'Enable', 'off');
calibrationList.Layout.Row = 1;
uilabel(calibrationLayout, ...
    'Text', 'Reference only - not applied', ...
    'HorizontalAlignment', 'center', ...
    'FontColor', [0.55 0.3 0.08]);

inputInfoPanel = uipanel(inputLayout, 'Title', 'Workflow');
inputInfoPanel.Layout.Row = 2;
inputInfoPanel.Layout.Column = [2 3];
inputInfoLayout = uigridlayout(inputInfoPanel, [3 1]);
inputInfoLayout.RowHeight = {36, '1x', 58};
inputInfoLayout.Padding = [14 10 14 10];
inputInfoLayout.RowSpacing = 8;
uilabel(inputInfoLayout, ...
    'Text', 'Choose one of the pages above to continue.', ...
    'FontSize', 16, ...
    'FontWeight', 'bold');
uilabel(inputInfoLayout, ...
    'Text', ['Processing page: inspect raw Phoenix traces. ' ...
    'Results page: view response data already contained in EDI files.'], ...
    'WordWrap', 'on');
uilabel(inputInfoLayout, ...
    'Text', 'Raw ADC counts are not calibrated and cannot be treated as final MT responses.', ...
    'WordWrap', 'on', ...
    'FontColor', [0.55 0.2 0.12]);

processingLayout = uigridlayout(processingPage, [5 2]);
processingLayout.RowHeight = {48, '1x', 40, 36, 80};
processingLayout.ColumnWidth = {'1x', '1x'};
processingLayout.Padding = [18 18 18 18];
processingLayout.RowSpacing = 10;
processingLayout.ColumnSpacing = 10;
processingHeading = uilabel(processingLayout, ...
    'Text', 'Raw data processing workspace', ...
    'FontSize', 20, ...
    'FontWeight', 'bold');
processingHeading.Layout.Row = 1;
processingHeading.Layout.Column = [1 2];
recordingListLabel = uilabel(processingLayout, ...
    'Text', 'Imported Phoenix recordings', ...
    'FontWeight', 'bold');
recordingListLabel.Layout.Row = 2;
recordingListLabel.Layout.Column = 1;
recordingList = uilistbox(processingLayout, ...
    'Items', {'No recordings added'}, ...
    'Enable', 'off');
recordingList.Layout.Row = 2;
recordingList.Layout.Column = 2;
addRecordingButton = uibutton(processingLayout, 'push', ...
   'Text', 'Add recording', ...
   'ButtonPushedFcn', @(~, ~) addFiles('recording'));
addRecordingButton.Layout.Row = 3;
addRecordingButton.Layout.Column = 1;
previewButton = uibutton(processingLayout, 'push', ...
   'Text', 'Open raw waveform preview', ...
   'ButtonPushedFcn', @previewRecording);
previewButton.Layout.Row = 3;
previewButton.Layout.Column = 2;
processButton = uibutton(processingLayout, 'push', ...
   'Text', 'Calibrated processing unavailable', ...
   'Enable', 'off', ...
   'Tooltip', 'MT_Kit currently supports raw waveform preview only; calibrated processing is not implemented.');
processButton.Layout.Row = 4;
processButton.Layout.Column = 1;
processingStatus = uilabel(processingLayout, ...
   'Text', 'Add a Phoenix recording on the Input Data page.', ...
   'WordWrap', 'on');
processingStatus.Layout.Row = 4;
processingStatus.Layout.Column = 2;
processingWarning = uilabel(processingLayout, ...
   'Text', ['Calibrated raw-to-EDI processing is not implemented. ' ...
   'The available viewer displays raw ADC counts only; no calibration or impedance estimation is applied.'], ...
    'WordWrap', 'on', ...
    'FontWeight', 'bold', ...
    'FontColor', [0.55 0.2 0.12]);
processingWarning.Layout.Row = 5;
processingWarning.Layout.Column = [1 2];

resultsLayout = uigridlayout(resultsPage, [5 2]);
resultsLayout.RowHeight = {48, '1x', 40, 36, 64};
resultsLayout.ColumnWidth = {'1x', '1x'};
resultsLayout.Padding = [18 18 18 18];
resultsLayout.RowSpacing = 10;
resultsLayout.ColumnSpacing = 10;
resultsHeading = uilabel(resultsLayout, ...
    'Text', 'Processed MT response results', ...
    'FontSize', 20, ...
    'FontWeight', 'bold');
resultsHeading.Layout.Row = 1;
resultsHeading.Layout.Column = [1 2];
ediListLabel = uilabel(resultsLayout, ...
    'Text', 'Imported EDI files or archives', ...
    'FontWeight', 'bold');
ediListLabel.Layout.Row = 2;
ediListLabel.Layout.Column = 1;
ediList = uilistbox(resultsLayout, ...
    'Items', {'No EDI data added'}, ...
    'Enable', 'off');
ediList.Layout.Row = 2;
ediList.Layout.Column = 2;
addEdiButton = uibutton(resultsLayout, 'push', ...
    'Text', 'Add processed EDI / ZIP', ...
    'ButtonPushedFcn', @(~, ~) addFiles('edi'));
addEdiButton.Layout.Row = 3;
addEdiButton.Layout.Column = 1;
viewResultsButton = uibutton(resultsLayout, 'push', ...
    'Text', 'View response plots', ...
    'ButtonPushedFcn', @viewAllEdiResults);
viewResultsButton.Layout.Row = 3;
viewResultsButton.Layout.Column = 2;
resultsStatus = uilabel(resultsLayout, ...
    'Text', 'Add processed EDI data on the Input Data page.', ...
    'WordWrap', 'on');
resultsStatus.Layout.Row = 4;
resultsStatus.Layout.Column = [1 2];
resultsNote = uilabel(resultsLayout, ...
    'Text', ['The response viewer reads values already present in EDI files. ' ...
    'It does not calculate calibrated responses from the raw recordings.'], ...
    'WordWrap', 'on', ...
    'FontColor', [0.25 0.36 0.44]);
resultsNote.Layout.Row = 5;
resultsNote.Layout.Column = [1 2];

statusLabel = uilabel(root, ...
    'Text', 'Ready - import data on the Input Data page.', ...
    'FontColor', [0.25 0.31 0.36]);
statusLabel.Layout.Row = 3;

    function handleFileDrop(~, event)
        if ~isprop(event, 'Data')
            statusLabel.Text = 'Drop ignored: this MATLAB version did not provide dropped file data.';
            uialert(fig, statusLabel.Text, 'Unsupported drop event');
            return;
        end
        droppedPaths = normalizeDroppedPaths(event.Data);
        if isempty(droppedPaths)
            statusLabel.Text = 'Drop ignored: no file paths were provided.';
            return;
        end

        previousRecordingCount = numel(recordingPaths);
        previousEdiCount = numel(ediPaths);
        previousCalibrationCount = numel(calibrationPaths);
        rejected = {};
        zipPaths = {};
        for pathIndex = 1:numel(droppedPaths)
            path = droppedPaths{pathIndex};
            if ~isfile(path)
                rejected{end + 1} = path; %#ok<AGROW>
                continue;
            end
            [~, ~, extension] = fileparts(path);
            switch lower(extension)
                case {'.edi'}
                    ediPaths = appendUnique(ediPaths, {path});
                case {'.tbl', '.ts2', '.ts3', '.ts4', '.ts5'}
                    recordingPaths = appendUnique(recordingPaths, {path});
                case {'.clb', '.clc'}
                    calibrationPaths = appendUnique(calibrationPaths, {path});
                case '.zip'
                    zipPaths{end + 1} = path; %#ok<AGROW>
                otherwise
                    rejected{end + 1} = path; %#ok<AGROW>
            end
        end

        for pathIndex = 1:numel(zipPaths)
            choice = uiconfirm(fig, ...
                sprintf('How should this archive be opened?\n\n%s', zipPaths{pathIndex}), ...
                'Choose archive type', ...
                'Options', {'Phoenix recording', 'Processed EDI', 'Skip'}, ...
                'DefaultOption', 1, ...
                'CancelOption', 3);
            switch choice
                case 'Phoenix recording'
                    recordingPaths = appendUnique(recordingPaths, zipPaths(pathIndex));
                case 'Processed EDI'
                    ediPaths = appendUnique(ediPaths, zipPaths(pathIndex));
            end
        end

        refreshWorkspace();
        if isempty(rejected)
            newRecordings = recordingPaths(previousRecordingCount + 1:end);
            newEdiFiles = ediPaths(previousEdiCount + 1:end);
            newCalibrations = calibrationPaths(previousCalibrationCount + 1:end);
            if ~isempty(newRecordings) && isempty(newEdiFiles)
                pages.SelectedTab = processingPage;
                statusLabel.Text = 'Recording imported. Select it on the Processing page and open the raw waveform preview.';
            elseif ~isempty(newEdiFiles) && isempty(newRecordings)
                pages.SelectedTab = resultsPage;
                statusLabel.Text = 'EDI data imported. Select a file on the Results page and open the response plots.';
            elseif isempty(newRecordings) && isempty(newEdiFiles)
                if isempty(newCalibrations)
                    statusLabel.Text = 'No files were added.';
                else
                    statusLabel.Text = 'Calibration references added. They are stored for reference and are not applied by this app.';
                end
            else
                statusLabel.Text = 'Files added. Select the appropriate viewer below; raw recordings are previewed as uncalibrated ADC counts.';
            end
        else
            statusLabel.Text = sprintf( ...
                'Some dropped files were not recognized (%d). Supported: .TBL/.TSn, .EDI, .ZIP, .CLB/.CLC.', ...
                numel(rejected));
            uialert(fig, sprintf('Unsupported or unavailable file(s):\n%s', ...
                strjoin(rejected, newline)), 'Some files were not imported');
        end
    end

    function addFiles(fileType)
        switch fileType
            case 'recording'
                [fileNames, folder] = uigetfile( ...
                    {'*.zip;*.TBL;*.tbl;*.TS2;*.TS3;*.TS4;*.TS5;*.ts2;*.ts3;*.ts4;*.ts5', ...
                    'Phoenix recordings (*.zip, *.TBL, *.TSn)'}, ...
                    'Select a Phoenix recording');
            case 'edi'
                [fileNames, folder] = uigetfile( ...
                    {'*.edi;*.EDI;*.zip;*.ZIP', 'Processed EDI data (*.edi, *.zip)'}, ...
                    'Select processed EDI files', ...
                    'MultiSelect', 'on');
            case 'calibration'
                [fileNames, folder] = uigetfile( ...
                    {'*.CLB;*.CLC;*.clb;*.clc', 'Phoenix calibration files (*.CLB, *.CLC)'}, ...
                    'Select calibration reference files', ...
                    'MultiSelect', 'on');
            otherwise
                error('mtDataWorkbench:UnknownInputType', ...
                    'Unsupported input type "%s".', fileType);
        end
        if isequal(fileNames, 0)
            return;
        end
        if ischar(fileNames) || isstring(fileNames)
            fileNames = cellstr(fileNames);
        end
        selectedPaths = cellfun(@(name) fullfile(folder, name), ...
            fileNames, 'UniformOutput', false);

        switch fileType
            case 'recording'
                recordingPaths = appendUnique(recordingPaths, selectedPaths);
                pages.SelectedTab = processingPage;
            case 'edi'
                ediPaths = appendUnique(ediPaths, selectedPaths);
                pages.SelectedTab = resultsPage;
            case 'calibration'
                calibrationPaths = appendUnique(calibrationPaths, selectedPaths);
        end
        refreshWorkspace();
    end

    function refreshWorkspace()
        setListItems(recordingList, recordingPaths, 'No recordings added');
        setListItems(ediList, ediPaths, 'No EDI data added');
        setListItems(calibrationList, calibrationPaths, ...
            'No calibration references added');

        processingStatus.Text = sprintf( ...
            '%d recording file(s) available. Preview shows raw ADC counts only.', ...
            numel(recordingPaths));
        resultsStatus.Text = sprintf( ...
            '%d EDI input(s) available for response plotting.', numel(ediPaths));
        statusLabel.Text = sprintf('Workspace: %d recording(s), %d EDI input(s), %d calibration reference(s).', ...
            numel(recordingPaths), numel(ediPaths), numel(calibrationPaths));
    end

    function previewRecording(~, ~)
        selectedPath = selectedPathFor(recordingPaths, recordingList);
        if isempty(selectedPath)
            uialert(fig, 'Add or select a Phoenix recording first.', ...
                'No recording selected');
            return;
        end
        mtRawViewer(selectedPath);
    end

    function viewAllEdiResults(~, ~)
        if isempty(ediPaths)
            uialert(fig, 'Add a processed EDI file or ZIP archive first.', ...
                'No processed data available');
            return;
        end
        mtEdiViewer(ediPaths);
    end

    function selectedPath = selectedPathFor(paths, listBox)
        selectedPath = '';
        if isempty(paths) || strcmp(listBox.Enable, 'off')
            return;
        end
        labels = makeLabels(paths);
        selection = find(strcmp(labels, listBox.Value), 1);
        if ~isempty(selection)
            selectedPath = paths{selection};
        end
    end
end

function paths = appendUnique(paths, newPaths)
for pathIndex = 1:numel(newPaths)
    if ~any(strcmp(paths, newPaths{pathIndex}))
        paths{end + 1} = newPaths{pathIndex}; %#ok<AGROW>
    end
end
end

function setListItems(listBox, paths, emptyText)
if isempty(paths)
    listBox.Items = {emptyText};
    listBox.Value = emptyText;
    listBox.Enable = 'off';
    return;
end
listBox.Items = makeLabels(paths);
listBox.Value = listBox.Items{end};
listBox.Enable = 'on';
end

function labels = makeLabels(paths)
labels = cell(size(paths));
for pathIndex = 1:numel(paths)
    [folder, baseName, extension] = fileparts(paths{pathIndex});
    [~, folderName] = fileparts(folder);
    labels{pathIndex} = sprintf('%s%s | %s', baseName, extension, folderName);
end
for pathIndex = 1:numel(labels)
    if sum(strcmp(labels, labels{pathIndex})) > 1
        [folder, baseName, extension] = fileparts(paths{pathIndex});
        labels{pathIndex} = sprintf('%s%s | %s', baseName, extension, folder);
    end
end
end

function paths = normalizeDroppedPaths(data)
if ischar(data)
    if isrow(data)
        paths = {data};
    else
        paths = cellstr(data);
    end
elseif isstring(data)
    paths = cellstr(data(:));
elseif iscell(data)
    paths = cell(size(data));
    for pathIndex = 1:numel(data)
        item = data{pathIndex};
        if ischar(item) || (isstring(item) && isscalar(item))
            paths{pathIndex} = char(item);
        else
            paths = {};
            return;
        end
    end
else
    paths = {};
end
end

function mtRawViewer(initialPath)
% Preview raw Phoenix MTU-5A time series without applying calibration.

if nargin < 1
    initialPath = '';
end
if isempty(initialPath)
    [fileName, folder] = uigetfile( ...
        {'*.zip;*.ZIP;*.TBL;*.tbl;*.TS2;*.TS3;*.TS4;*.TS5;*.ts2;*.ts3;*.ts4;*.ts5', ...
        'Phoenix recording files (*.zip, *.TBL, *.TSn)'}, ...
        'Choose a Phoenix recording from your computer');
    if isequal(fileName, 0)
        return;
    end
    initialPath = fullfile(folder, fileName);
end

fig = uifigure('Name', 'MT_Kit - Raw Waveform Preview', ...
    'Position', [150 100 1150 850]);
layout = uigridlayout(fig, [6 1]);
layout.RowHeight = {42, '1x', '1x', '1x', '1x', '1x'};
layout.Padding = [8 8 8 8];
layout.RowSpacing = 6;

toolbar = uigridlayout(layout, [1 4]);
toolbar.Layout.Row = 1;
toolbar.ColumnWidth = {180, 190, 80, '1x'};
toolbar.Padding = [0 0 0 0];
uibutton(toolbar, 'push', 'Text', 'Open Phoenix recording', ...
    'ButtonPushedFcn', @loadRecording);
uibutton(toolbar, 'push', ...
    'Text', 'Calibrated processing unavailable', ...
    'Enable', 'off', ...
    'Tooltip', 'Raw ADC counts cannot produce calibrated MT responses without validated calibration and processing.');
clearButton = uibutton(toolbar, 'push', 'Text', 'Clear', ...
    'ButtonPushedFcn', @clearPreview);
statusLabel = uilabel(toolbar, ...
    'Text', 'Raw ADC counts only; receiver and sensor calibration is not applied.', ...
    'HorizontalAlignment', 'right');

channelAxes = gobjects(5, 1);
channelNames = {'Ex', 'Ey', 'Hx', 'Hy', 'Hz'};
for channelIndex = 1:5
    channelAxes(channelIndex) = uiaxes(layout);
    channelAxes(channelIndex).Layout.Row = channelIndex + 1;
    title(channelAxes(channelIndex), channelNames{channelIndex});
    ylabel(channelAxes(channelIndex), '24-bit ADC counts');
    grid(channelAxes(channelIndex), 'on');
end
xlabel(channelAxes(5), 'Time from first sample (s)');
loadRecordingPath(initialPath);

    function loadRecording(~, ~)
        [fileName, folder] = uigetfile( ...
            {'*.zip;*.ZIP;*.TBL;*.tbl;*.TS2;*.TS3;*.TS4;*.TS5;*.ts2;*.ts3;*.ts4;*.ts5', ...
            'Phoenix recording files (*.zip, *.TBL, *.TSn)'}, ...
            'Select a Phoenix ZIP archive, TBL, or TS file');
        if isequal(fileName, 0)
            return;
        end

        loadRecordingPath(fullfile(folder, fileName));
    end

    function loadRecordingPath(selectedPath)
        statusLabel.Text = 'Reading selected recording...';
        drawnow;
        extractionFolder = '';
        try
            [~, ~, extension] = fileparts(selectedPath);
            if strcmpi(extension, '.zip')
                extractionFolder = tempname;
                mkdir(extractionFolder);
                cleanup = onCleanup(@() removeTemporaryFolder(extractionFolder)); %#ok<NASGU>
                unzip(selectedPath, extractionFolder);
                tablePaths = findFiles(extractionFolder, '.TBL');
                if isempty(tablePaths)
                    error('mtRawViewer:MissingTable', ...
                        'The selected archive contains no Phoenix .TBL file.');
                end
                tablePath = chooseFile(tablePaths, 'Select the station metadata file');
            else
                if strcmpi(extension, '.TBL')
                    tablePath = selectedPath;
                else
                    [parentFolder, baseName] = fileparts(selectedPath);
                    tablePaths = findFiles(parentFolder, '.TBL');
                    matches = tablePaths(cellfun(@(path) ...
                        strcmpi(filepartsName(path), baseName), tablePaths));
                    if isempty(matches)
                        error('mtRawViewer:MissingTable', ...
                            'No matching .TBL metadata file was found next to the TS file.');
                    end
                    tablePath = matches{1};
                end
            end
            if isempty(tablePath)
                return;
            end

            streamPaths = findStreams(tablePath);
            if isempty(streamPaths)
                error('mtRawViewer:MissingStreams', ...
                    'No matching .TSn time-series files were found beside the .TBL file.');
            end
            streamPath = chooseFile(streamPaths, ...
                'Select the sampling-rate stream to preview');
            if isempty(streamPath)
                return;
            end

            [samples, info] = readPhoenixPreview(streamPath, tablePath);
            fig.UserData.samples = samples;
            fig.UserData.info = info;
            plotPreview(samples, info);
            statusLabel.Text = sprintf( ...
                '%s / %s | %s | %g samples/s | first %0.3g s | raw ADC counts; no calibration', ...
                info.fileName, info.siteName, info.streamName, info.sampleRate, ...
                size(samples, 1) / info.sampleRate);
        catch exception
            statusLabel.Text = 'Raw preview failed.';
            uialert(fig, exception.message, 'Could not read Phoenix recording');
        end
    end

    function plotPreview(samples, info)
        sampleRate = info.sampleRate;
        time = (0:size(samples, 1) - 1)' / sampleRate;
        stride = max(1, ceil(size(samples, 1) / 5000));
        sampleIndices = 1:stride:size(samples, 1);
        for channelIndex = 1:5
            ax = channelAxes(channelIndex);
            cla(ax);
            plot(ax, time(sampleIndices), double(samples(sampleIndices, channelIndex)));
            title(ax, sprintf('%s | first-tag status %d | preview saturation flags %d', ...
                info.channelNames{channelIndex}, info.status, info.saturationFlags));
            ylabel(ax, '24-bit ADC counts');
            grid(ax, 'on');
        end
        xlabel(channelAxes(5), 'Time from first sample (s)');
        fig.Name = sprintf('MT_Kit - Raw Waveform Preview: %s, started %s', ...
            info.fileName, char(info.startTime));
    end

    function clearPreview(~, ~)
        for channelIndex = 1:5
            ax = channelAxes(channelIndex);
            cla(ax);
            title(ax, channelNames{channelIndex});
            ylabel(ax, '24-bit ADC counts');
            grid(ax, 'on');
        end
        xlabel(channelAxes(5), 'Time from first sample (s)');
        fig.Name = 'MT_Kit - Raw Waveform Preview';
        statusLabel.Text = 'Raw ADC counts only; receiver and sensor calibration is not applied.';
    end

end

function paths = findFiles(rootFolder, wantedExtension)
listing = dir(fullfile(rootFolder, '**', '*'));
paths = {};
for fileIndex = 1:numel(listing)
    if listing(fileIndex).isdir
        continue;
    end
    [~, ~, extension] = fileparts(listing(fileIndex).name);
    if strcmpi(extension, wantedExtension)
        paths{end + 1} = fullfile(listing(fileIndex).folder, ...
            listing(fileIndex).name); %#ok<AGROW>
    end
end
end

function paths = findStreams(tablePath)
[folder, baseName] = fileparts(tablePath);
listing = dir(fullfile(folder, '*'));
paths = {};
for fileIndex = 1:numel(listing)
    if listing(fileIndex).isdir
        continue;
    end
    [~, candidateBase, extension] = fileparts(listing(fileIndex).name);
    if strcmpi(candidateBase, baseName) && ...
            ~isempty(regexp(extension, '^\.TS\d+$', 'once', 'ignorecase'))
        paths{end + 1} = fullfile(folder, listing(fileIndex).name); %#ok<AGROW>
    end
end
end

function selectedPath = chooseFile(paths, prompt)
if numel(paths) == 1
    selectedPath = paths{1};
    return;
end
[selection, confirmed] = listdlg( ...
    'PromptString', prompt, ...
    'ListString', paths, ...
    'SelectionMode', 'single', ...
    'ListSize', [600 300]);
if confirmed
    selectedPath = paths{selection};
else
    selectedPath = '';
end
end

function name = filepartsName(path)
[~, name] = fileparts(path);
end

function removeTemporaryFolder(folder)
if ~isempty(folder) && isfolder(folder)
    rmdir(folder, 's');
end
end

function [samples, info] = readPhoenixPreview(streamPath, tablePath)
tableEntries = readPhoenixTable(tablePath);
requiredFields = {'CHEX', 'CHEY', 'CHHX', 'CHHY', 'CHHZ'};
if ~all(cellfun(@(field) isKey(tableEntries, field), requiredFields))
    error('mtRawViewer:MissingChannelMap', ...
        'The .TBL file does not contain a complete five-channel map.');
end
channelOrder = cellfun(@(field) double(tableEntries(field)), requiredFields);
if ~isequal(sort(channelOrder), 1:5)
    error('mtRawViewer:InvalidChannelMap', ...
        'The .TBL channel map must contain each channel index from 1 to 5 once.');
end

[~, baseName, extension] = fileparts(streamPath);
info.fileName = [baseName extension];
info.streamName = upper(extension(2:end));
info.siteName = 'Unknown site';
if isKey(tableEntries, 'SITE')
    info.siteName = char(tableEntries('SITE'));
end
info.channelNames = {'Ex', 'Ey', 'Hx', 'Hy', 'Hz'};
info.sampleRate = 0;
info.status = 0;
info.saturationFlags = 0;
info.startTime = NaT;

fileId = fopen(streamPath, 'rb', 'ieee-le');
if fileId < 0
    error('mtRawViewer:OpenFailed', 'Could not open "%s".', streamPath);
end
fileCleanup = onCleanup(@() fclose(fileId)); %#ok<NASGU>
samples = zeros(0, 5, 'int32');
maxPreviewSamples = inf;

while size(samples, 1) < maxPreviewSamples
    tag = fread(fileId, 32, '*uint8');
    if isempty(tag)
        break;
    end
    if numel(tag) ~= 32
        error('mtRawViewer:TruncatedTag', ...
            'The TS stream ends with an incomplete 32-byte record tag.');
    end

    scanCount = double(littleUnsigned(tag(11:12)));
    channelCount = double(tag(13));
    tagLength = double(tag(14));
    bytesPerSample = double(tag(18));
    sampleRate = double(littleUnsigned(tag(19:20)));
    if tagLength ~= 32 || channelCount ~= 5 || bytesPerSample ~= 3 || ...
            scanCount < 1 || sampleRate < 1
        error('mtRawViewer:UnsupportedTag', ...
            'Unsupported Phoenix record tag in "%s".', info.fileName);
    end
    if info.sampleRate == 0
        info.sampleRate = sampleRate;
        info.status = double(tag(15));
        info.saturationFlags = double(tag(16));
        maxPreviewSamples = sampleRate * 5;
        year = double(tag(8)) * 100 + double(tag(6));
        info.startTime = datetime(year, double(tag(5)), double(tag(4)), ...
            double(tag(3)), double(tag(2)), double(tag(1)));
    elseif info.sampleRate ~= sampleRate
        error('mtRawViewer:ChangingSampleRate', ...
            'The sample rate changes within "%s"; preview was stopped.', info.fileName);
    else
        info.saturationFlags = double(bitor( ...
            uint8(info.saturationFlags), uint8(tag(16))));
    end

    byteCount = scanCount * channelCount * bytesPerSample;
    payload = fread(fileId, byteCount, '*uint8');
    if numel(payload) ~= byteCount
        error('mtRawViewer:TruncatedRecord', ...
            'A Phoenix data record is incomplete in "%s".', info.fileName);
    end
    triplets = reshape(uint32(payload), 3, []).';
    unsignedValues = triplets(:, 1) + ...
        triplets(:, 2) .* uint32(256) + triplets(:, 3) .* uint32(65536);
    signedValues = int32(unsignedValues);
    negative = unsignedValues >= uint32(8388608);
    signedValues(negative) = int32(unsignedValues(negative) - uint32(16777216));
    recordSamples = reshape(signedValues, channelCount, []).';
    recordSamples = recordSamples(:, channelOrder);

    remaining = maxPreviewSamples - size(samples, 1);
    keepCount = min(size(recordSamples, 1), remaining);
    samples = [samples; recordSamples(1:keepCount, :)]; %#ok<AGROW>
end

if isempty(samples)
    error('mtRawViewer:NoSamples', 'No samples were read from "%s".', info.fileName);
end
end

function entries = readPhoenixTable(tablePath)
fileId = fopen(tablePath, 'rb', 'ieee-le');
if fileId < 0
    error('mtRawViewer:TableOpenFailed', 'Could not open "%s".', tablePath);
end
fileCleanup = onCleanup(@() fclose(fileId)); %#ok<NASGU>
bytes = fread(fileId, inf, '*uint8');
if isempty(bytes) || mod(numel(bytes), 25) ~= 0
    error('mtRawViewer:InvalidTable', ...
        'The Phoenix .TBL file length is not a multiple of 25 bytes.');
end

entries = containers.Map('KeyType', 'char', 'ValueType', 'any');
for recordStart = 1:25:numel(bytes)
    record = bytes(recordStart:recordStart + 24);
    if record(1) == 3
        break;
    end
    codeBytes = record(1:5);
    terminator = find(codeBytes == 0, 1);
    if ~isempty(terminator)
        codeBytes = codeBytes(1:terminator - 1);
    end
    code = strtrim(char(codeBytes'));
    if isempty(code)
        continue;
    end

    typeCode = double(record(12));
    valueBytes = record(13:20);
    if any(typeCode == [2 3 4])
        terminator = find(valueBytes == 0, 1);
        if ~isempty(terminator)
            valueBytes = valueBytes(1:terminator - 1);
        end
        value = char(valueBytes');
    elseif typeCode == 1
        value = littleDouble(valueBytes);
    elseif typeCode == 5
        value = valueBytes;
    else
        value = double(littleInt32(valueBytes(1:4)));
    end
    entries(code) = value;
end
end

function value = littleUnsigned(bytes)
bytes = uint32(bytes(:));
value = uint16(bytes(1) + bytes(2) .* uint32(256));
end

function value = littleInt32(bytes)
value = typecast(uint8(bytes(:)), 'int32');
[~, ~, endian] = computer;
if endian == 'B'
    value = swapbytes(value);
end
end

function value = littleDouble(bytes)
value = typecast(uint8(bytes(:)), 'double');
[~, ~, endian] = computer;
if endian == 'B'
    value = swapbytes(value);
end
end

function mtEdiViewer(inputPaths)
% View apparent resistivity and phase curves from MT EDI files.

if nargin < 1
    inputPaths = {};
elseif ischar(inputPaths) || isstring(inputPaths)
    inputPaths = cellstr(inputPaths);
end

loadedSections = struct( ...
    'fileLabel', {}, 'sectionLabel', {}, 'frequencyHz', {}, 'periodS', {}, ...
    'rhoXY', {}, 'phaseXY', {}, 'rhoYX', {}, 'phaseYX', {});

fig = uifigure('Name', 'MT_Kit - MT Response Viewer', 'Position', [100 100 1200 800]);
fig.UserData = [];

mainLayout = uigridlayout(fig, [3 2]);
mainLayout.RowHeight = {44, '1x', '1x'};
mainLayout.ColumnWidth = {'1x', '1x'};
mainLayout.Padding = [8 8 8 8];
mainLayout.RowSpacing = 8;
mainLayout.ColumnSpacing = 8;

toolbar = uigridlayout(mainLayout, [1 6]);
toolbar.Layout.Row = 1;
toolbar.Layout.Column = [1 2];
toolbar.ColumnWidth = {140, 135, 210, 100, 100, '1x'};
toolbar.Padding = [0 0 0 0];

uibutton(toolbar, 'push', 'Text', 'Load EDI / ZIP', ...
    'ButtonPushedFcn', @loadFiles);
uibutton(toolbar, 'push', 'Text', 'Raw waveform preview', ...
    'ButtonPushedFcn', @openRawViewer);
allSectionsBox = uicheckbox(toolbar, ...
    'Text', 'Show all processing sections', ...
    'Value', false, ...
    'ValueChangedFcn', @refreshPlots);
uibutton(toolbar, 'push', 'Text', 'Export plot', ...
    'ButtonPushedFcn', @exportPlot);
uibutton(toolbar, 'push', 'Text', 'Export data', ...
    'ButtonPushedFcn', @exportData);
clearButton = uibutton(toolbar, 'push', 'Text', 'Clear', ...
    'ButtonPushedFcn', @clearData);
statusLabel = uilabel(toolbar, ...
    'Text', 'Processed EDI viewer | raw traces are uncalibrated previews.', ...
    'HorizontalAlignment', 'right');

rhoXYAxes = uiaxes(mainLayout);
rhoXYAxes.Layout.Row = 2;
rhoXYAxes.Layout.Column = 1;
rhoYXAxes = uiaxes(mainLayout);
rhoYXAxes.Layout.Row = 2;
rhoYXAxes.Layout.Column = 2;
phaseXYAxes = uiaxes(mainLayout);
phaseXYAxes.Layout.Row = 3;
phaseXYAxes.Layout.Column = 1;
phaseYXAxes = uiaxes(mainLayout);
phaseYXAxes.Layout.Row = 3;
phaseYXAxes.Layout.Column = 2;

setupAxes();
if ~isempty(inputPaths)
    loadEdiPaths(inputPaths);
end

    function openRawViewer(~, ~)
        mtRawViewer();
    end

    function loadFiles(~, ~)
        [fileNames, folder] = uigetfile( ...
            {'*.edi;*.EDI;*.zip;*.ZIP', 'EDI files and ZIP archives (*.edi, *.zip)'}, ...
            'Select one or more EDI files or ZIP archives', ...
            'MultiSelect', 'on');
        if isequal(fileNames, 0)
            return;
        end
        if ischar(fileNames) || isstring(fileNames)
            fileNames = cellstr(fileNames);
        end
        selectedPaths = cellfun(@(fileName) fullfile(folder, fileName), ...
            fileNames, 'UniformOutput', false);
        loadEdiPaths(selectedPaths);
    end

    function loadEdiPaths(selectedPaths)
        statusLabel.Text = 'Loading and validating EDI responses...';
        drawnow;
        try
            newSections = struct( ...
                'fileLabel', {}, 'sectionLabel', {}, 'frequencyHz', {}, 'periodS', {}, ...
                'rhoXY', {}, 'phaseXY', {}, 'rhoYX', {}, 'phaseYX', {});
            for fileIndex = 1:numel(selectedPaths)
                selectedPath = selectedPaths{fileIndex};
                [~, selectedName] = fileparts(selectedPath);
                [~, ~, extension] = fileparts(selectedPath);
                if strcmpi(extension, '.zip')
                    extractFolder = tempname;
                    mkdir(extractFolder);
                    try
                        unzip(selectedPath, extractFolder);
                        ediPaths = findEdiFiles(extractFolder);
                        if isempty(ediPaths)
                            error('mtEdiViewer:NoEdiFiles', ...
                                'No .edi files were found in "%s".', selectedName);
                        end
                        for ediIndex = 1:numel(ediPaths)
                            parsed = parseEdiFile(ediPaths{ediIndex});
                            newSections = [newSections, parsed]; %#ok<AGROW>
                        end
                    catch exception
                        if isfolder(extractFolder)
                            rmdir(extractFolder, 's');
                        end
                        rethrow(exception);
                    end
                    if isfolder(extractFolder)
                        rmdir(extractFolder, 's');
                    end
                else
                    parsed = parseEdiFile(selectedPath);
                    newSections = [newSections, parsed]; %#ok<AGROW>
                end
            end

            if isempty(newSections)
                error('mtEdiViewer:NoResponses', ...
                    'No usable EDI response sections were found.');
            end
            loadedSections = newSections;
            refreshPlots([], []);
        catch exception
            statusLabel.Text = 'EDI load failed; previous plot retained.';
            uialert(fig, exception.message, 'Could not load MT data');
        end
    end

    function refreshPlots(~, ~)
        if isempty(loadedSections)
            return;
        end

        sectionsToPlot = selectSections(loadedSections, allSectionsBox.Value);
        statusLabel.Text = sprintf('%d file(s), %d section(s) displayed', ...
            numel(unique({sectionsToPlot.fileLabel})), numel(sectionsToPlot));
        plotResponses(sectionsToPlot);
        fig.UserData = sectionsToPlot;
    end

    function exportPlot(~, ~)
        if isempty(fig.UserData)
            uialert(fig, 'Load EDI data before exporting a plot.', 'No plot to export');
            return;
        end
        [fileName, folder] = uiputfile('*.png', 'Export MT response plot', ...
            'MT_response.png');
        if isequal(fileName, 0)
            return;
        end
        try
            exportgraphics(fig, fullfile(folder, fileName), 'Resolution', 200);
        catch exception
            uialert(fig, exception.message, 'Could not export plot');
        end
    end

    function exportData(~, ~)
        if isempty(fig.UserData)
            uialert(fig, 'Load EDI data before exporting results.', 'No data to export');
            return;
        end
        [fileName, folder] = uiputfile('*.csv', 'Export displayed response data', ...
            'MT_response.csv');
        if isequal(fileName, 0)
            return;
        end
        try
            sections = fig.UserData;
            station = cell(0, 1);
            sectionName = cell(0, 1);
            frequencyHz = zeros(0, 1);
            periodS = zeros(0, 1);
            rhoXY = zeros(0, 1);
            phaseXY = zeros(0, 1);
            rhoYX = zeros(0, 1);
            phaseYX = zeros(0, 1);
            for sectionIndex = 1:numel(sections)
                section = sections(sectionIndex);
                count = numel(section.frequencyHz);
                station = [station; repmat({section.fileLabel}, count, 1)]; %#ok<AGROW>
                sectionName = [sectionName; repmat({section.sectionLabel}, count, 1)]; %#ok<AGROW>
                frequencyHz = [frequencyHz; section.frequencyHz(:)]; %#ok<AGROW>
                periodS = [periodS; section.periodS(:)]; %#ok<AGROW>
                rhoXY = [rhoXY; section.rhoXY(:)]; %#ok<AGROW>
                phaseXY = [phaseXY; section.phaseXY(:)]; %#ok<AGROW>
                rhoYX = [rhoYX; section.rhoYX(:)]; %#ok<AGROW>
                phaseYX = [phaseYX; section.phaseYX(:)]; %#ok<AGROW>
            end
            responseTable = table(station, sectionName, frequencyHz, periodS, ...
                rhoXY, phaseXY, rhoYX, phaseYX, ...
                'VariableNames', {'Station', 'Section', 'Frequency_Hz', ...
                'Period_s', 'RhoXY_ohm_m', 'PhaseXY_deg', ...
                'RhoYX_ohm_m', 'PhaseYX_deg'});
            writetable(responseTable, fullfile(folder, fileName));
        catch exception
            uialert(fig, exception.message, 'Could not export data');
        end
    end

    function clearData(~, ~)
        loadedSections = struct( ...
            'fileLabel', {}, 'sectionLabel', {}, 'frequencyHz', {}, 'periodS', {}, ...
            'rhoXY', {}, 'phaseXY', {}, 'rhoYX', {}, 'phaseYX', {});
        fig.UserData = [];
        fig.Name = 'MT_Kit - MT Response Viewer';
        statusLabel.Text = 'Processed EDI viewer | raw traces are uncalibrated previews.';
        axesList = {rhoXYAxes, rhoYXAxes, phaseXYAxes, phaseYXAxes};
        for axisIndex = 1:numel(axesList)
            cla(axesList{axisIndex});
            setupAxes();
        end
    end

    function setupAxes()
        titles = {'rho(xy)', 'rho(yx)', 'phase(Zxy)', 'phase(Zyx)'};
        axesList = {rhoXYAxes, rhoYXAxes, phaseXYAxes, phaseYXAxes};
        for axisIndex = 1:numel(axesList)
            ax = axesList{axisIndex};
            title(ax, titles{axisIndex});
            xlabel(ax, 'Period (s)');
            grid(ax, 'on');
            ax.XScale = 'log';
            ax.XMinorGrid = 'on';
            ax.YMinorGrid = 'on';
        end
        ylabel(rhoXYAxes, 'Resistivity (ohm m)');
        ylabel(rhoYXAxes, 'Resistivity (ohm m)');
        ylabel(phaseXYAxes, 'Phase (degrees)');
        ylabel(phaseYXAxes, 'Phase (degrees)');
        rhoXYAxes.YScale = 'log';
        rhoYXAxes.YScale = 'log';
    end

    function plotResponses(sections)
        axesList = {rhoXYAxes, rhoYXAxes, phaseXYAxes, phaseYXAxes};
        for axisIndex = 1:numel(axesList)
            cla(axesList{axisIndex});
        end
        setupAxes();
        for axisIndex = 1:numel(axesList)
            hold(axesList{axisIndex}, 'on');
        end
        rhoXYAxes.YScale = 'log';
        rhoYXAxes.YScale = 'log';

        colors = lines(max(numel(sections), 1));
        for sectionIndex = 1:numel(sections)
            section = sections(sectionIndex);
            color = colors(sectionIndex, :);
            period = section.periodS;

            addPoints(rhoXYAxes, period, section.rhoXY, color, true);
            addPoints(rhoYXAxes, period, section.rhoYX, color, true);
            addPoints(phaseXYAxes, period, section.phaseXY, color, false);
            addPoints(phaseYXAxes, period, section.phaseYX, color, false);
        end

        rhoXYAxes.YLim = [1 2000];
        rhoYXAxes.YLim = [1 2000];
        phaseXYAxes.YLim = [-140 280];
        phaseYXAxes.YLim = [-320 100];

        sectionLabels = string({sections.sectionLabel});
        fileLabels = string({sections.fileLabel});
        legendLabels = fileLabels + " / " + sectionLabels;
        for axisIndex = 1:numel(axesList)
            legend(axesList{axisIndex}, legendLabels, 'Location', 'bestoutside');
            hold(axesList{axisIndex}, 'off');
        end

        uniqueFiles = unique(fileLabels);
        fig.Name = sprintf('MT_Kit - MT Response Viewer - %d file(s), %d section(s)', ...
            numel(uniqueFiles), numel(sections));
    end
end

function addPoints(ax, period, values, color, positiveOnly)
valid = isfinite(period) & period > 0 & isfinite(values) & abs(values) < 1e30;
if positiveOnly
    valid = valid & values > 0;
end
if any(valid)
    scatter(ax, period(valid), values(valid), 10, color, 'filled');
end
end

function selected = selectSections(sections, showAll)
if showAll
    selected = sections;
    return;
end

selected = sections([]);
fileLabels = unique({sections.fileLabel}, 'stable');
for fileIndex = 1:numel(fileLabels)
    indices = find(strcmp({sections.fileLabel}, fileLabels{fileIndex}));
    sectionNames = lower({sections(indices).sectionLabel});
    averageIndex = find(contains(sectionNames, 'avg'), 1);
    if isempty(averageIndex)
        selected(end + 1) = sections(indices(1)); %#ok<AGROW>
    else
        selected(end + 1) = sections(indices(averageIndex)); %#ok<AGROW>
    end
end
end

function sections = parseEdiFile(filePath)
text = fileread(filePath);
fileLabelToken = regexp(text, '(?im)^\s*DATAID\s*=\s*"?([^"\s]+)', ...
    'tokens', 'once');
if isempty(fileLabelToken)
    [~, fileLabel] = fileparts(filePath);
else
    fileLabel = fileLabelToken{1};
end

sectionStarts = regexp(text, '(?m)^>=MTSECT[^\r\n]*', 'start');
if isempty(sectionStarts)
    sectionStarts = 1;
end

sections = struct( ...
    'fileLabel', {}, 'sectionLabel', {}, 'frequencyHz', {}, 'periodS', {}, ...
    'rhoXY', {}, 'phaseXY', {}, 'rhoYX', {}, 'phaseYX', {});
for sectionIndex = 1:numel(sectionStarts)
    sectionStart = sectionStarts(sectionIndex);
    if sectionIndex < numel(sectionStarts)
        sectionEnd = sectionStarts(sectionIndex + 1) - 1;
    else
        sectionEnd = numel(text);
    end
    sectionText = text(sectionStart:sectionEnd);

    sectionToken = regexp(sectionText, ...
        '(?im)^\s*SECTID\s*=\s*"?([^"\s/]+)', 'tokens', 'once');
    if isempty(sectionToken)
        sectionLabel = sprintf('Section %d', sectionIndex);
    else
        sectionLabel = sectionToken{1};
    end

    frequency = readEdiArray(sectionText, 'FREQ', filePath, sectionLabel);
    rhoXY = readEdiArray(sectionText, 'RHOXY', filePath, sectionLabel);
    phaseXY = readEdiArray(sectionText, 'PHSXY', filePath, sectionLabel);
    rhoYX = readEdiArray(sectionText, 'RHOYX', filePath, sectionLabel);
    phaseYX = readEdiArray(sectionText, 'PHSYX', filePath, sectionLabel);
    counts = [numel(frequency), numel(rhoXY), numel(phaseXY), ...
        numel(rhoYX), numel(phaseYX)];
    if any(counts ~= counts(1))
        error('mtEdiViewer:InvalidArrayLength', ...
            'Response arrays have different lengths in section "%s" of "%s".', ...
            sectionLabel, filePath);
    end

    validFrequency = isfinite(frequency) & frequency > 0 & frequency < 1e30;
    frequency = frequency(validFrequency);
    rhoXY = rhoXY(validFrequency);
    phaseXY = phaseXY(validFrequency);
    rhoYX = rhoYX(validFrequency);
    phaseYX = phaseYX(validFrequency);
    rhoXY(~isfinite(rhoXY) | rhoXY <= 0 | abs(rhoXY) >= 1e30) = NaN;
    rhoYX(~isfinite(rhoYX) | rhoYX <= 0 | abs(rhoYX) >= 1e30) = NaN;
    phaseXY(~isfinite(phaseXY) | abs(phaseXY) >= 1e30) = NaN;
    phaseYX(~isfinite(phaseYX) | abs(phaseYX) >= 1e30) = NaN;

    sections(end + 1) = struct( ... %#ok<AGROW>
        'fileLabel', fileLabel, ...
        'sectionLabel', sectionLabel, ...
        'frequencyHz', frequency, ...
        'periodS', 1 ./ frequency, ...
        'rhoXY', rhoXY, ...
        'phaseXY', phaseXY, ...
        'rhoYX', rhoYX, ...
        'phaseYX', phaseYX);
end
end

function values = readEdiArray(sectionText, blockName, filePath, sectionLabel)
pattern = ['(?im)^>\s*' regexptranslate('escape', blockName) '\b[^\r\n]*'];
[~, headerEnd] = regexp(sectionText, pattern, 'start', 'end', 'once');
if isempty(headerEnd)
    error('mtEdiViewer:MissingEdiBlock', ...
        'Missing >%s block in section "%s" of "%s".', ...
        blockName, sectionLabel, filePath);
end

bodyStart = headerEnd + 1;
while bodyStart <= numel(sectionText) && ...
        (sectionText(bodyStart) == char(10) || sectionText(bodyStart) == char(13))
    bodyStart = bodyStart + 1;
end
if bodyStart > numel(sectionText)
    body = '';
else
    nextBlock = regexp(sectionText(bodyStart:end), '(?m)^\s*>', 'start', 'once');
    if isempty(nextBlock)
        body = sectionText(bodyStart:end);
    else
        bodyEnd = bodyStart + nextBlock - 2;
        if bodyEnd < bodyStart
            body = '';
        else
            body = sectionText(bodyStart:bodyEnd);
        end
    end
end

numberTokens = regexp(body, ...
    '[-+]?(?:\d+\.?\d*|\.\d+)(?:[EeDd][-+]?\d+)?', 'match');
numberTokens = regexprep(numberTokens, '[dD]', 'E');
values = reshape(str2double(numberTokens), 1, []);
if isempty(values)
    error('mtEdiViewer:EmptyEdiBlock', ...
        'The >%s block is empty in section "%s" of "%s".', ...
        blockName, sectionLabel, filePath);
end
end

function ediPaths = findEdiFiles(rootFolder)
listing = dir(fullfile(rootFolder, '**', '*'));
ediPaths = {};
for fileIndex = 1:numel(listing)
    if listing(fileIndex).isdir
        continue;
    end
    filePath = fullfile(listing(fileIndex).folder, listing(fileIndex).name);
    [parentFolder, baseName, extension] = fileparts(filePath);
    if ~strcmpi(extension, '.edi')
        continue;
    end
    if endsWith(lower(baseName), '_average')
        originalBase = regexprep(baseName, '_average$', '', 'ignorecase');
        if isfile(fullfile(parentFolder, [originalBase extension]))
            continue;
        end
    end
    ediPaths{end + 1} = filePath; %#ok<AGROW>
end
end

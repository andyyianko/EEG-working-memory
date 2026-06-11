clear; clc;
close all force;

% 不開 EEGLAB GUI，避免 getframe 錯誤
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab('nogui');

inDir = 'C:\Users\User\NTHU\MS_1Y_2Sem\Human Information Processing\final project';
outDir = 'C:\Users\User\NTHU\MS_1Y_2Sem\Human Information Processing\final project\np_compatible';

if ~exist(outDir, 'dir')
    mkdir(outDir);
end

%% ===== EEG：全部 channel 照原樣轉 =====
EEG = pop_loadset( ...
    'filename', 'sub-040_task-memory_eeg.set', ...
    'filepath', inDir);

EEG = eeg_checkset(EEG);

disp('EEG channel labels:');
disp({EEG.chanlocs.labels});

pop_saveset(EEG, ...
    'filename', 'sub-040_task-memory_eeg_np.set', ...
    'filepath', outDir, ...
    'savemode', 'twofiles');

disp('Done: EEG converted.');


%% ===== ECG：只保留 ECG channel，不要 PPG =====
EEG = pop_loadset( ...
    'filename', 'sub-040_task-memory_ecg.set', ...
    'filepath', inDir);

EEG = eeg_checkset(EEG);

labels = {EEG.chanlocs.labels};

disp('Original ECG-set channel labels:');
disp(labels);

ecgIdx = find(strcmpi(strtrim(labels), 'ECG'), 1);

if isempty(ecgIdx)
    error('找不到 ECG channel，請檢查 sub-040_task-memory_ecg.set 的 channel labels。');
end

fprintf('Selected ECG channel index = %d\n', ecgIdx);

% 只留下 ECG
EEG = pop_select(EEG, 'channel', ecgIdx);
EEG = eeg_checkset(EEG);

disp('After selecting ECG only:');
disp({EEG.chanlocs.labels});
disp(size(EEG.data));

pop_saveset(EEG, ...
    'filename', 'sub-040_task-memory_ecg_np.set', ...
    'filepath', outDir, ...
    'savemode', 'twofiles');

disp('Done: ECG converted with ECG channel only.');
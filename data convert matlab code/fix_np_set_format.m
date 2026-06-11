clear; clc;

outDir = 'C:\Users\User\NTHU\MS_1Y_2Sem\Human Information Processing\final project\np_compatible';

fix_one_file( ...
    fullfile(outDir, 'sub-040_task-memory_eeg_np.set'), ...
    fullfile(outDir, 'sub-040_task-memory_eeg_np_struct.set'), ...
    'sub-040_task-memory_eeg_np_struct.fdt');

fix_one_file( ...
    fullfile(outDir, 'sub-040_task-memory_ecg_np.set'), ...
    fullfile(outDir, 'sub-040_task-memory_ecg_np_struct.set'), ...
    'sub-040_task-memory_ecg_np_struct.fdt');

disp('Done.');

function fix_one_file(inSet, outSet, newFdtName)

    fprintf('\nLoading: %s\n', inSet);

    % 讀入目前這種「拆成很多 variables」的 .set
    S = load(inSet, '-mat');

    % 把所有欄位包回 EEG struct
    EEG = S;

    [outFolder, outBase, ~] = fileparts(outSet);
    [inFolder, ~, ~] = fileparts(inSet);

    % 找原本 .fdt
    if isfield(S, 'datfile') && ~isempty(S.datfile)
        oldFdt = fullfile(inFolder, S.datfile);
    elseif isfield(S, 'data') && ischar(S.data)
        oldFdt = fullfile(inFolder, S.data);
    else
        error('找不到原本的 .fdt 檔名，請檢查 data/datfile 欄位。');
    end

    newFdt = fullfile(outFolder, newFdtName);

    fprintf('Copy FDT:\n%s\n→\n%s\n', oldFdt, newFdt);

    if exist(oldFdt, 'file')
        copyfile(oldFdt, newFdt);
    else
        error('找不到原本的 .fdt：%s', oldFdt);
    end

    % 更新 metadata，讓 .set 指到新的 .fdt
    EEG.filename = [outBase '.set'];
    EEG.filepath = outFolder;
    EEG.datfile = newFdtName;
    EEG.data = newFdtName;
    EEG.saved = 'yes';

    % 重點：只存一個變數 EEG，不要再拆成很多欄位
    save(outSet, 'EEG', '-mat', '-v7');

    fprintf('Saved fixed SET: %s\n', outSet);

    % 檢查結果
    fprintf('\nwhos result for fixed file:\n');
    whos('-file', outSet)

end
# EEG-working-memory README

Demo video link：https://drive.google.com/file/d/1LdEuGH4EmAC9JFdJz_MTq0FhD6Vym0bD/view?usp=sharing

![pipeline graph](pipeline graph/pipeline_graph.png)

## 專案資料夾與檔案說明

本專案主要目的為使用 OpenNeuro working memory EEG 資料，透過 NeuroPype Pipeline Designer 進行 EEG 頻段特徵擷取，並進一步計算不同記憶負荷條件下的 workload 指標，最後使用 Python 進行視覺化比較與分析。

## 專案資料夾與檔案說明

```text
EEG-working-memory/
│
├── README.md
├── hip_final_project
├── project report.pdf
│
├── raw data/
├── data convert matlab code/
├── converted data/
├── Fz&Pz band data/
├── Fz_theta&Pz_alpha data/
├── workload/
├── comparison python code/
└── pipeline graph/
```

### 1. `hip_final_project`

此檔案為 NeuroPype 的 Pipeline Designer file，用於建立與執行 EEG 資料處理流程。

Pipeline 的主要功能包含：

1. 匯入轉換後的 `.set` EEG 檔案。
2. 針對不同 Sequence Length 的 marker 進行 Segmentation。
3. 擷取 Fz 與 Pz channel 的頻段特徵。
4. 輸出每個 trial 的 EEG band power CSV 檔案。

---

### 2. `raw data/`

此資料夾放置原始 EEG 資料。

資料來源為 OpenNeuro dataset：https://openneuro.org/datasets/ds003838/versions/1.0.6

本專案使用的原始檔案為：sub-040_task-memory_eeg.set

此檔案為尚未經過本專案 MATLAB 轉換處理的原始 EEG `.set` 檔案。

---

### 3. `data convert matlab code/`

此資料夾包含兩個 MATLAB 程式檔案：

convert.m
fix_np_set_format.m

執行順序如下：

1. convert.m
2. fix_np_set_format.m

其中：
* `convert.m`：用於將原始 `.set` EEG 檔案轉換成較適合 NeuroPype 讀取的格式。
* `fix_np_set_format.m`：用於修正轉換後 `.set` 檔案的資料結構，使其能夠正常作為 pipeline 的輸入。

---

### 4. `converted data/`

此資料夾放置經過 MATLAB 轉換後的 `.set` 檔案，作為 NeuroPype pipeline 的輸入資料。

主要使用檔案為：

sub-040_task-memory_eeg_np_struct.set

備註：

sub-040_task-memory_eeg_new.set

此檔案為老師協助轉換的 `.set` 檔案，也可以作為 pipeline 的輸入。

---

### 5. `Fz&Pz band data/`

此資料夾放置經過 NeuroPype pipeline 輸出的 EEG 頻段資料。

資料內容包含每個 trial 的 Fz 與 Pz channel 在不同 EEG 頻段下的特徵值，並以 CSV 格式輸出。

包含的頻段包括：

* delta
* theta
* alpha
* beta
* gamma

檔名前面的數字代表 Sequence Length，共有三種條件：05、09、13

例如：
5d_xxx.csv
9d_xxx.csv
13d_xxx.csv

其中：

* `5d` 代表 Sequence Length = 5
* `9d` 代表 Sequence Length = 9
* `13d` 代表 Sequence Length = 13

---

### 6. `Fz_theta&Pz_alpha data/`

此資料夾放置從 `Fz&Pz band data/` 中進一步整理出的特定頻段資料。

本專案主要使用：

* Fz channel 的 theta band
* Pz channel 的 alpha band

因此此資料夾中的資料是由原本的 Fz 與 Pz 頻段 CSV 中提取出：

Fz theta
Pz alpha

檔名前面的數字同樣代表 Sequence Length：05、09、13

---

### 7. `workload/`

此資料夾放置計算完成後的 workload data，並以 CSV 格式輸出。

本專案使用的 workload 指標概念為：Workload = Fz theta / Pz alpha

其中：

* Fz theta 代表 frontal theta activity，常用於反映認知控制與工作記憶負荷。
* Pz alpha 代表 parietal alpha activity，常用於觀察注意力、抑制與認知資源分配相關變化。
* 透過 Fz theta 與 Pz alpha 的比例，可以建立一個簡化的 EEG workload 指標。

檔名前面的數字同樣代表 Sequence Length：05、09、13
分別對應不同記憶負荷條件。

---

### 8. `comparison python code/`

此資料夾包含用於分析與繪圖的 Python 程式：comparison.py

此程式主要用途為：

1. 讀取 `workload/` 資料夾中的 workload CSV 檔案。
2. 比較不同 Sequence Length 條件下的 workload 變化。
3. 繪製 workload 分布或平均趨勢圖。
4. 用於觀察 Sequence Length 增加時，EEG workload 指標是否有隨之上升或產生差異。

---

### 9. `project report.pdf`

此為期末專題報告

---

## 專案執行流程

本專案的完整處理流程如下：

```text
raw data
   ↓
data convert matlab code
   ↓
converted data
   ↓
NeuroPype pipeline: hip_final_project
   ↓
Fz&Pz band data
   ↓
Fz_theta&Pz_alpha data
   ↓
workload
   ↓
comparison python code
   ↓
workload comparison result
```

簡要說明如下：

1. 從 OpenNeuro 下載原始 EEG `.set` 檔案。
2. 使用 MATLAB 程式轉換 `.set` 檔案格式。
3. 將轉換後的 `.set` 檔案輸入 NeuroPype pipeline。
4. 在 pipeline 中依照 marker 與 Sequence Length 進行 Segmentation。
5. 擷取 Fz 與 Pz channel 的 EEG band power。
6. 從輸出的 band data 中取出 Fz theta 與 Pz alpha。
7. 計算 workload 指標。
8. 使用 Python 對不同 Sequence Length 條件下的 workload 進行比較與繪圖。

---


## 摘要

本專案以 OpenNeuro 上的 working memory EEG 資料集作為分析對象，選擇 `sub-040` 受試者的 memory task EEG 資料進行處理。研究目標是觀察不同記憶負荷條件下，EEG 訊號是否能反映 workload 的變化。

在資料前處理部分，原始 `.set` 檔案先透過 MATLAB 轉換，使其格式能夠被 NeuroPype Pipeline Designer 正確讀取。接著在 NeuroPype 中建立 pipeline，依照實驗 marker 將 EEG 訊號切分成不同 trial，並根據 Sequence Length 分為 05、09、13 三種條件。Sequence Length 越大，代表受試者需要記憶的項目越多，因此理論上認知負荷也會越高。

在 EEG 特徵擷取部分，本專案主要關注 Fz 與 Pz 兩個電極位置。Fz 位於額葉區域，與工作記憶、注意力控制及認知負荷有關；Pz 位於頂葉區域，常與注意力分配及 alpha activity 變化相關。Pipeline 會先輸出 Fz 與 Pz 在 delta、theta、alpha、beta、gamma 等頻段的特徵資料，再進一步選取 Fz theta 與 Pz alpha 作為 workload 計算所需的主要特徵。

本專案使用的 workload 指標為 Fz theta 除以 Pz alpha。此指標的想法是：當工作記憶負荷增加時，frontal theta 可能會上升，而 parietal alpha 可能會因注意力與認知資源分配而改變，因此透過兩者的比例可以建立一個簡化的 workload measurement。最後，本專案使用 Python 程式讀取 workload CSV，並比較 Sequence Length = 05、09、13 三種條件下的 workload 差異。

整體而言，本專案建立了一個從原始 EEG 資料、資料格式轉換、NeuroPype pipeline 特徵擷取、workload 計算，到 Python 視覺化分析的完整流程。此流程可用於初步觀察 EEG workload 指標是否會隨著 working memory task 難度上升而產生變化。

---

## 使用方式

### Step 1：準備原始資料

將 OpenNeuro 下載的原始檔案放入：raw data/

使用檔案：sub-040_task-memory_eeg.set

---

### Step 2：執行 MATLAB 轉換程式

進入：data convert matlab code/

依序執行：
```text
convert.m
   ↓
fix_np_set_format.m
```
完成後會得到可供 NeuroPype pipeline 使用的 `.set` 檔案。

---

### Step 3：將轉換後資料放入 `converted data/`

主要輸入檔案為：sub-040_task-memory_eeg_np_struct.set

或使用老師協助轉換的版本：sub-040_task-memory_eeg_new.set

---

### Step 4：開啟 NeuroPype Pipeline Designer

開啟 pipeline 檔案：hip_final_project

並將 input file 設定為：converted data/sub-040_task-memory_eeg_np_struct.set

接著執行 pipeline，輸出 Fz 與 Pz 的 EEG band data。

---

### Step 5：整理 Fz theta 與 Pz alpha

從 `Fz&Pz band data/` 中取出：Fz theta、Pz alpha

並放入：Fz_theta&Pz_alpha data/

---

### Step 6：計算 workload

使用下列公式計算 Workload = Fz theta / Pz alpha

計算後的結果放入：workload/

---

### Step 7：執行 Python 繪圖分析

進入：comparison python code/

執行：python comparison.py

此程式會讀取 workload data，並比較不同 Sequence Length 條件下的 workload 變化。

---

## Sequence Length 說明

本專案使用三種 Sequence Length 條件：

| 檔名前綴 | Sequence Length | 說明                     |
| ---- | --------------: | ---------------------- |
| `05` |               5 | 較低 working memory load |
| `09` |               9 | 中等 working memory load |
| `13` |              13 | 較高 working memory load |

Sequence Length 越大，表示受試者需要記憶的數字或項目越多，因此預期 workload 可能會越高。

---

## 注意事項

1. 執行 MATLAB 轉換時，必須先執行 `convert.m`，再執行 `fix_np_set_format.m`。
2. NeuroPype pipeline 的輸入檔案建議使用 `sub-040_task-memory_eeg_np_struct.set`。
3. 若此檔案無法正常讀取，也可以改用 `sub-040_task-memory_eeg_new.set`。
4. `Fz&Pz band data/` 是 pipeline 的主要輸出結果。
5. `Fz_theta&Pz_alpha data/` 是從完整 band data 中整理出的 workload 計算用資料。
6. `workload/` 中的 CSV 為最後進行比較分析的主要資料。
7. `comparison.py` 會使用 workload CSV 進行繪圖與比較，因此執行前需確認 `workload/` 中已有對應的 05、09、13 資料。

---

## 專案重點

本專案完成以下內容：

* 使用 OpenNeuro working memory EEG data。
* 將原始 `.set` 檔案轉換為 NeuroPype 可讀格式。
* 使用 NeuroPype Pipeline Designer 擷取 EEG band power。
* 針對 Fz 與 Pz channel 進行特徵整理。
* 使用 Fz theta 與 Pz alpha 建立 workload 指標。
* 比較 Sequence Length 05、09、13 在 workload 上的差異。
* 使用 Python 進行 workload 視覺化分析。

---

## Environment

本專案主要使用工具：

MATLAB
NeuroPype Pipeline Designer
Python
OpenNeuro EEG dataset

---

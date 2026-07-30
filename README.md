# Fxxk MS Pinyin

解決 Windows 內建「微軟拼音輸入法」轉換正體中文時大量出現異體字候選字的問題。
Fixes Microsoft Pinyin IME defaulting to variant-character candidates when typing Traditional Chinese.

<div align="right">
  <a href="#繁體中文">繁體中文</a> ｜ <a href="#english">English</a>
</div>

<details open>
<summary><b>繁體中文</b></summary>

## 繁體中文

Windows 內建「微軟拼音輸入法」轉換正體中文時，預設候選字大量是異體字／簡體字殘留字形（例如「説」「麽」、「強」打成「强」、「內」打成「内」）。本專案透過微軟拼音的「自訂短語」功能，把常見的錯誤候選字／詞覆蓋成正確的正體字寫法。

### 使用方式

1. 開啟微軟拼音輸入法設定 →「自訂短語」（或「自造詞」/「用戶詞典」，依 Windows 版本介面而定）。
2. 使用「匯入」功能，選擇本倉庫中的 `UserDefinedPhrase.dat`。
   - 或者手動關閉輸入法後，直接把檔案複製到微軟拼音的使用者資料目錄，取代原本的 `UserDefinedPhrase.dat`（建議先備份原檔）。
3. 重新啟動輸入法（或登出重登）讓設定生效。

### 收錄原則

- **單字直接收錄**：只在該字幾乎沒有其他合理讀音/字義衝突時才用單字（例如「強」「掛」「腳」）。
- **詞組收錄**：只要單字有歧義、可能誤傷其他正確用字，就改成完整詞語（例如不直接把「佛」全部改成「彿」，因為會誤傷「佛山」「佛教」；只收錄「彷彿」這個詞）。
- 詞條資料來自實際部落格文章新舊版本的逐字比對，抓出真實會被微軟拼音打錯的異體字模式，而不是憑空列表。

### 檔案格式

`UserDefinedPhrase.dat` 是微軟拼音自訂短語的二進位格式（`mschxudp` 開頭）。如果想自行擴充，建議透過微軟拼音官方的自訂短語介面新增，而不是直接手改二進位檔。

### 授權

自由使用、修改、散佈。歡迎 PR 補充你自己遇到的異體字案例。

</details>

<details>
<summary><b>English</b></summary>

## English

Windows' built-in Microsoft Pinyin IME defaults to variant / leftover-simplified character forms when typing Traditional Chinese (e.g. offering 説 instead of 說, 强 instead of 強, 内 instead of 內). This project uses Microsoft Pinyin's "Custom Phrase" (自訂短語) feature to override those wrong default candidates with the correct Traditional Chinese forms.

### Usage

1. Open Microsoft Pinyin IME settings → "Custom Phrase" (naming varies by Windows version).
2. Use the Import function and select `UserDefinedPhrase.dat` from this repo.
   - Alternatively, close the IME and copy the file directly into the Microsoft Pinyin user data folder, overwriting the existing `UserDefinedPhrase.dat` (back up the original first).
3. Restart the IME (or sign out/in) for changes to take effect.

### Inclusion criteria

- **Single-character entries**: only used when the character has no meaningful conflicting usage (e.g. 強, 掛, 腳).
- **Word/phrase entries**: used whenever a single character is ambiguous and a blanket fix would break other correct words (e.g. 佛 is not globally mapped to 彿, since that would break 佛山/佛教 — only the word 彷彿 is included).
- Entries are derived from diffing real before/after versions of blog posts, so they reflect actual recurring mistakes rather than a generic list.

### File format

`UserDefinedPhrase.dat` is Microsoft Pinyin's binary custom-phrase format (starts with the `mschxudp` magic bytes). To extend it yourself, add entries through the official Custom Phrase UI rather than editing the binary directly.

### License

Free to use, modify, and distribute. PRs adding your own encountered variant-character cases are welcome.

</details>

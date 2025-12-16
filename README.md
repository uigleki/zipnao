# zipnao

A Flutter desktop application for fixing CJK (Chinese, Japanese, Korean) character encoding issues in ZIP archives and text files.

## Features

- 🔍 **Smart Encoding Detection**: Automatic detection using character frequency analysis
- 📦 **ZIP Archive Support**: Extract ZIP files with corrected filenames
- 📄 **Text File Support**: Convert text files to UTF-8 with correct source encoding
- 📊 **Confidence Scores**: View all possible encodings ranked by likelihood
- 👁️ **Preview Results**: See decoded text before processing
- 🎨 **Modern UI**: Material Design 3 with dark/light theme support
- 🎯 **Drag & Drop**: Simple file selection interface

## Supported Encodings

- UTF-8
- GBK (Simplified Chinese)
- Big5 (Traditional Chinese)
- Shift_JIS (Japanese)
- EUC-JP (Japanese)
- EUC-KR (Korean)

## Installation

### Download

Download the latest release from the [Releases](https://github.com/uigleki/zipnao/releases/latest) page.

**Requirements**: Windows 10 or later

### Build from Source

```bash
git clone https://github.com/uigleki/zipnao.git
cd zipnao
flutter pub get
flutter run -d windows
```

**Requirements**: Flutter SDK 3.10.1+

## Usage

1. Drag and drop a file (`.zip` or `.txt`) or click to browse
2. Review detected encodings with confidence scores and preview
3. Select the correct encoding (highest score auto-selected)
4. Modify output path if needed
   - ZIP: Default `[filename]/`
   - TXT: Default `[filename]_fixed.txt`
5. Click **Extract** (ZIP) or **Fix** (TXT)

**Examples**:

- `archive.zip` → `archive/` with corrected filenames
- `document.txt` → `document_fixed.txt` in UTF-8

## How It Works

### Why Not Use Existing Tools?

Traditional encoding detectors like `chardet` fail on CJK text. They often return confidence scores around 0.01 (essentially random guessing) and default to windows-1252 when unsure. This happens because legacy CJK encodings can decode as each other without errors—there's no reliable way to rule out incorrect encodings through error detection alone.

### Character Frequency Analysis

zipnao uses a different approach based on real language statistics:

1. **Test all encodings**: Decode with UTF-8, GBK, Big5, Shift_JIS, EUC-JP, EUC-KR
2. **Score with real data**: Calculate frequency score based on how often characters appear in actual Chinese, Japanese, and Korean text
3. **Rank by confidence**: Higher frequency = more likely correct
4. **Visual verification**: Preview decoded results before processing

This method works for any CJK mojibake scenario. ZIP archives and text files are common cases because these formats don't embed encoding metadata.

### Detection Algorithm

1. **Sample extraction**: Read first 10,000 bytes from ZIP filenames or text content
2. **Preprocessing**: Remove ASCII characters—they don't help distinguish CJK encodings
3. **Decoding**: Attempt decode with each supported encoding
4. **Scoring**: Calculate average character frequency for each result
5. **Ranking**: Sort by score (descending) and auto-select highest

**Character frequency data**: From [Wordfreq](https://github.com/rspeer/wordfreq) corpus

## Technical Details

### Architecture

- **UI Layer**: Material Design 3 widgets with responsive layout
- **State Management**: Provider pattern with ChangeNotifier (MVVM)
- **Data Layer**: Repository pattern for data access
- **Services**: Encoding detection, ZIP extraction, text conversion
- **Async Processing**: Isolates for CPU-intensive encoding detection

### Key Dependencies

- `provider` - State management
- `archive` - ZIP file handling
- `charset` - Character encoding conversion
- `big5_utf8_converter` - Big5 encoding support
- `msgpack_dart` - Frequency data deserialization
- `desktop_drop` - Drag and drop support
- `file_picker` - File selection dialogs
- `data_table_2` - Enhanced data tables

### Project Structure

```text
lib/
├── main.dart          # Entry point
├── app.dart           # MaterialApp configuration
├── ui/                # UI layer (MVVM)
│   ├── home/          # Main screen
│   └── core/          # Shared components
├── domain/            # Domain models
├── data/              # Repositories & services
├── utils/             # Helpers and constants
└── di/                # Dependency injection
```

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

### Third-Party Data

Character frequency data from [Wordfreq](https://github.com/rspeer/wordfreq) (CC BY-SA 4.0)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

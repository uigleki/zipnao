# zipnao

A Flutter desktop application for fixing CJK (Chinese, Japanese, Korean) character encoding issues in ZIP archives and text files.

## Overview

**zipnao** automatically detects and corrects mojibake (garbled text) caused by incorrect character encoding in filenames and file contents. It's particularly useful when dealing with ZIP archives created on systems with different default encodings.

## Features

- 🔍 **Smart Encoding Detection**: Automatically detects the correct encoding using character frequency analysis
- 📦 **ZIP Archive Support**: Extract ZIP files with corrected filenames
- 📄 **Text File Support**: Convert text files to the correct encoding
- 🎯 **Drag & Drop**: Simple drag-and-drop interface for file selection
- 📊 **Multiple Encoding Results**: View all possible encodings with confidence scores
- 🎨 **Modern UI**: Material Design 3 interface with dark/light theme support
- ⚡ **Non-blocking**: Asynchronous processing to keep UI responsive

## Supported Encodings

- UTF-8
- GBK (Chinese)
- Big5 (Traditional Chinese)
- Shift_JIS (Japanese)
- EUC-JP (Japanese)
- EUC-KR (Korean)

## Installation

### Prerequisites

- Windows 10 or later
- No additional dependencies required

### Download

Download the latest release from the [Releases](https://github.com/uigleki/zipnao/releases/latest) page.

### Build from Source

1. Install [Flutter](https://flutter.dev/docs/get-started/install) (SDK 3.10.1 or later)
2. Clone this repository:

   ```bash
   git clone https://github.com/uigleki/zipnao.git
   cd zipnao
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run -d windows
   ```

5. Build release version:

   ```bash
   flutter build windows --release
   ```

## Usage

### For ZIP Archives

1. **Select File**: Drag and drop a ZIP file or click to browse
2. **Review Results**: The app will analyze filenames and show detected encodings with confidence scores
3. **Choose Encoding**: The highest-scoring encoding is selected by default, but you can choose another
4. **Set Output Path**: Modify the extraction path if needed (defaults to `[original_path]/[filename]/`)
5. **Extract**: Click "Extract" to decompress with corrected filenames

**Example**: `D:\archive.zip` → `D:\archive\` (with fixed filenames)

### For Text Files

1. **Select File**: Drag and drop a `.txt` file or click to browse
2. **Review Results**: The app will analyze content and show detected encodings
3. **Choose Encoding**: Select the correct encoding from the results
4. **Set Output Path**: Modify the output path if needed (defaults to `[original_path]/[filename]_fixed.txt`)
5. **Fix**: Click "Fix" to convert and save the file

**Example**: `D:\document.txt` → `D:\document_fixed.txt` (with correct encoding)

## How It Works

### Encoding Detection Algorithm

1. **Data Extraction**:
   - ZIP files: Concatenate all filenames → take first 10,000 bytes
   - Text files: Read file content → take first 10,000 bytes

2. **Preprocessing**: Remove ASCII characters (`[a-zA-Z0-9]`) as they don't help distinguish CJK encodings

3. **Scoring**:
   - Decode bytes using each supported encoding
   - For each decoded character, look up its frequency in the CJK frequency database
   - Sum all character frequencies → calculate average score
   - Higher score = higher confidence

4. **Selection**: Results are sorted by score (descending), with the top result auto-selected

### Character Frequency Data

The app uses character frequency data from [Wordfreq](https://github.com/rspeer/wordfreq) (CC BY-SA 4.0) to determine the likelihood of each encoding. The data is stored in `assets/data/cjk_freq.msgpack` and includes frequency information for Chinese, Japanese, and Korean characters.

## Technical Details

### Architecture

- **UI Layer**: Material Design 3 widgets with responsive layout
- **State Management**: Provider pattern with ChangeNotifier
- **Data Layer**: Repository pattern for data access
- **Services**: Encoding detection, ZIP extraction, text conversion
- **Async Processing**: Uses Flutter's `compute()` function to run encoding detection in isolates

### Key Dependencies

- `provider` - State management
- `archive` - ZIP file handling
- `charset` - Character encoding conversion
- `big5_utf8_converter` - Big5 encoding support
- `msgpack_dart` - Frequency data deserialization
- `desktop_drop` - Drag and drop support
- `file_picker` - File selection dialog
- `data_table_2` - Enhanced data table widget

### Project Structure

```text
zipnao/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── app.dart                  # MaterialApp configuration
│   ├── ui/                       # UI layer
│   │   ├── home/                 # Main screen
│   │   └── core/                 # Shared UI components
│   ├── domain/                   # Domain models
│   ├── data/                     # Data layer (repositories & services)
│   ├── utils/                    # Utilities and helpers
│   └── di/                       # Dependency injection
├── test/                         # Unit and widget tests
├── assets/                       # Static assets
│   ├── images/                   # App icon
│   └── data/                     # CJK frequency data
└── windows/                      # Windows platform code
```

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

### Third-Party Licenses

- Character frequency data: [Wordfreq](https://github.com/rspeer/wordfreq) (CC BY-SA 4.0)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Character frequency data provided by [Wordfreq](https://github.com/rspeer/wordfreq)
- Built with [Flutter](https://flutter.dev/)

## Support

If you encounter any issues or have questions, please [open an issue](https://github.com/uigleki/zipnao/issues) on GitHub.

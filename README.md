# LifeGrid

LifeGrid is a SwiftUI reflection app that represents an 80-year life frame as 4,160 weeks. It helps students capture small memories through drawings, mood stickers, short reflections, weekly kindness prompts, and time capsules.

The MVP focuses on low-pressure reflection: a Day Cover is valid when it contains a drawing, a mood, or a written reflection.

## Features

- Visualises an 80-year life frame as a grid of weekly cells
- Creates editable daily artwork with PencilKit
- Stores both PencilKit stroke data and a PNG thumbnail for each drawing
- Restores saved strokes so an existing drawing can be edited
- Adds an optional mood sticker and short reflection to a Day Cover
- Browses memories by Year, Month, Week, or Day
- Opens a selected week directly from the LifeGrid
- Displays drawing thumbnails in calendar cells
- Includes weekly kindness prompts, a memory jar, and time capsules
- Presents clear validation and recovery messages

## Day Cover Rules

A Day Cover:

- must contain artwork, a mood, or a non-empty reflection;
- cannot be created for a future date; and
- must be the only primary cover for its calendar day.

Editing an existing cover preserves its identity, original date, and creation date.

## Architecture

The project separates application responsibilities into five main layers:

```text
LifeGrid
├── Domain
│   ├── Models
│   └── Errors
├── Data
│   └── Repositories
├── UseCases
├── ViewModels
└── Views
```

The domain and use-case layers store artwork as `Data`, keeping them independent of PencilKit and SwiftUI. UI support code converts between `PKDrawing`, editable drawing data, and PNG thumbnails.

The current MVP uses in-memory repositories, which keeps the business rules easy to test and allows persistent storage to be introduced later without changing the domain model.

## Requirements

- macOS with Xcode
- An iOS Simulator or physical iPhone/iPad that supports the project's deployment target
- No third-party dependencies

## Running the App

1. Clone the repository:

   ```bash
   git clone https://github.com/LALAJJ0302/LifeGrid.git
   ```

2. Open `LifeGrid.xcodeproj` in Xcode.
3. Select the `LifeGrid` scheme.
4. Choose an iOS Simulator or connected device.
5. Press **Run** or use `Command-R`.

## Running the Tests

In Xcode, press `Command-U` to run the test suite.

The test coverage includes:

- successful creation with a drawing;
- successful creation with only a mood;
- empty-cover validation;
- future-date validation;
- same-calendar-day duplicate validation;
- date-range filtering and ordering;
- Year, Month, Week, and Day boundary handling;
- editable PencilKit drawing restoration;
- artwork encoding and decoding;
- existing-cover updates; and
- memory timeline navigation.

The current test suite passes all 28 test cases on an iPhone 17 Pro simulator running iOS 26.5.

## Key Technologies

- Swift
- SwiftUI
- PencilKit
- Combine
- Swift Testing

## Current MVP Limitations

- Day Covers and drawings are stored in memory and are cleared when the app closes.
- The LifeGrid currently stores an integer age rather than a full birth date, so dates selected from the 80-year week grid are estimates.
- The interface prioritises core behaviour and has not received a final visual-design pass.
- Apple Pencil interaction has not yet been verified on physical hardware.

## Next Steps

- Add SwiftData or file-based persistence
- Store a birth date for precise week-to-date mapping
- Add UI and accessibility testing
- Refine the visual design and drawing tools
- Verify Apple Pencil behaviour on a physical iPad

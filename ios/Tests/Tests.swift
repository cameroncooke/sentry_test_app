//
//  Tests.swift
//  Tests
//
//  Created by  Cameron Cooke on 14/05/2026.
//

import XCTest
import SnapshottingTests


final class Tests: SnapshotTest {
  /// Returns an optional array of preview names to be included in the snapshot testing. This also supports Regex format.
  ///
  /// Override this method to specify which previews should be included in the snapshot test.
  /// - Returns: An optional array of String containing the names of previews to be included.
  override class func snapshotPreviews() -> [String]? {
    nil
  }
  
  /// Returns an optional array of preview names to be excluded from the snapshot testing. This also supports Regex format.
  ///
  /// Override this method to specify which previews should be excluded from the snapshot test.
  /// - Returns: An optional array of String containing the names of previews to be excluded.
  override class func excludedSnapshotPreviews() -> [String]? {
    nil
  }

  /// Returns an optional array of module names to include in snapshot testing.
  ///
  /// Elements should be exact module names from the preview type name, such as "MyModule" in "MyModule.MyView_Previews".
  override class func snapshotPreviewModules() -> [String]? {
    nil
  }

  /// Returns an optional array of module names to exclude from snapshot testing.
  ///
  /// Elements should be exact module names from the preview type name, such as "MyModule" in "MyModule.MyView_Previews".
  override class func excludedSnapshotPreviewModules() -> [String]? {
    nil
  }
}

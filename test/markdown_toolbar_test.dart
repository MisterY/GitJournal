import 'package:flutter/material.dart';

import 'package:test/test.dart';

import 'package:gitjournal/widgets/markdown_toolbar.dart';

void main() {
  void _testLine({
    @required String before,
    @required int beforeOffset,
    @required String after,
    @required int afterOffset,
    @required String char,
  }) {
    var val = TextEditingValue(
      text: before,
      selection: TextSelection.collapsed(offset: beforeOffset),
    );

    var expectedVal = TextEditingValue(
      text: after,
      selection: TextSelection.collapsed(offset: afterOffset),
    );

    expect(modifyCurrentLine(val, char), expectedVal);
  }

  void _testH1({
    @required String before,
    @required int beforeOffset,
    @required String after,
    @required int afterOffset,
  }) {
    _testLine(
      before: before,
      beforeOffset: beforeOffset,
      after: after,
      afterOffset: afterOffset,
      char: '# ',
    );

    _testLine(
      before: after,
      beforeOffset: afterOffset,
      after: before,
      afterOffset: beforeOffset,
      char: '# ',
    );
  }

  test('Adds a header to the first line correctly', () {
    _testH1(
      before: 'Hello',
      beforeOffset: 5,
      after: '# Hello',
      afterOffset: 7,
    );
  });

  test('Adds a header to the last line correctly', () {
    _testH1(
      before: 'Hi\nHello',
      beforeOffset: 8,
      after: 'Hi\n# Hello',
      afterOffset: 10,
    );
  });

  test('Adds a header to a middle line correctly', () {
    _testH1(
      before: 'Hi\nHello\nFire',
      beforeOffset: 8,
      after: 'Hi\n# Hello\nFire',
      afterOffset: 10,
    );
  });

  test('Adds a header to a middle line middle word correctly', () {
    _testH1(
      before: 'Hi\nHello Darkness\nFire',
      beforeOffset: 8,
      after: 'Hi\n# Hello Darkness\nFire',
      afterOffset: 10,
    );
  });

  test('Removes header when cursor is at the start of the line', () {
    _testLine(
      before: 'Hi\n# Hello Darkness\nFire',
      beforeOffset: 3,
      after: 'Hi\nHello Darkness\nFire',
      afterOffset: 3,
      char: '# ',
    );
  });

  test("Removes header when cursor is in between '#' and ' '", () {
    _testLine(
      before: 'Hi\n# Hello Darkness\nFire',
      beforeOffset: 4,
      after: 'Hi\nHello Darkness\nFire',
      afterOffset: 3,
      char: '# ',
    );
  });

  //
  // Word based
  //
  void _testWord({
    @required String before,
    @required int beforeOffset,
    @required String after,
    @required int afterOffset,
    @required String char,
  }) {
    var val = TextEditingValue(
      text: before,
      selection: TextSelection.collapsed(offset: beforeOffset),
    );

    var expectedVal = TextEditingValue(
      text: after,
      selection: TextSelection.collapsed(offset: afterOffset),
    );

    expect(modifyCurrentWord(val, char), expectedVal);
  }

  test("Surrounds the first word", () {
    _testWord(
      before: 'Hello',
      beforeOffset: 3,
      after: '**Hello**',
      afterOffset: 7,
      char: '**',
    );
  });

  test("Removing from the first word", () {
    _testWord(
      before: '**Hello**',
      beforeOffset: 3,
      after: 'Hello',
      afterOffset: 5,
      char: '**',
    );
  });

  test("Surrounds the middle word", () {
    _testWord(
      before: 'Hello Hydra Person',
      beforeOffset: 8,
      after: 'Hello **Hydra** Person',
      afterOffset: 13,
      char: '**',
    );
  });

  test("Removes the middle word", () {
    _testWord(
      before: 'Hello **Hydra** Person',
      beforeOffset: 9,
      after: 'Hello Hydra Person',
      afterOffset: 11,
      char: '**',
    );
  });

  //
  // Navigation
  //
  test('Navigation with only 1 word', () {
    var val = const TextEditingValue(
      text: 'Hello',
      selection: TextSelection.collapsed(offset: 3),
    );

    expect(nextWordPos(val), 5);

    val = const TextEditingValue(
      text: 'Hello',
      selection: TextSelection.collapsed(offset: 5),
    );

    expect(nextWordPos(val), 5);

    val = const TextEditingValue(
      text: 'Hello',
      selection: TextSelection.collapsed(offset: 3),
    );

    expect(prevWordPos(val), 0);

    val = const TextEditingValue(
      text: 'Hello',
      selection: TextSelection.collapsed(offset: 5),
    );

    expect(prevWordPos(val), 0);
  });

  // Test for navigating between punctuations
  // Test for navigating between newlines
}
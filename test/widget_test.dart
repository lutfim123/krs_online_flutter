import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krs_online_flutter/main.dart';
import 'package:krs_online_flutter/models/course.dart';
import 'package:krs_online_flutter/widgets/course_card.dart';

void main() {
  testWidgets('Menampilkan tampilan awal dengan 0/24 SKS dan tombol Kirim KRS nonaktif', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const KrsOnlineApp());

    expect(find.text('Sistem KRS Online Sederhana'), findsOneWidget);
    expect(find.text('0/24 SKS'), findsOneWidget);
    expect(find.text('Daftar Mata Kuliah Tersedia (9)'), findsOneWidget);
    expect(find.byType(CourseCard), findsNWidgets(9));

    final submitButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Kirim KRS'),
    );
    expect(submitButton.onPressed, isNull);
  });

  testWidgets('Memilih mata kuliah dan melakukan pencarian mata kuliah', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const KrsOnlineApp());

    await tester.tap(find.text('Pemrograman Perangkat Bergerak'));
    await tester.pumpAndSettle();
    expect(find.text('3/24 SKS'), findsOneWidget);

    await tester.tap(find.text('Pengolahan Citra Digital'));
    await tester.pumpAndSettle();
    expect(find.text('6/24 SKS'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Citra');
    await tester.pumpAndSettle();

    expect(find.byType(CourseCard), findsOneWidget);
    expect(find.text('Pengolahan Citra Digital'), findsOneWidget);
    expect(find.text('6/24 SKS'), findsOneWidget);
  });

  testWidgets('Menampilkan peringatan saat total SKS melebihi 24 SKS', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const KrsOnlineApp());

    for (final course in dummyCourses) {
      await tester.tap(find.text(course.name));
      await tester.pump();
    }
    await tester.pumpAndSettle();

    expect(find.text('25/24 SKS'), findsOneWidget);
    expect(
      find.text('Peringatan: Total SKS melebihi batas maksimal 24 SKS!'),
      findsOneWidget,
    );

    final submitButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Kirim KRS'),
    );
    expect(submitButton.onPressed, isNull);
  });

  testWidgets('Konfirmasi pengiriman KRS dan mengunci pilihan', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const KrsOnlineApp());

    for (int i = 0; i < 5; i++) {
      await tester.tap(find.text(dummyCourses[i].name));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(find.text('15/24 SKS'), findsOneWidget);

    await tester.tap(find.text('Kirim KRS'));
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi Kirim KRS'), findsOneWidget);
    expect(find.text('Ya, Kirim'), findsOneWidget);

    await tester.tap(find.text('Ya, Kirim'));
    await tester.pumpAndSettle();

    expect(find.text('KRS Terkunci'), findsOneWidget);
    expect(
      find.textContaining('KRS Terkirim & Terkunci'),
      findsOneWidget,
    );

    await tester.tap(find.text(dummyCourses[0].name));
    await tester.pumpAndSettle();
    expect(find.text('15/24 SKS'), findsOneWidget);
  });
}

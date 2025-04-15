import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('DropMenu مع أيقونات')),
        body: Center(
          child: CustomCard(
              title: "عنوان البطاقة", description: "هذا نص توضيحي للبطاقة"),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String description;

  CustomCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **عنوان البطاقة مع زر القائمة**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                /// **زر القائمة المنسدلة مع أيقونات**
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        print("تم اختيار تعديل");
                        break;
                      case 'delete':
                        print("تم اختيار حذف");
                        break;
                      case 'share':
                        print("تم اختيار مشاركة");
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    /// **عنصر تعديل مع أيقونة قلم**
                    PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit, color: Colors.blue),
                        title: Text('تعديل'),
                      ),
                    ),

                    /// **عنصر حذف مع أيقونة سلة المهملات**
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('حذف'),
                      ),
                    ),

                    /// **عنصر مشاركة مع أيقونة المشاركة**
                    PopupMenuItem(
                      value: 'share',
                      child: ListTile(
                        leading: Icon(Icons.share, color: Colors.green),
                        title: Text('مشاركة'),
                      ),
                    ),
                  ],
                  icon: Icon(Icons.more_vert), // أيقونة ثلاث نقاط
                ),
              ],
            ),

            SizedBox(height: 10),

            /// **وصف البطاقة**
            Text(description,
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

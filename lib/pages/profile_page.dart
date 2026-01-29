
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:history_identifier/model/model.dart';
import 'package:history_identifier/pages/detay_page.dart';
import 'package:history_identifier/providers/providers.dart';
import 'package:history_identifier/widgets/widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            unselectedLabelColor: Theme.of(context).appBarTheme.iconTheme!.color,
            labelColor: Theme.of(context).appBarTheme.actionsIconTheme!.color,
            indicatorColor: Colors.black,
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget> [

              Tab(icon: Icon(Icons.bookmark),),
              Tab(icon: Icon(Icons.person),)

            ]
          ),
        ),

        body: TabBarView(
          children: <Widget> [

            SavedContentTab(),
            ProfilSettingsTab()

          ]
        ),

      )
    );
  }
}





class ProfilSettingsTab extends ConsumerWidget {
  const ProfilSettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    var theme = ref.watch(themeModeProvider);
    var mode = theme == ThemeMode.dark;

    return Column(
      children: [

        SizedBox(height: 20,),

        ListTile(
          leading: Text("navigation.thememodetext".tr(), style:  Theme.of(context).textTheme.bodyLarge),
          trailing: Switch(
            
            value: mode, 
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).state = value ? ThemeMode.dark : ThemeMode.light;
            },
            
          )
        ),
        
        Divider(color: Theme.of(context).dividerColor),

        ListTile(
          leading: Text("navigation.themeSettings".tr(), style: Theme.of(context).textTheme.bodyLarge,),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).cardColor),
            onPressed: () {
              showMesaj(context, ref);
            }, 
            child: Text("navigation.sayacResetBtn".tr(), style: Theme.of(context).textTheme.labelSmall,)
          ),
        )


      ],
    );
  }


  Future showMesaj (BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("navigation.sayacReset".tr(), style: Theme.of(context).textTheme.bodyMedium,),
          actions: [
            TextButton(onPressed: () {
              ref.read(photoCounterProvider.notifier).state = 0;
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("navigation.sayacMessage".tr(), style: Theme.of(context).textTheme.bodyMedium,), backgroundColor: Theme.of(context).cardColor, duration: Duration(milliseconds: 500),));
            }, child: Text("navigation.yes".tr(), style: Theme.of(context).textTheme.bodySmall,)),

            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text("navigation.no".tr(), style: Theme.of(context).textTheme.bodySmall,))
          ],
        );
      }
    );
  }


}



class SavedContentTab extends ConsumerStatefulWidget {
  const SavedContentTab({super.key});

  @override
  ConsumerState<SavedContentTab> createState() => _SavedContentTabState();
}

class _SavedContentTabState extends ConsumerState<SavedContentTab> {

  @override
  Widget build(BuildContext contextf) {

    var contentGridList = ref.watch(contentSaveProvider);

    return Column(
      children: [

        SizedBox(height: 5,),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: IconButton(onPressed: () {
                searcItem(contentGridList);
              }, icon: Icon(Icons.search, fontWeight: FontWeight.bold,color: Theme.of(context).iconTheme.color,))
            ),
          ],
        ),        
        
        SizedBox(height: 5,),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, childAspectRatio: 0.95, mainAxisSpacing: 10), 
              itemCount: contentGridList.length,
              itemBuilder: (context, index) {
                final item = contentGridList[index];
                return GestureDetector(
                  onTap: () {
                    ref.read(contentProvider.notifier).state = item.allContent;
                    ref.read(photoTakenProvider.notifier).state = item.image;
                    ref.read(onSaveProvider.notifier).state = item.isSave;
                    ref.read(saveIdProvider.notifier).state = item.Id;
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => DetaySayfasi(itemIndex: index,)));
                    //print("İTEM İNDEXİ : $index");
                  },
                  child: ContentSavedCard(image: item.image, allContent: item.allContent)
                );
              }
            ),
          ),
        ),

      ],
    );
  }

   searcItem (List<ContentSaveModel> list) {
    showSearch(context: context, delegate: CustomSearchDelegate(list));
  }
}






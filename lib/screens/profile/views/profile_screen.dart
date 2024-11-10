import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:tinder_yt/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:tinder_yt/blocs/setup_data_bloc/setup_data_bloc.dart';
import 'package:tinder_yt/screens/profile/views/add_photo_screen.dart';
import '../../auth/blocs/sign_in_bloc/sign_in_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var user = context.read<AuthenticationBloc>().state.user;
    if (user != null) {
      descriptionController.text = user.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final user = context.read<AuthenticationBloc>().state.user;
          if (user != null) {
            setState(() {
              user.description = descriptionController.text;
            });

            context.read<SetupDataBloc>().add(SetupRequired(user));
          }
        },
        child: const Icon(CupertinoIcons.check_mark, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(const SignOutRequired());
            },
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Photos",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 9 / 16,
                    ),
                    itemBuilder: (context, i) {
                      var user = context.read<AuthenticationBloc>().state.user;
                      bool hasPicture = user != null &&
                          user.pictures.isNotEmpty &&
                          i < user.pictures.length;

                      return GestureDetector(
                        onTap: () async {
                          if (user != null && !hasPicture) {
                            var photos = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddPhotoScreen(),
                              ),
                            );
                            if (photos != null && photos.isNotEmpty) {
                              setState(() {
                                user.pictures.addAll(photos);
                              });
                            }
                          }
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: hasPicture
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                        image: (user.pictures[i] as String).startsWith('https')
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(user.pictures[i]),
                                              )
                                            : DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(File(user.pictures[i])),
                                              ),
                                      ),
                                    )
                                  : DottedBorder(
                                      color: Colors.grey.shade700,
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(8),
                                      dashPattern: const [6, 6, 6, 6],
                                      padding: EdgeInsets.zero,
                                      strokeWidth: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                  child: Center(
                                    child: hasPicture
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                user.pictures.removeAt(i);
                                              });
                                            },
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.grey),
                                                color: Colors.white,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Image.asset(
                                                  'assets/icons/clear.png',
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Image.asset(
                                                'assets/icons/add.png',
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

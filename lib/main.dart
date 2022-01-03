import 'package:data/advert/repository/firebase_advert_repository.dart';
import 'package:data/auth/repository/firebase_auth_repository.dart';
import 'package:data/auth/repository/firebase_user_repository.dart';
import 'package:data/chats/repository/firebase_chat_repository.dart';
import 'package:data/images/profile_avatar/repository/firebase_images_storage_repository.dart';
import 'package:domain/repository/advertisement_repository.dart';
import 'package:domain/repository/auth_repository.dart';
import 'package:domain/repository/chat_repository.dart';
import 'package:domain/repository/image_upload_repository.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fastmarket/app/app.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = true;
  await Firebase.initializeApp();
  Fimber.plantTree(DebugTree());

  final UserRepository userRepository = FirebaseUserRepository();
  final FireBaseImagesStorageRepository imageUploadRepository = FireBaseImagesStorageRepository();

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepository>
        (create: (context) => FirebaseAuthRepository(userRepository)),
      RepositoryProvider<UserRepository>(
          create: (context) => userRepository),
      RepositoryProvider<ImageUploadRepository>(create: (context) => imageUploadRepository),
      RepositoryProvider<AdvertisementRepository>(create: (context) => FirebaseAdvertRepository(imageUploadRepository)),
      RepositoryProvider<ChatRepository>(create: (context) => FirebaseChatRepository())
    ],
    child: App.withBloc(),
  ));
}




/*
  This file will run tests related to signing in or invisible authentication
  processes.
 */

import 'package:beautyreformatory/services/controllers/user_controller.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('user', () {
    test('create', () async {
      User user = await (new UserController()).
        create(email: 'ashwyn.horton@ashio.me', password: 'gbaby100', fullname: 'Ashwyn D. Horton', location: 'eSwatini', mobile: '78138052');

      expect(user, isInstanceOf<User>());
    });

    group('authentication', () {
      User user;
      setUp(() async {
        user = await (new UserController()).
          authenticate(email: 'ashwyn.horton@ashio.me', password: 'gbaby100');
      });

      test('auth', () async {
        expect(user, isInstanceOf<User>());
      });
      test('profile', () async {
        expect(await (new UserController()).
          getprofile(email: 'ashwyn.horton@ashio.me', token: user.token), isInstanceOf<User>());
      });
      test('update', () async {
        expect(await (new UserController()).
        update(email: 'ashwyn.horton@ashio.me', token: user.token, fullname: 'Ashwyn Horton'), isInstanceOf<User>());
      });
    });
  });

}
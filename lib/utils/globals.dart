library my_prj.globals;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:carbon_footprint_calculator/screens/achievements.dart';

int tab = 0;
GoogleSignInAccount? currentUser;
int? userid;
Map<String, String> headers = {"Content-Type": "application/json"};
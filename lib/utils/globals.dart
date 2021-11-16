library my_prj.globals;
import 'package:google_sign_in/google_sign_in.dart';

int tab = 0;
GoogleSignInAccount? currentUser;
int? userid;
Map<String, String> headers = {"Content-Type": "application/json"};
import 'dart:convert';
import 'package:admin/user/user.dart';
import 'package:admin/user/user_provider.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import '../Dto/CMRespDto.dart';
import '../Dto/LoginReqDto.dart';
import '../Dto/RegisterReqDto.dart';
import '../Token/register_code.dart';
import '../Token/token.dart';


// 통신을 호출해서 응답되는 데이터를 가공 json > object (tojson)

class UserRepository {
  final UserProvider _userProvider = UserProvider();

  Future<void> register(String user_id,String password, String school_code, String class_code,String username, String email) async {
    RegisterReqDto registerReqDto = RegisterReqDto(user_id,password, school_code,class_code,username, email);
    print(registerReqDto.toJson());
    Response response = await _userProvider.register(registerReqDto.toJson());
    dynamic body = response.body;
    print("test: ${body}");


    CMRespDto RegisterNewDto = CMRespDto.fromJson(body);
    register_code = RegisterNewDto.code;
    print("RegisterNewDto : ${RegisterNewDto.code}");
    print("register_code: ${register_code}");
    register_code = RegisterNewDto.code;
    print(register_code);
  }

  Future<User> login(String userid, String password) async {
    LoginReqDto loginReqDto = LoginReqDto(userid, password);
    print(loginReqDto.toJson());
    Response response = await _userProvider.login(loginReqDto.toJson());
    dynamic headers = response.headers; // headers 함수 = 서버에서 보내는 응답헤더;
    dynamic body;
    //print("body ${response.body}");
    if (response.body.runtimeType == String) {
      body = jsonDecode(response.body);
    } else {
      body = response.body;
    }
    //print("test: ${headers}");
    CMRespDto cmRespDto = CMRespDto.fromJson(body);
    print(cmRespDto.code);
    if (cmRespDto.code == 1) {
      User principal = User.fromJson(cmRespDto.data);

      String token = headers["authorization"];

      jwtToken = token;
     print("JwtToken: $jwtToken");

      return principal;
    } else {
      return User();
    }

    // if (headers["authorization"] == null) {
    //   return "-1";          // 헤더의 authorization 값이 널이면 통신비정상
    // } else {
    //   String token = headers["authorization"];
    //   return token;               //token에 authorization에 있는 응답토큰값저장
    // }
  }
}

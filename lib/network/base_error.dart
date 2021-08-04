class BadRequestError implements Exception {
  final String msg;
  BadRequestError(this.msg);
}

class InternalServerError implements Exception {
  final String? msg;
  InternalServerError({this.msg});
  static to() {
    return InternalServerError(msg: "Servis kaynaklı bir hata oluştu.Daha sonra tekrar deneyiniz");
  }
}

class NotFound implements Exception {
  final String? msg;
  NotFound({this.msg});
  static to() {
    return NotFound(msg: "Aradıgınız bulunamadı");
  }
}

class AuthorizeError implements Exception {
  final String? msg;
  AuthorizeError({this.msg});
  static to() {
    return AuthorizeError(msg: "Oturumunuzun süresi dolmuş.Yeniden giriş yapınız");
  }
}

// ignore_for_file: non_constant_identifier_names, prefer_const_declarations

final RegExp EMAIL_VALIDATION_REGEX = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
final RegExp PASSWORD_VALIDATION_REGEX = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$");
final RegExp NAME_VALIDATION_REGEX = RegExp(r"^[A-Za-z\s]+$");
final String PLACEHOLDER_PFP = "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y";

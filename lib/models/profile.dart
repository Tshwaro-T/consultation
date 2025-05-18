/// Student Numbers:        221001482,        222043497,                   2221013309,              221014333,            222075927
/// Student Names:  Koena Mosa Ramela, Tshwaro Thothela, Selloane Relebohile Letsoara, Vinjiwe Onica Precious, Lesego Ignny Moutlana
/// Question: Add Profile 
library;


import 'dart:io';

class Profile {
   String name;
   String role;
   String email;
   String phone;
   File? image;

  Profile({
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    this.image,
  });
}
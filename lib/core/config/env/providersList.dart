import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/env/providersList/AboutJci_providers.dart';
import 'package:jci_app/core/config/env/providersList/Auth_providers.dart';
import 'package:jci_app/core/config/env/providersList/Home_providers.dart';
import 'package:jci_app/core/config/env/providersList/Intro_providers.dart';
import 'package:jci_app/core/config/env/providersList/Member_providers.dart';
import 'package:jci_app/core/config/env/providersList/Team_providers.dart';
import 'package:provider/single_child_widget.dart';


List<SingleChildWidget> providersList = [
  ...authProviders,
  ...homeProviders,
  ...memberProviders,
  ...teamProviders,
  ...aboutJciProviders,
  ...introProviders,
];
import 'package:Bucoride_Driver/screens/auth/phone_login.dart';
import 'package:Bucoride_Driver/screens/auth/registration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../helpers/screen_navigation.dart';
import '../../providers/app_provider.dart';
import '../../providers/user.dart';
import '../../utils/app_constants.dart';
import '../../utils/dimensions.dart';
import '../../utils/images.dart';
import '../../widgets/loading.dart';
import '../menu.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _loginScaffoldKey = GlobalKey<ScaffoldState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    final appState = Provider.of<AppStateProvider>(context);
    return Scaffold(
      key: _loginScaffoldKey,
      backgroundColor: AppConstants.lightPrimary,
      body: authProvider.status == Status.Authenticating
          ? Loading()
          : SafeArea(
              child: _fadeAnimation == null
                  ? Center(
                      child: Loading()) // Avoid using it before initialization
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                  Image.asset(Images.logoWithName, height: 75),
                                  const SizedBox(height: Dimensions.paddingSize),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${'Welcome to'.tr} ' +
                                            AppConstants.appName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      Image.asset(Images.hand, width: 40),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              _buildTextField(authProvider.email, 'Email',
                                  Icons.email, false),
                              _buildTextField(authProvider.password, 'Password',
                                  Icons.lock, true),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () => authProvider
                                          .toggleRememberMe(), // Makes entire row clickable
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                authProvider.toggleRememberMe(),
                                            child: Container(
                                              width: Dimensions.iconSizeMedium,
                                              height: Dimensions.iconSizeMedium,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blueAccent,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: authProvider
                                                        .isActiveRememberMe
                                                    ? Colors.blueAccent
                                                    : Colors.transparent,
                                              ),
                                              child: authProvider
                                                      .isActiveRememberMe
                                                  ? Icon(Icons.check,
                                                      color: Colors.white,
                                                      size:
                                                          18) // Blue tick when checked
                                                  : null,
                                            ),
                                          ),
                                          const SizedBox(
                                              width:
                                                  Dimensions.paddingSizeSmall),
                                          GestureDetector(
                                            onTap: () =>
                                                authProvider.toggleRememberMe(),
                                            child: Text(
                                              'remember me'.tr,
                                              style: TextStyle(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      changeScreen(
                                          context, ForgotPasswordScreen());
                                    },
                                    child: Text(
                                      'forgot password'.tr,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Dimensions.fontSizeDefault,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              _buildLoginButton(authProvider, appState),
                              const SizedBox(height: 16.0),
                              _buildDivider(),
                              const SizedBox(height: 16.0),
                              _buildOtpLoginButton(),
                              const SizedBox(height: 16.0),
                              _buildRegisterLink(context),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: Dimensions.fontSizeSmall),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: Dimensions.fontSizeSmall),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Colors.black, width: 2.5),
          ),
          prefixIcon: Icon(icon, color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
      UserProvider authProvider, AppStateProvider appState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          String resultMessage = await authProvider.signIn();
          if (resultMessage != "Success") {
            appState.showCustomSnackBar(
                context, resultMessage, AppConstants.darkPrimary);
            return;
          }
          authProvider.clearController();
          changeScreenReplacement(context, Menu());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(vertical: 14.0),
        ),
        child: Text(
          'Log in'.tr,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.fontSizeSmall),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 0.1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('or'.tr, style: TextStyle(color: Colors.grey)),
        ),
        const Expanded(child: Divider(thickness: 0.1)),
      ],
    );
  }

  Widget _buildOtpLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          changeScreen(context, PhoneLoginScreen());
        },
        style: OutlinedButton.styleFrom(
          shape: StadiumBorder(),
          side: BorderSide(color: Colors.blueAccent),
          padding: EdgeInsets.symmetric(vertical: 14.0),
        ),
        child: Text(
          'OTP Login'.tr,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: Dimensions.fontSizeSmall),
        ),
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${'Create an account'.tr} '),
        TextButton(
          onPressed: () => changeScreen(context, RegistrationScreen()),
          child: Text(
            'Register here',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Colors.blue),
          ),
        ),
      ],
    );
  }
}

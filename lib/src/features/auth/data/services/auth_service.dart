import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fly_journey/src/core/config/api_config.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'] ?? json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
    };
  }
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null && _accessToken != null;
  String? get accessToken => _accessToken;

  // Load user data from SharedPreferences on app start
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    final token = prefs.getString('access_token');
    final refresh = prefs.getString('refresh_token');

    if (userJson != null && token != null) {
      _currentUser = User.fromJson(json.decode(userJson));
      _accessToken = token;
      _refreshToken = refresh;
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null && _accessToken != null) {
      await prefs.setString('user', json.encode(_currentUser!.toJson()));
      await prefs.setString('access_token', _accessToken!);
      if (_refreshToken != null) {
        await prefs.setString('refresh_token', _refreshToken!);
      }
    }
  }

  // Clear user data from SharedPreferences
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🔐 Attempting login for: $email');
      
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}');
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(ApiConfig.requestTimeout);

      print('🌐 Login response status: ${response.statusCode}');
      print('📦 Login response body: ${response.body}');

      // Check if response body is empty or null
      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server không trả về dữ liệu',
          'error': 'Empty response body',
        };
      }

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('❌ JSON parsing error: $e');
        return {
          'success': false,
          'message': 'Lỗi định dạng dữ liệu từ server',
          'error': 'JSON parsing failed: $e',
        };
      }

      if (response.statusCode == 200 && responseData['status'] == true) {
        // Successful login
        final data = responseData['data'];
        if (data == null) {
          return {
            'success': false,
            'message': 'Dữ liệu đăng nhập không hợp lệ',
            'error': 'Missing data field',
          };
        }

        // Check if data contains user info directly or in a user object
        Map<String, dynamic> userData;
        if (data['user'] != null) {
          // Case 1: user data is in a 'user' object
          userData = data['user'];
        } else {
          // Case 2: user data is directly in 'data'
          userData = {
            'id': data['user_id']?.toString() ?? '',
            'name': data['name'] ?? '',
            'email': data['email'] ?? '',
            'role': data['role'] ?? '',
          };
        }
        
        _currentUser = User.fromJson(userData);
        
        // Handle token - could be 'token', 'access_token', or in tokens object
        _accessToken = data['token'] ?? 
                      data['access_token'] ?? 
                      data['tokens']?['access_token'] ?? 
                      data['tokens']?['accessToken'];
        
        _refreshToken = data['refresh_token'] ?? 
                       data['tokens']?['refresh_token'] ?? 
                       data['tokens']?['refreshToken'];
        
        if (_accessToken != null) {
          await _saveUserData();
        }
        
        return {
          'success': true,
          'message': responseData['message'] ?? responseData['errorMessage'] ?? 'Đăng nhập thành công!',
          'user': _currentUser,
        };
      } else {
        // API error
        return {
          'success': false,
          'message': responseData['message'] ?? responseData['errorMessage'] ?? 'Đăng nhập thất bại',
          'error': responseData['error'] ?? responseData['errorCode'],
        };
      }
    } catch (e) {
      print('❌ Login error: $e');
      return {
        'success': false,
        'message': 'Không thể kết nối đến server. Vui lòng thử lại.',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String phone, String password) async {
    try {
      print('📝 Attempting registration for: $email');
      
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}');
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: json.encode({
          'name': name,
          'full_name': name, // Some APIs might expect full_name
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': password, // Some APIs require this
        }),
      ).timeout(ApiConfig.requestTimeout);

      print('🌐 Register response status: ${response.statusCode}');
      print('📦 Register response body: ${response.body}');

      // Check if response body is empty or null
      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server không trả về dữ liệu',
          'error': 'Empty response body',
        };
      }

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('❌ JSON parsing error: $e');
        return {
          'success': false,
          'message': 'Lỗi định dạng dữ liệu từ server',
          'error': 'JSON parsing failed: $e',
        };
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Log OTP if it's included in the response
        if (responseData['otp'] != null) {
          print('🔢 OTP CODE: ${responseData['otp']}');
          print('📧 OTP sent to: ${email}');
        }
        if (responseData['data'] != null && responseData['data']['otp'] != null) {
          print('🔢 OTP CODE: ${responseData['data']['otp']}');
          print('📧 OTP sent to: ${email}');
        }
        
        // For OTP flow, don't auto-login - just return success
        return {
          'success': true,
          'message': responseData['message'] ?? responseData['errorMessage'] ?? 'OTP đã được gửi tới email của bạn!',
          'requiresOTP': true,
          'otp': responseData['otp'] ?? responseData['data']?['otp'], // Include OTP in response for debugging
        };
      }
      
      // API error
      return {
        'success': false,
        'message': responseData['message'] ?? responseData['errorMessage'] ?? 'Đăng ký thất bại',
        'error': responseData['error'] ?? responseData['errorCode'],
      };
    } catch (e) {
      print('❌ Registration error: $e');
      return {
        'success': false,
        'message': 'Không thể kết nối đến server. Vui lòng thử lại.',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> confirmRegister(String name, String email, String otp, String phone, String password) async {
    try {
      print('📝 Attempting OTP confirmation for: $email with OTP: $otp');
      
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.confirmRegister}');
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: json.encode({
          'name': name,
          'email': email,
          'otp': otp,
          'phone': phone,
          'password': password,
        }),
      ).timeout(ApiConfig.requestTimeout);

      print('🌐 Confirm Register response status: ${response.statusCode}');
      print('📦 Confirm Register response body: ${response.body}');

      // Check if response body is empty or null
      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server không trả về dữ liệu',
          'error': 'Empty response body',
        };
      }

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('❌ JSON parsing error: $e');
        return {
          'success': false,
          'message': 'Lỗi định dạng dữ liệu từ server',
          'error': 'JSON parsing failed: $e',
        };
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['status'] == true) {
          // Success - Extract tokens and user data
          final data = responseData['data'];
          if (data != null) {
            // Check if data contains user info directly or in a user object
            Map<String, dynamic> userData;
            if (data['user'] != null) {
              // Case 1: user data is in a 'user' object
              userData = data['user'];
            } else {
              // Case 2: user data is directly in 'data'
              userData = {
                'id': data['user_id']?.toString() ?? '',
                'name': data['name'] ?? '',
                'email': data['email'] ?? '',
                'role': data['role'] ?? '',
              };
            }
            
            _currentUser = User.fromJson(userData);
            
            // Handle token - could be 'token', 'access_token', or in tokens object
            _accessToken = data['token'] ?? 
                          data['access_token'] ?? 
                          data['tokens']?['access_token'] ?? 
                          data['tokens']?['accessToken'];
            
            _refreshToken = data['refresh_token'] ?? 
                           data['tokens']?['refresh_token'] ?? 
                           data['tokens']?['refreshToken'];
            
            if (_accessToken != null) {
              await _saveUserData();
            }
          }
          
          print('✅ Registration confirmed successfully for: ${_currentUser?.email}');
          
          return {
            'success': true,
            'message': responseData['message'] ?? responseData['errorMessage'] ?? 'Đăng ký thành công!',
            'user': _currentUser,
          };
        }
      }
      
      // Error response
      return {
        'success': false,
        'message': responseData['message'] ?? responseData['errorMessage'] ?? 'Xác thực OTP thất bại',
        'error': responseData['error'] ?? responseData['errorCode'],
      };
    } catch (e) {
      print('💥 Registration confirmation error: $e');
      
      String errorMessage = 'Có lỗi xảy ra khi xác thực OTP';
      if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Kết nối mạng chậm, vui lòng thử lại';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Không thể kết nối đến server';
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    }
  }

  Future<void> logout() async {
    try {
      if (_accessToken != null) {
        print('🚪 Attempting logout...');
        
        final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logout}');
        final response = await http.post(
          url,
          headers: {
            ...ApiConfig.headers,
            'Authorization': 'Bearer $_accessToken',
          },
        ).timeout(ApiConfig.requestTimeout);

        print('🌐 Logout response status: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Logout API error: $e');
      // Continue with local logout even if API fails
    }
    
    // Clear local data regardless of API response
    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;
    await _clearUserData();
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      print('🔄 Requesting password reset for: $email');
      
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.forgotPassword}');
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: json.encode({
          'email': email,
        }),
      ).timeout(ApiConfig.requestTimeout);

      print('🌐 Forgot password response status: ${response.statusCode}');
      print('📦 Forgot password response body: ${response.body}');

      // Check if response body is empty or null
      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Server không trả về dữ liệu',
          'error': 'Empty response body',
        };
      }

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('❌ JSON parsing error: $e');
        return {
          'success': false,
          'message': 'Lỗi định dạng dữ liệu từ server',
          'error': 'JSON parsing failed: $e',
        };
      }

      if (response.statusCode == 200 && responseData['status'] == true) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Email đặt lại mật khẩu đã được gửi!',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? responseData['errorMessage'] ?? 'Không thể gửi email đặt lại mật khẩu',
          'error': responseData['error'] ?? responseData['errorCode'],
        };
      }
    } catch (e) {
      print('❌ Forgot password error: $e');
      return {
        'success': false,
        'message': 'Không thể kết nối đến server. Vui lòng thử lại.',
        'error': e.toString(),
      };
    }
  }

  // Get authenticated headers for API requests
  Map<String, String> getAuthHeaders() {
    if (_accessToken != null) {
      return {
        ...ApiConfig.headers,
        'Authorization': 'Bearer $_accessToken',
      };
    }
    return ApiConfig.headers;
  }
}

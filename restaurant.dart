import 'dart:io';

void main() {
  List<Map<String, dynamic>> menu = [
    {'name': 'Pizza', 'price': 10, 'quantity': 0},
    {'name': 'Burger', 'price': 5, 'quantity': 0},
    {'name': 'Pasta', 'price': 8, 'quantity': 0},
    {'name': 'Salad', 'price': 6, 'quantity': 0}
  ];

  List<Map<String, String>> adminUsers = [
    {'username': 'admin1', 'password': 'admin1pass'},
    {'username': 'admin2', 'password': 'admin2pass'}
  ];

  List<Map<String, String>> customerUsers = [
    {'username': 'customer1', 'password': 'customer1pass'},
    {'username': 'customer2', 'password': 'customer2pass'}
  ];

  List<Map<String, dynamic>> bookings = [];

  bool isRunning = true;
  bool isAdmin = false;
  Map<String, String>? currentUser;

  List<bool> isTableAvailable = [true, true, true, true, true];
  int maxTables = 5;
  int bookingDurationInMinutes = 60;

  while (isRunning) {
    if (currentUser == null) {
      print('----- Restaurant Management System -----');
      print('1. Login as Admin');
      print('2. Login as Customer');
      print('3. Register as Customer');
      print('4. Exit');
      print('---------------------------------------');

      stdout.write('Enter your choice: ');
      String? choice = stdin.readLineSync();

      if (choice != null) {
        if (choice == '1') {
          print('\nAdmin Login:');
          stdout.write('Username: ');
          String? username = stdin.readLineSync();
          stdout.write('Password: ');
          String? password = stdin.readLineSync();

          if (username != null && password != null) {
            currentUser = adminUsers.firstWhere(
                (user) =>
                    user['username'] == username &&
                    user['password'] == password,
                orElse: () => {});
            if (currentUser.isNotEmpty) {
              isAdmin = true;
              print('\nWelcome, ${currentUser['username']}!\n');
            } else {
              print('Invalid username or password. Please try again.\n');
            }
          }
        } else if (choice == '2') {
          print('\nCustomer Login:');
          stdout.write('Username: ');
          String? username = stdin.readLineSync();
          stdout.write('Password: ');
          String? password = stdin.readLineSync();

          if (username != null && password != null) {
            currentUser = customerUsers.firstWhere(
                (user) =>
                    user['username'] == username &&
                    user['password'] == password,
                orElse: () => {});
            if (currentUser.isNotEmpty) {
              isAdmin = false;
              print('\nWelcome, ${currentUser['username']}!\n');
            } else {
              print('Invalid username or password. Please try again.\n');
            }
          }
        } else if (choice == '3') {
          print('\nCustomer Registration:');
          stdout.write('Username: ');
          String? username = stdin.readLineSync();
          stdout.write('Password: ');
          String? password = stdin.readLineSync();

          if (username != null && password != null) {
            customerUsers.add({'username': username, 'password': password});
            print(
                '\nRegistration successful. You can now login as a customer.\n');
          }
        } else if (choice == '4') {
          isRunning = false;
        } else {
          print('Invalid choice. Please try again.\n');
        }
      }
    } else {
      print('----- Restaurant Management System -----');
      if (isAdmin) {
        print('1. View Orders');
        print('2. View Bookings');
      } else {
        print('1. View Menu');
        print('2. Add Item to Order');
        print('3. View Order');
        print('4. Checkout');
        print('5. Book a Table');
      }
      print('6. Logout');
      print('7. Exit');
      print('---------------------------------------');

      stdout.write('Enter your choice: ');
      String? choice = stdin.readLineSync();

      if (choice != null) {
        if (isAdmin) {
          if (choice == '1') {
            print('\nOrders:');
            for (int i = 0; i < menu.length; i++) {
              if (menu[i]['quantity'] > 0) {
                print('${menu[i]['name']} - Quantity: ${menu[i]['quantity']}');
              }
            }
            print('');
          } else if (choice == '2') {
            print('\nBookings:');
            DateTime now = DateTime.now();
            for (int i = 0; i < bookings.length; i++) {
              Map<String, dynamic> booking = bookings[i];
              DateTime bookingTime = booking['bookingTime'];
              int tableNumber = booking['tableNumber'];

              if (bookingTime.isBefore(now)) {
                // If booking time is in the past, mark the table as available again
                isTableAvailable[tableNumber - 1] = true;
              }

              print(
                  'Username: ${booking['username']}, Table Number: $tableNumber, Time: ${bookingTime.toString()}');
            }
            print('');
          } else if (choice == '6') {
            currentUser = null;
            isAdmin = false;
            print('\nLogged out successfully.\n');
          } else if (choice == '7') {
            isRunning = false;
          } else {
            print('Invalid choice. Please try again.\n');
          }
        } else {
          if (choice == '1') {
            print('\nMenu:');
            for (int i = 0; i < menu.length; i++) {
              print('${i + 1}. ${menu[i]['name']} - \$${menu[i]['price']}');
            }
            print('');
          } else if (choice == '2') {
            stdout.write('Enter item number: ');
            String? itemNumberInput = stdin.readLineSync();
            if (itemNumberInput != null) {
              int itemNumber = int.tryParse(itemNumberInput) ?? 0;
              if (itemNumber >= 1 && itemNumber <= menu.length) {
                stdout.write('Enter quantity: ');
                String? quantityInput = stdin.readLineSync();
                if (quantityInput != null) {
                  int quantity = int.tryParse(quantityInput) ?? 0;
                  if (quantity >= 1) {
                    menu[itemNumber - 1]['quantity'] += quantity;
                    print('Item added to order.');
                  } else {
                    print('Invalid quantity. Please try again.');
                  }
                }
              } else {
                print('Invalid item number. Please try again.');
              }
              print('');
            }
          } else if (choice == '3') {
            print('\nOrder:');
            for (int i = 0; i < menu.length; i++) {
              if (menu[i]['quantity'] > 0) {
                print('${menu[i]['name']} - Quantity: ${menu[i]['quantity']}');
              }
            }
            print('');
          } else if (choice == '4') {
            double total = 0;
            print('\nOrder Summary:');
            for (int i = 0; i < menu.length; i++) {
              if (menu[i]['quantity'] > 0) {
                double itemTotal =
                    menu[i]['price'] * menu[i]['quantity'].toDouble();
                total += itemTotal;
                print(
                    '${menu[i]['name']} - Quantity: ${menu[i]['quantity']}, Subtotal: \$${itemTotal.toStringAsFixed(2)}');
              }
            }
            print('Total: \$${total.toStringAsFixed(2)}\n');
            isRunning = false;
          } else if (choice == '5') {
            DateTime now = DateTime.now();
            stdout.write('Enter table number: ');
            String? tableNumberInput = stdin.readLineSync();
            if (tableNumberInput != null) {
              int tableNumber = int.tryParse(tableNumberInput) ?? 0;
              if (tableNumber >= 1 && tableNumber <= maxTables) {
                if (isTableAvailable[tableNumber - 1]) {
                  DateTime bookingTime =
                      now.add(Duration(minutes: bookingDurationInMinutes));
                  bookings.add({
                    'username': currentUser['username'],
                    'tableNumber': tableNumber,
                    'bookingTime': bookingTime
                  });
                  isTableAvailable[tableNumber - 1] =
                      false; // Mark the table as unavailable
                  print(
                      '\nTable ${tableNumber} booked successfully. Enjoy your meal!\n');
                } else {
                  print(
                      '\nTable ${tableNumber} is already reserved. Please choose another table or try again later.\n');
                }
              } else {
                print('Invalid table number. Please try again.\n');
              }
            }
          } else if (choice == '6') {
            currentUser = null;
            isAdmin = false;
            print('\nLogged out successfully.\n');
          } else if (choice == '7') {
            isRunning = false;
          } else {
            print('Invalid choice. Please try again.\n');
          }
        }
      }
    }
  }

  print('Thank you for using the Restaurant Management System!');
}

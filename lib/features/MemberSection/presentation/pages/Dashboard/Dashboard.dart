import '../../../../Home/Activity_Global.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  static NavigateToDahboard(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminDashboard(),
      ),
    );
  }
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to the Admin Dashboard",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

              },
              child: const Text("Go to Dashboard"),
            ),
          ],
        ),
      ),


    );
  }
  // show the admin dahsboard with navigation bar and drawer


}

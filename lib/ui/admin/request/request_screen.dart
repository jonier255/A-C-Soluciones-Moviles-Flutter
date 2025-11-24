import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/request/request_bloc.dart';
import '../../../bloc/request/request_event.dart';
import 'widgets/request_bottom_nav.dart';
import 'widgets/request_header.dart';
import 'widgets/request_list_content.dart';
import 'widgets/request_screen_constants.dart';

/// Request screen - displays list of service requests with pagination
class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RequestBloc>().add(FetchRequests());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: RequestScreenTheme.backgroundColor,
      bottomNavigationBar: RequestBottomNavBar(),
      body: Stack(
        children: [
          RequestScreenHeader(),
          RequestListContent(),
        ],
      ),
    );
  }
}
